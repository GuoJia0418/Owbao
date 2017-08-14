//
//  JSInvestFinancingActivityController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/11.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  理财列表、活动列表

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSInvestFinancingActivityController: BaseViewController,SDCycleScrollViewDelegate {

    var model: InvestmentModel?               //列表数据model
    var type: Int = 2                         //type: 1:活动  2:优选理财
    var cycleView: SDCycleScrollView?         //轮播图
    var bannerModel: JSProductActivityBannerModel?
    
    var pageIndex: Int?                                   //第几页
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()                //初始化并进行刷新数据
        
        self.pageIndex = 1
        self.loadData()
        
        if self.type == 1 {
            self.loadBannerData()
        }
        
        self.listView.tableFooterView = UIView()
        
        //下拉刷新
        self.listView.mj_header = MJRefreshNormalHeader {
             self.pageIndex = 1
             self.loadData()
        }
        
        //上啦刷新
        let footer = MJRefreshAutoStateFooter {
            self.loadData()
        }
        self.listView.mj_footer = footer
        self.isShowLeftItem = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //MARK: - 获取数据
    override func loadData() {
       
        self.loadListData()
    }
    
    //MARK: - 刷新数据
    func refreshData() {
        
        self.pageIndex = 1
        self.loadData()
    }
    
    //MARK: 初始化
    func setupView() {
        
        listView.backgroundColor = DEFAULT_BGCOLOR
        
        if self.type == 1 {
            navigationItem.title = "活动专享标"
        } else {
            navigationItem.title = "优选理财"
        }
    }
    
    //下载banner数据
    func loadBannerData() {
        
        let viewModel = JSProductActivityBannerViewModel()
        self.view.showLoadingHud()
        viewModel.startLoadingData(JSProductActivityBannerApi(Uid: UserModel.shareInstance.uid ?? 0),
                                   controller: self,
                                   modelName: "JSProductActivityBannerModel",
                                   callback: { (returnValue) in
                
                                   let model = returnValue as! JSProductActivityBannerModel
                                   self.bannerModel = model
                                   self.loadBanner(model.map?.sysBanners)

            }) { (errorCode) in
                self.view.showTextHud(errorCode as! String)
        }
    }
    
    //MARK: 获取数据 - 列表数据
    func loadListData() {
        
        weak var weakSelf = self
        print("产品列表的pageIndex = \(self.pageIndex!)")
        
        InvestmentApi(PageOn: self.pageIndex!,
            Uid: UserModel.shareInstance.uid ?? 0,
            Type: self.type,
            Status: 0,
            PageSize: 6).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            
            weakSelf!.listView.mj_footer.resetNoMoreData()
            weakSelf!.listView.mj_header.endRefreshing()
            
            weakSelf!.view.hideHud()
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let superModel:InvestmentModel = InvestmentModel(dict: resultDict!)
            print("我要投资 -- 列表数据\(resultDict)== \(superModel.map?.activity_60) == \(superModel.map?.activity_180)")
            
            if superModel.success {
                
                if weakSelf!.pageIndex! == 1 {
                    weakSelf!.model = superModel
                } else {
                    for a in (superModel.map?.page?.rows)! {
                        weakSelf!.model?.map?.page?.rows.append(a)
                    }
                }
                if weakSelf!.pageIndex! >= superModel.map?.page?.totalPage {
                    weakSelf!.listView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    weakSelf!.listView.mj_footer.endRefreshing()
                    weakSelf!.pageIndex! += 1
                }
                weakSelf!.listView.reloadData()

            } else {
                weakSelf!.listView.mj_footer.endRefreshing()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }
    
    //MARK: - Banner视图刷新 banner数组
    func loadBanner(_ banner: [JSProductActivityBannerRowModel]?) {
        
        if banner != nil && banner?.count > 0 {
         
            if cycleView == nil {
                cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 130 * SCREEN_WIDTH / 320), delegate: self, placeholderImage:UIImage(named: "problem"))
                cycleView!.autoScrollTimeInterval = 4.0
                cycleView!.delegate = self
                listView.tableHeaderView = cycleView!
            }
            
            var imagesURLString = [String]()
            for a in banner! {
                
                if a.imgUrl != "" {
                    imagesURLString.append(a.imgUrl)
                } else {
                    //图片数量跟model数据数组一一对应的，点击才不会出错
                    imagesURLString.append("")
                }
            }
            
            cycleView!.imageURLStringsGroup = imagesURLString
            listView.tableHeaderView = cycleView!
        }
    }
    
    //MARK:轮播器点击事件的代理方法
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!,
                         didSelectItemAt index: Int) {
        
        if self.bannerModel?.map?.sysBanners[index].location != nil && (self.bannerModel?.map?.sysBanners[index].location)!.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            
            let model = self.bannerModel?.map?.sysBanners[index]
            
            let web = LocationController()
            web.model = HomeBannerModel(dict: ["location": (model?.location)! as AnyObject,"title": (model?.title)! as AnyObject])
            
            if model?.id != nil { //productID: 产品ID，用户有时候页面跳转传递ID
                web.productID = model?.id
            }

            self.navigationController?.pushViewController(web, animated: true)
        }
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        if self.model != nil {
            return (self.model?.map?.page?.rows.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestProductListFirstCell") as! JSInvestProductListFirstCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("JSInvestProductListFirstCell", owner: self, options: nil)?.last as? JSInvestProductListFirstCell
        }
        
        if self.model?.map!.page?.rows.count != 0 {
            cell?.refreshView((self.model?.map!.page?.rows[indexPath.section])!,type:self.type)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            if self.bannerModel != nil && self.bannerModel?.map?.sysBanners.count > 0 { //这个模型存在，表示该控制器是90天活动标的控制器
                return 15.0
            }
        }
        return 0.00001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if model?.map?.page?.rows[indexPath.section].atid != 0 {
            MobClick.event("0400031")
        }
        
        if model?.map?.page?.rows[indexPath.section].prizeId != 0 {
            MobClick.event("0400050")
        }
        
        let productDetailVC = JSInvestDetailViewController()
        productDetailVC.productNameID = model?.map?.page?.rows[indexPath.section].id
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvestFinancingActivityController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
