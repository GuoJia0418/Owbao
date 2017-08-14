//
//  MainViewController.swift
//  Owbao
//
//  Created by Panda on 16/7/11.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var homeModel: HomeModel?                //首页数据model,包含新手标、Banner等
    var noticeModel: UrgentnoticeHomeModel?  //系统公告显示数据model
    var cycleView: SDCycleScrollView?        //轮播图
    var isShowUrgentNotice: Bool? = true     //是否显示紧急公告
    
    var isActivity: Bool? = true             //是活动标还是新手标

    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "嗷呜宝"
        listView.tableFooterView = UIView()
        self.edgesForExtendedLayout = UIRectEdge()  //加上这个 listView顶部就不会有20个像素高度的问题了
        
        self.isShowLeftItem = false //不显示左边按钮
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: LoginSucessPostNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "LoginOutInvest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "REGISTER_SUCCESS_NOTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: RefreshControllerPostNotification), object: nil)
        
        //加载数据
        self.loadData()
        
        listView.mj_header = MJRefreshNormalHeader {
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        self.loadData()
    }
    
    //MARK: - 下载数据
    override func loadData() {
        
        var uid = 0
        if UserModel.shareInstance.isLogin == 1 {
            uid = UserModel.shareInstance.uid!
        }
        
        weak var weakSelf = self
        
        HomeApi(Uid: uid).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("首页-请求参数\(resultDict!)==\(uid)")
            weakSelf!.homeModel = HomeModel(dict: resultDict!)
            
            if (weakSelf!.homeModel?.success)! {
                //isShowUrgentNotice： 是否显示紧急公告
                if weakSelf!.isShowUrgentNotice! {
                    //读取系统公告
                    weakSelf!.loadUrgentNoticeData()
                    
                } else {
                    weakSelf!.refreshViews()
                }
                
            } else if weakSelf!.homeModel?.errorCode == "9998" {
                //首页的错误码： 9999
                weakSelf!.listView.mj_header.endRefreshing()
                weakSelf!.view.hideHud()
                //弹出登录控制器
                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                
            } else {
                weakSelf!.view.showTextHud("网络错误,请稍后重试")
                weakSelf!.refreshViews()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.refreshViews()
            weakSelf!.view.showTextHud("网络错误,请稍后重试")
        }
    }
    
    /**
     *   读取系统公告
     */
    func loadUrgentNoticeData() {
        weak var weakSelf = self
        UrgentNoticeAPI(Limit: "3", ProId: "1").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("首页 - 读取系统公告\(resultDict!)")
            weakSelf!.noticeModel = UrgentnoticeHomeModel(dict: resultDict!)
            weakSelf!.refreshViews()
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.refreshViews()
            weakSelf!.view.showTextHud("网络错误")
        }
    }

    //MARK: 刷新视图
    func refreshViews() {
        
        self.view.hideHud()
        if self.listView.isHidden {
            self.listView.isHidden = false
        }
        
        self.listView.mj_header.endRefreshing()
        
        //MARK: banner视图刷新
        self.loadBanner(self.homeModel?.map?.banner)
        self.listView.reloadData()
    }
    
    //MARK: - Banner视图刷新 banner数组
    func loadBanner(_ banner: [HomeBannerModel]?) {
        
        if cycleView == nil {
            cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 160 * SCREEN_WIDTH / 320), delegate: self, placeholderImage:UIImage(named: "problem"))
            cycleView!.autoScrollTimeInterval = 4.0
            cycleView!.delegate = self
            listView.tableHeaderView = cycleView!
        }
        
        if banner == nil || banner?.count == 0 {
            
            listView.tableHeaderView = nil
            
        } else {
            
            var imagesURLString = [String]()
            
            for a in banner! {
                imagesURLString.append(a.imgUrl)
            }
            
            cycleView!.imageURLStringsGroup = imagesURLString
            listView.tableHeaderView = cycleView!
        }
    }

    /**
     关闭下拉刷新
     */
    func dropDownLoading() {
        
    }
    
    //MARK: - TableView数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { //新手标
            return JSHomeNewHandCell.numberOfRowForNewHandCell(self.homeModel?.map)
            
        } else if section == 3 { //活动cell
//            return JSInvestActivityTableViewCell.numberOfRowForActivityCell(self.homeModel?.map?.activity)
            return 0
        } else if section == 4 {
            
//            return JSInvestActivityTableViewCell.numberOfRowForInvestGiveCell(self.homeModel?.map?.investSendPrize)
            return 0
        } else if section == 6 {
            return 0
        }
        return 1
    }
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return 8   //0:公告 1:安全保障 2:新手标 3:财胜标 4:投即送 5:优选理财 6:平台运营数据 7:两名律师
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 30
            
        } else if indexPath.section == 1 {
            return 84
            
        } else if indexPath.section == 2 {
            return JSHomeNewHandCell.cellHeight()
            
        }else if indexPath.section == 3 || indexPath.section == 4 {
            return JSInvestActivityTableViewCell.cellHeight()
            
        } else if indexPath.section == 5 {
            return JSHomeInvestCell.cellHeight()
            
        }else if indexPath.section == 6 {
            return JSOperationalDataCell.cellHeight()
        }
        else if indexPath.section == 7 {
            return JSHomeMessageCell.cellHeight()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            if self.homeModel?.map?.fuiouNewHandInvested == 0 && self.homeModel?.map?.fuiouNewHand != nil  {
                return 10
            } else {
                return 0
            }
        } else if section == 5 {
            return 10
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //上下滚动
            if self.noticeModel?.map?.urgentNotice != nil {
                self.articleMessageCell!.articleList = (self.noticeModel?.map?.urgentNotice)!
            }
            
            self.articleMessageCell?.jumpBlock = {(article: UrgentNoticeModel) in
            
                let vc = LocationController()
                vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + GGXQ + "?artiId=" + "\(article.arti_id)" as AnyObject,"title":"详情" as AnyObject])
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return self.articleMessageCell!
            
        } else if indexPath.section == 1 {
            
            if self.homeModel?.map != nil {
                self.homeSecondCell!.setupModel(self.homeModel?.map)
            }
            
            //安全保障
            self.homeSecondCell!.homeSafetyClick = {
                
                if self.homeModel?.map?.bannerDownUrl1 != "" {
                    
                    let vc = LocationController()
                    vc.model = HomeBannerModel.init(dict: ["location":(self.homeModel?.map?.bannerDownUrl1)! as AnyObject,"title":"安全保障" as AnyObject])
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    
                    let vc = CompanyAndYanZiViewController()
                    vc.pageID = 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            //热门活动
            self.homeSecondCell!.homeHotActivityClick = {
                if self.homeModel?.map?.bannerDownUrl2 != "" {
                    let controller = LocationController()
                    controller.model = HomeBannerModel.init(dict: ["location":(self.homeModel?.map?.bannerDownUrl2)! as AnyObject,"title":"热门活动" as AnyObject])
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else {
                    let controller = JSActivityCentreViewController()
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            return self.homeSecondCell!
            
        } else if indexPath.section == 2 {
            if self.homeModel?.map != nil && self.homeModel?.map?.fuiouNewHand != nil {
                self.newHandCell!.configModel(self.homeModel?.map?.fuiouNewHand, newHandString: (self.homeModel?.map?.fuiouNewHandLabel)!)
            }
            
            return self.newHandCell!
            
        }else if indexPath.section == 3 { //活动cell
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestActivityTableViewCell") as? JSInvestActivityTableViewCell
            
            if cell == nil  {
                
                cell = Bundle.main.loadNibNamed("JSInvestActivityTableViewCell", owner: nil, options: nil)?.last as? JSInvestActivityTableViewCell
            }
            
            cell?.configureCellWithActivityModel(self.homeModel?.map?.activity)
            return cell!
            
        } else if indexPath.section == 4 { //投即送cell
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestActivityTableViewCell") as? JSInvestActivityTableViewCell
            
            if cell == nil  {
                
                cell = Bundle.main.loadNibNamed("JSInvestActivityTableViewCell", owner: self, options: nil)?.last as? JSInvestActivityTableViewCell
            }
            
            cell?.configureCellWithInvestGiveModel(self.homeModel?.map?.investSendPrize)
            return cell!
            
        } else if indexPath.section == 5 {
            
            if self.homeModel?.map?.preferredInvest != nil {
                self.investMentCell!.configModel(self.homeModel?.map?.preferredInvest)
            }
            //优选理财
            return self.investMentCell!
            
        } else if indexPath.section == 6 {
            //平台运营后台数据
            if self.homeModel != nil && self.homeModel?.map != nil && self.homeModel?.map?.operateData != nil {
                self.homeOperationalDataCell?.setupModel(model: (self.homeModel?.map?.operateData)!)
            }
            
            return self.homeOperationalDataCell!
            
        }else {
            return self.messageCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
//        let model = JSBaseViewModel()
//        model.requestAlamofire(params: ["aaa":"aaa"], subApi: Home_Api, modelName: "", callback: { (JSBaseModel) in
//        
//            
//        }) { (String) in
//            
//            
//        }
        
        
//        return
        
        print("输出当前的判断\(String(describing: self.isActivity))")
        if indexPath.section == 2 {  //新手标
            if self.homeModel?.map?.fuiouNewHandInvested != 1 && self.homeModel?.map?.fuiouNewHand != nil {
                
                let productDetailVC = JSInvestDetailViewController()
                productDetailVC.productNameID = self.homeModel?.map?.fuiouNewHand?.id
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
            
        }else if indexPath.section == 3 { //iphone活动标
            
            if self.homeModel?.map?.activity != nil {
//                let controller = LocationController()
//                controller.model = HomeBannerModel(dict: ["location":"\((self.homeModel?.map?.activity?.iphoneDeatilUrl)!)" as AnyObject,"title":"iPhone7活动专题" as AnyObject])
//                controller.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(controller, animated: true)
                MobClick.event("0400029")
                let controller = JSInvestDetailViewController()
                controller.productNameID = self.homeModel?.map?.activity?.id
                self.navigationController?.pushViewController(controller, animated: true)
            }

        } else if indexPath.section == 4 { //投即送标
            
            if self.homeModel != nil {
                
                if self.homeModel?.map != nil {
                    
                    if self.homeModel?.map?.investSendPrize != nil {
                        let controller = LocationController()
                        controller.model = HomeBannerModel(dict: ["location":"\((self.homeModel?.map?.investSendPrize?.indexUrl)!)" as AnyObject,"title":"好礼钜献专享标" as AnyObject])
                        controller.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
            
        }
//        else if indexPath.section == 5 {  //聚划算
//            let controller = JSInvestFinancingActivityController()
//            controller.type = 2
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
        
        else if indexPath.section == 5 { //优选理财
            MobClick.event("0400001")
            let controller = JSInvestFinancingActivityController()
            controller.type = 2
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    //MARK: - 轮播器点击事件的代理方法
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        //*(self.dataModel?.map?.banner[index].location)!.hasPrefix("http")*/
        if self.homeModel?.map?.banner[index].location != nil && (self.homeModel?.map?.banner[index].location)!.lengthOfBytes(using: String.Encoding.utf8) > 0
            
        {
            let web = LocationController()
            web.model = homeModel?.map?.banner[index]
            if self.homeModel?.map?.newHand?.id != nil
            {
                //productID: 产品ID，用户有时候页面跳转传递ID
                web.productID = (self.homeModel?.map?.newHand?.id)!
            }
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(web, animated: true)
        }
        
    }
    
    //MARK: - 懒加载
    //上下滚动公告
    lazy var articleMessageCell: ArticleMessageCell? = {
        let cell: ArticleMessageCell = ArticleMessageCell(style: UITableViewCellStyle.default, reuseIdentifier: "ArticleMessageCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //安全保障 热门活动
    lazy var homeSecondCell: HomeSecondCell? = {
        let cell:HomeSecondCell = Bundle.main.loadNibNamed("HomeSecondCell", owner: self, options: nil)?.first as! HomeSecondCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //新手标懒加载
    lazy var newHandCell: JSHomeNewHandCell? = {
        let cell: JSHomeNewHandCell = JSHomeNewHandCell(style: UITableViewCellStyle.default, reuseIdentifier: "JSHomeNewHandCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //iphone7活动标
    lazy var iPhoneActivityCell: JSHomeIphoneActivityCell? = {
        let cell: JSHomeIphoneActivityCell = JSHomeIphoneActivityCell(style: UITableViewCellStyle.default, reuseIdentifier: "JSHomeIphoneActivityCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //优选理财
    lazy var investMentCell: JSHomeInvestCell? = {
        let cell: JSHomeInvestCell = JSHomeInvestCell(style: UITableViewCellStyle.default, reuseIdentifier: "JSHomeInvestCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //
    lazy var messageCell: JSHomeMessageCell? = {
        let cell: JSHomeMessageCell = JSHomeMessageCell(style: UITableViewCellStyle.default, reuseIdentifier: "JSHomeMessageCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()
    
    //活动专题入口
    lazy var homeActivityEntranceCell: HomeActivityEntranceCell? = {
        let cell:HomeActivityEntranceCell = Bundle.main.loadNibNamed("HomeActivityEntranceCell", owner: self, options: nil)?.first as! HomeActivityEntranceCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }()

    //平台运营数据
    lazy var homeOperationalDataCell: JSOperationalDataCell? = {
        let cell:JSOperationalDataCell = Bundle.main.loadNibNamed("JSOperationalDataCell", owner: self, options: nil)?.first as! JSOperationalDataCell
        return cell
     }()
    
    
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("MainViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
