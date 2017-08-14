//
//  JSInvestmentViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

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


class JSInvestmentViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var listView: UITableView!
    var type: Int = 2                            //type: 1:活动  2:优选理财
    
    fileprivate var pageIndex: Int?
    fileprivate var model: InvestmentModel?          //列表数据model
    
    //headerView
    var firstSectionHeaderView: JSInvestActivityHeadView? = {
        let view = Bundle.main.loadNibNamed("JSInvestActivityHeadView", owner: nil, options: nil)!.last as! JSInvestActivityHeadView
        return view
    }()
    
    var secondSectionHeaderView: JSInvestActivityHeadView? = {
        let view = Bundle.main.loadNibNamed("JSInvestActivityHeadView", owner: nil, options: nil)!.last as! JSInvestActivityHeadView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()          //初始化并进行刷新数据
        
        self.listView.mj_header = MJRefreshNormalHeader {
            self.pageIndex = 1
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageIndex = 1
        self.loadData()
    }
    
    //MARK: 初始化
    func setupView() {
        listView.backgroundColor = DEFAULT_BGCOLOR
        navigationItem.title = "理财"
        self.isShowLeftItem = false
    }
    
    //MARK: - 刷新数据
    func refreshData() {
        self.pageIndex = 1
        self.loadData()
    }
    
    //MARK: - 获取数据 - 新手标数据
    override func loadData() {
        self.loadListData()
    }
    
    //MARK: 获取数据 - 列表数据
    func loadListData() {
        
        weak var weakSelf = self
        print("产品列表的pageIndex = \(self.pageIndex!)")
        InvestmentApi(PageOn: self.pageIndex!,
            Uid: UserModel.shareInstance.uid ?? 0,
            Type: self.type,
            Status: 5,
            PageSize: 100).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let superModel: InvestmentModel = InvestmentModel(dict: resultDict!)
            print("我要投资 -- 列表数据\(resultDict)== \(superModel.map?.activity_60) == \(superModel.map?.activity_180)")
            
            weakSelf?.listView.mj_header.endRefreshing()
                
            if superModel.success {
                
                if weakSelf!.pageIndex! == 1 {
                    weakSelf!.model = superModel
                } else {
                    for a in (superModel.map?.page?.rows)! {
                        weakSelf!.model?.map?.page?.rows.append(a)
                    }
                }
                
                if weakSelf!.pageIndex! >= superModel.map?.page?.totalPage {
//                    weakSelf!.listView.mj_footer.endRefreshingWithNoMoreData()
                } else {
//                    weakSelf!.listView.mj_footer.endRefreshing()
                    weakSelf!.pageIndex! += 1
                }
                weakSelf!.listView.reloadData()
                
            } else {
//                weakSelf!.listView.mj_footer.endRefreshing()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
            weakSelf!.listView.mj_header.endRefreshing()
//            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }
    
    //MARK: 刷新列表某一段数据,以当前选中的index来刷新
    func refreshListDataInModelArray(_ selectIndex: Int) -> () {
        
        let refreshModel: InvestmentRowModel = (self.model?.map?.page?.rows[selectIndex])!
        
        InvestmentApi(PageOn: self.pageIndex!,
            Uid: UserModel.shareInstance.uid ?? 0,
            Type: self.type,
            Status: 5,
            PageSize: 6).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let superModel: InvestmentModel = InvestmentModel(dict: resultDict!)
            
            if superModel.success {
                
                let array_load = NSArray(array: (superModel.map?.page?.rows)!)
                let subArray = array_load.filtered(using: NSPredicate(format: "id == %@", argumentArray: [refreshModel.id]))
                
                let newModel = subArray[0] as! InvestmentRowModel
                //开始替换
                self.model?.map?.page?.rows[selectIndex] = newModel
                //刷新
                self.listView.reloadData()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            self.view.showTextHud("网络错误")
        }
    }

    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if self.model == nil {
                return 0
            } else {
                return (self.model?.map?.page?.rows.count)!
            }
        } else {
            if self.model == nil {
                return 0
            }
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10.0
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 100 * SCREEN_SCALE_W
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestProductListHomeCell") as! JSInvestProductListHomeCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSInvestProductListHomeCell", owner: self, options: nil)?.last as? JSInvestProductListHomeCell
            }
            
            if self.model?.map!.page?.rows.count != 0 {
                cell?.refreshView((self.model?.map!.page?.rows[indexPath.row])!)
            }
            return cell!
            
//            var cell = tableView.dequeueReusableCellWithIdentifier("JSInvestProductListCell") as! JSInvestProductListCell!
//            
//            if cell == nil {
//                cell = JSInvestProductListCell(style: .Default, reuseIdentifier: "JSInvestProductListCell")
//            }
//            
//            cell.selectionStyle = .None
//            
//            if self.model?.map!.page?.rows.count != 0 {
//                cell.refreshView((self.model?.map!.page?.rows[indexPath.row])!)
//            }
//            
//            return cell
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestmentListActivityCell") as! JSInvestmentListActivityCell!
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestmentListActivityCell", owner: nil, options: nil)?.last as? JSInvestmentListActivityCell
            }
            
            if self.model != nil && self.model?.map != nil && self.model?.map?.activityProduct != nil {
                cell!.configureCell(self.model?.map?.activityProduct)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            self.firstSectionHeaderView?.configureHeaderView(0)
            
            //优选理财点击回调
            self.firstSectionHeaderView?.tapCallback = { (index: Int) in
                MobClick.event("0400002")
                let controller = JSInvestFinancingActivityController()
                controller.type = 2
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            return self.firstSectionHeaderView
            
        } else {
            
            self.secondSectionHeaderView?.configureHeaderView(1)
            //90天活动标HeaderView点
            self.secondSectionHeaderView?.tapCallback = { (index: Int) in
                MobClick.event("0400030")
                let controller = JSInvestFinancingActivityController()
                controller.type = 1
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            return self.secondSectionHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return JSInvestActivityHeadView.viewHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            let deadline = model?.map?.page?.rows[indexPath.row].deadline
            if deadline == 35{
                MobClick.event("0400003")
            }else if deadline == 60{
                MobClick.event("0400004")
            }else if deadline == 180{
                MobClick.event("0400005")
            }
            let productDetailVC = JSInvestDetailViewController()
            productDetailVC.productNameID = model?.map?.page?.rows[indexPath.row].id
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        } else if indexPath.section == 1 {
            MobClick.event("0400030")
            let controller = JSInvestFinancingActivityController()
            controller.type = 1
            self.navigationController?.pushViewController(controller, animated: true)
        }                                                    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvestmentViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
