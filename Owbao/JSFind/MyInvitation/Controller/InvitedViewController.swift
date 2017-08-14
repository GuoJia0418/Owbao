//
//  InvitedViewController.swift
//  Owbao
//
//  Created by GuoJia on 16/11/23.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedViewController: BaseViewController {

    @IBOutlet weak var invitedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var bottomWindow: UIWindow?              //显示弹窗的window
    
    //页码(分页功能)
    var pageNumber: Int = 1
    var model: InvitedBaseModel?
    var rowArray: NSMutableArray?
    
    //马上领取
    var getMoneyNowModel: MyAccountGetMoneyModel?            //立马获取金额
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "邀请好友"
        self.invitedButton.layer.cornerRadius = 3
        self.invitedButton.layer.masksToBounds = true
        
        rowArray = NSMutableArray()
        self.tableView.tableFooterView = UIView()
        
        //下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader {
            self.loadDataFromServer(1)
        }
        
        //上啦刷新
        let footer = MJRefreshAutoStateFooter {
            self.loadDataFromServer(self.pageNumber + 1)
        }
        footer?.setTitle("", for: MJRefreshState.noMoreData)
        self.tableView.mj_footer = footer
        
        self.loadDataFromServer(1)
        
        //登录成功后重新
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name:NSNotification.Name(rawValue: LoginSucessPostNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadData() {
        self.loadDataFromServer(1)
    }

    /**
     关闭广告弹窗
     */
    func cancelClickAction() {
        self.bottomWindow?.isHidden = true
        self.bottomWindow = nil
    }
    
    //上拉从服务器下载数据
    func loadDataFromServer(_ pageNumber: Int) -> () {
        
        self.view.showLoadingHud()
        
        InvitedApi(Uid: UserModel.shareInstance.uid ?? 0, PageOn: pageNumber).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("结果\(resultDict)")
            self.model = InvitedBaseModel(dictionary: resultDict!)
            self.model?.invitedModel?.unclaimed = 10.0
            
            self.view.hideHud()
            
//            if self.handleDownloadedData(self.model!,isShowLoginCtrl: true) {
//                if pageNumber == 1 {//下拉刷新
//                    self.pageNumber = 1
//                    self.rowArray = NSMutableArray()
//                    self.rowArray?.addObjects(from: (self.model?.invitedModel?.rows)! as [AnyObject])
//                    self.tableView.mj_header.endRefreshing()
//                    self.tableView.mj_footer.endRefreshing()
//                    self.tableView.reloadData()
//                    
//                    if self.rowArray?.count == 0 { //没数据
//                    
//                        self.tableView.tableFooterView = self.getNoDataView()
//                        self.tableView.mj_footer.endRefreshingWithNoMoreData() //没有数据
//                        
//                    } else { //有数据
//                        self.tableView.tableFooterView = UIView()
//                    }
//                    
//                } else {//上拉刷新
//                    self.pageNumber += 1
//                    self.rowArray?.addObjects(from: (self.model?.invitedModel?.rows)! as [AnyObject])
//                    if self.model?.invitedModel?.rows.count == 0 {//无数据了
//                        self.tableView.mj_header.endRefreshing()
//                        self.tableView.mj_footer.endRefreshing()
//                        self.tableView.reloadData()
//                    } else {//有数据
//                        self.tableView.mj_header.endRefreshing()
//                        self.tableView.mj_footer.endRefreshing()
//                        self.tableView.reloadData()
//                    }
//                    
//                    if self.rowArray?.count == 0 { //没数据
//                        self.tableView.tableFooterView = self.getNoDataView()
//                        self.tableView.mj_footer.endRefreshingWithNoMoreData() //没有数据
//                    } else { //有数据
//                        self.tableView.tableFooterView = UIView()
//                    }
//                }
//            }
            
            if self.model?.success == true {
                
                if pageNumber == 1 {//下拉刷新
                    self.pageNumber = 1
                    self.rowArray = NSMutableArray()
                    self.rowArray?.addObjects(from: (self.model?.invitedModel?.rows)! as [AnyObject])
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.reloadData()

                    if self.rowArray?.count == 0 { //没数据

                        self.tableView.tableFooterView = self.getNoDataView()
                        self.tableView.mj_footer.endRefreshingWithNoMoreData() //没有数据

                    } else { //有数据
                        self.tableView.tableFooterView = UIView()
                    }

                } else {//上拉刷新
                    self.pageNumber += 1
                    self.rowArray?.addObjects(from: (self.model?.invitedModel?.rows)! as [AnyObject])
                    if self.model?.invitedModel?.rows.count == 0 {//无数据了
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.endRefreshing()
                        self.tableView.reloadData()
                    } else {//有数据
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.endRefreshing()
                        self.tableView.reloadData()
                    }
                    
                    if self.rowArray?.count == 0 { //没数据
                        self.tableView.tableFooterView = self.getNoDataView()
                        self.tableView.mj_footer.endRefreshingWithNoMoreData() //没有数据
                    } else { //有数据
                        self.tableView.tableFooterView = UIView()
                    }
                }
                
            } else {
                
                if self.model?.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if self.model?.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    if self.model?.errorMsg != "" {
                        self.view.showTextHud((self.model?.errorMsg)!)
                    } else {
                        self.view.showTextHud("发生了未知错误")
                    }
                }
            }

            }) { (request: YTKBaseRequest!) -> Void in
                self.view.showTextHud("网络错误,请稍后重试")
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.view.hideHud()
        }
    }
    
     //创建没数据的视图
    func getNoDataView() -> UIView {
        let view = JSNoDataView.getNoDataView(CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: JSNoDataView.getSuitHeight(169.0/176.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH) ))
        //父视图
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: JSNoDataView.getSuitHeight(169.0/176.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH) + 20 ))
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: JSNoDataView.getSuitHeight(169.0/176.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH))
        superView.addSubview(view)
        return superView
    }
    
    //底部按钮点击事件
    @IBAction func bottomButtonClickAction(_ sender: AnyObject) {
        self.shareClick(UIImage(named: "wechat")!, wxTimeLineImage: UIImage(named: "wechat")!, qqShareImage: "https://www.jushengcaifu.com/images/newbie.png", shareUrl: BASE_URL + "/zhuce?recommCode=\(UserModel.shareInstance.mobilephone as String!)", shareTitle: SHARE_TITLE2, isHidden: false)
    }

    //tableView
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rowArray!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "InvitedTableViewCell") as! InvitedTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvitedTableViewCell", owner: self, options: nil)!.last as? InvitedTableViewCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            if self.model?.invitedModel != nil {
                cell?.configureCell((self.model?.invitedModel)!, unclaimed: (self.model?.invitedModel?.unclaimed)!)
            }
            
            cell?.imageTapAction = {(URLString: String) ->() in
                let web = LocationController()
                web.model = HomeBannerModel.init(dict: ["location":URLString as AnyObject,"title":"邀请详情" as AnyObject])
                web.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(web, animated: true)
            }
            
            //马上领取
            cell?.getMoneyNow = {
                // 马上领取
                self.getMoneyNowData()
            }
            return cell!
            
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "InvitedShowContactTableViewCell") as! InvitedShowContactTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvitedShowContactTableViewCell", owner: self, options: nil)!.last as? InvitedShowContactTableViewCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            if indexPath.row <= (self.rowArray?.count)! - 1 {
                let model = self.rowArray!.object(at: indexPath.row) as? InvitedRowsModel
                if model != nil {
                    cell?.configureCell(model!)
                }
            }
            return cell!
        } else {
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else if section == 1{
            return 48
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InvitedHeadView") as UIView!
            if view == nil {
                view = Bundle.main.loadNibNamed("InvitedHeadView", owner: self, options: nil)?.last as! InvitedHeadView
            }
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if (self.model?.invitedModel != nil)
            {
                return InvitedTableViewCell.cellHightWithModel((self.model?.invitedModel)!,unclaimed: (self.model?.invitedModel?.unclaimed)!)
                
            } else {
                return 0.0
            }
        } else if indexPath.section == 1 {
            return 55.0
        }
        return 0.0
    }

    //MARK: -  马上领取获取数据
    func getMoneyNowData() {
        
        var afid:Int = 0
        if model != nil && self.model?.invitedModel != nil {
            afid = (self.model?.invitedModel?.afid)!
        }
        
        view.showLoadingHud()
        weak var weakSelf = self
        MyAccountGetMoneyNowApi(Uid: UserModel.shareInstance.uid ?? 0, Afid: afid).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            weakSelf!.tableView.mj_header.endRefreshing()
            weakSelf?.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            weakSelf!.getMoneyNowModel = MyAccountGetMoneyModel(dict: resultDict!)
            
            weakSelf!.tableView.reloadData()
            
            if weakSelf?.getMoneyNowModel?.success == true
            {
                weakSelf!.view.hideHud()
                //展示红包的弹窗
                self.showGetMoneyNowWindow(weakSelf?.getMoneyNowModel)
                
            }
            else if weakSelf?.getMoneyNowModel?.errorCode == "9998"
            {
                weakSelf?.view.hideHud()
                //弹出登录控制器
                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                
            }
            else
            {
                weakSelf?.view.hideHud()
                weakSelf!.view.showTextHud("系统错误!")
                
            }
            
            weakSelf?.tableView.reloadData()
            
        }) { (request: YTKBaseRequest!) in
            
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
        }
    }

    var getMoneyNum: UILabel!               //奖金额
    //MARK: 马上领取弹窗
    func showGetMoneyNowWindow(_ model: MyAccountGetMoneyModel?)
    {
        let x = (SCREEN_WIDTH - 273 * SCREEN_WIDTH / 320) / 2
        let y = (SCREEN_HEIGHT - 425 * SCREEN_WIDTH / 320) / 2
        let width = 273 * SCREEN_WIDTH / 320
        let height = 425 * SCREEN_WIDTH / 320
        
        let firstOpenImageView = UIImageView(frame:CGRect(x: x, y: y, width: width, height: height))
        firstOpenImageView.image = UIImage(named: "makeMoney_show")
        
        
        //领取了奖金
        let getMoneyTitleLabel = UILabel(frame: CGRect(x: 5, y: 145 * SCREEN_WIDTH / 320, width: width - 5, height: 30 * SCREEN_WIDTH / 320))
        getMoneyTitleLabel.text = "领取了奖金"
        getMoneyTitleLabel.textColor = UIColor.white
        getMoneyTitleLabel.textAlignment = NSTextAlignment.center
        getMoneyTitleLabel.font = UIFont.boldSystemFont(ofSize: 29 * SCREEN_WIDTH / 320)
        firstOpenImageView.addSubview(getMoneyTitleLabel)
        
        
        //奖金额
        getMoneyNum = UILabel(frame: CGRect(x: 5, y: getMoneyTitleLabel.frame.size.height + getMoneyTitleLabel.frame.origin.y + 5, width: width - 5, height: 30 * SCREEN_WIDTH / 320))
        getMoneyNum.textColor = UIColor.white
        getMoneyNum.textAlignment = NSTextAlignment.center
        getMoneyNum.font = UIFont.boldSystemFont(ofSize: 29 * SCREEN_WIDTH / 320)
        firstOpenImageView.addSubview(getMoneyNum)
        
        //提示消息
        let showMessageLabel = UILabel(frame: CGRect(x: 5 , y: getMoneyNum.frame.size.height + getMoneyNum.frame.origin.y + 10, width: width - 5, height: 12 * SCREEN_WIDTH / 320))
        showMessageLabel.text = "奖金已转入您的账户请及时查收"
        showMessageLabel.textColor = UIColor.white
        showMessageLabel.textAlignment = NSTextAlignment.center
        showMessageLabel.font = UIFont.systemFont(ofSize: 12 * SCREEN_WIDTH / 320)
        firstOpenImageView.addSubview(showMessageLabel)
        
        
        // 分享
        let btnX = (width - 165 * SCREEN_WIDTH / 320 - 8) / 2
        let btnWidth = 165 * SCREEN_WIDTH / 320
        let btnHeight = 45 * SCREEN_WIDTH / 320
        
        let shareBtn = UIButton(type: UIButtonType.custom)
        shareBtn.frame = CGRect(x: btnX, y: showMessageLabel.frame.origin.y + showMessageLabel.frame.size.height + 27, width: btnWidth, height: btnHeight)
        shareBtn.setTitle("分享赚更多", for: UIControlState())
        shareBtn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
        shareBtn.backgroundColor = UIColor(colorLiteralRed: 250 / 255, green: 217 / 255, blue: 49 / 255, alpha: 1)
        shareBtn.layer.cornerRadius = 5
        shareBtn.layer.masksToBounds = true
        //        shareBtn.tag = indexPathRow
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25 * SCREEN_WIDTH / 320)
        shareBtn.addTarget(self, action: #selector(InvitedViewController.makeMoneyClick(_:)), for: .touchUpInside)
        firstOpenImageView.addSubview(shareBtn)
        
        
        //放弃机会
        let abandonBtn = UIButton(type: UIButtonType.custom)
        abandonBtn.frame = CGRect(x: btnX, y: shareBtn.frame.origin.y + shareBtn.frame.size.height + 23, width: btnWidth, height: btnHeight)
        abandonBtn.setTitle("放弃机会", for: UIControlState())
        abandonBtn.setTitleColor(UIColor.white, for: UIControlState())
        abandonBtn.backgroundColor = UIColor.clear
        abandonBtn.layer.cornerRadius = 5
        abandonBtn.layer.masksToBounds = true
        abandonBtn.layer.borderColor = UIColor.white.cgColor
        abandonBtn.layer.borderWidth = 1
        abandonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25 * SCREEN_WIDTH / 320)
        abandonBtn.addTarget(self, action: #selector(InvitedViewController.abandonClick(_:)), for: UIControlEvents.touchUpInside)
        firstOpenImageView.addSubview(abandonBtn)
        
        let cover = UIButton(frame: UIScreen.main.bounds)
        cover.backgroundColor = UIColor.black
        cover.alpha = 0.5

        firstOpenImageView.isUserInteractionEnabled = true
        let wd = UIWindow(frame: UIScreen.main.bounds)
        wd.windowLevel = UIWindowLevelAlert
        wd.addSubview(cover)
        wd.addSubview(firstOpenImageView)
        wd.makeKeyAndVisible()
        
        //赋值
        if model != nil
        {
            if model?.map != nil
            {
                getMoneyNum.text = "\(model!.map!.amount)" + "元"
            }
        }
        
        bottomWindow = wd
        
    }
    //MARK: - 分享赚更多按钮
    func makeMoneyClick(_ sender:UIButton)
    {
        let urlStr = URL(string: "https://www.jushengcaifu.com/images/applogo.png")
        let data = try? Data(contentsOf: urlStr!)
        var image = UIImage(data: data!)
        if image == nil
        {
            image = UIImage(named: "js_invite_share")
        }

        self.shareClick(image!, wxTimeLineImage: image!, qqShareImage: "", shareUrl: BASE_URL + "/friendreg?recommCode=\(UserModel.shareInstance.mobilephone as String!)", shareTitle: SHARE_TITLE1, isHidden: true)
    }
    
    //MARK: - 分享
    func shareClick(_ wxFriendImage:UIImage,wxTimeLineImage:UIImage,qqShareImage:String,shareUrl:String,shareTitle:String,isHidden:Bool)
    {
        //分享给微信朋友模型
        let wxShareToFriendsModel = ShareInfoModel(shareImageURLString: "", shareImage: UIImage(named: "wechat")!, shareURLString: BASE_URL + "/zhuce?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE2,shareDescription: "")
        
        //分享到微信朋友圈模型
        let wxTimeLineModel = ShareInfoModel(shareImageURLString: "", shareImage: UIImage(named: "wechat")!, shareURLString: BASE_URL + "/zhuce?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE2,shareDescription: "")
        
        //分享到QQ用到的模型
        let qqModel = ShareInfoModel(shareImageURLString: "https://www.jushengcaifu.com/images/newbie.png", shareImage: UIImage(), shareURLString: BASE_URL + "/zhuce?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE2,shareDescription: "")
        
        //开始分享
        let view = InvitedBottowPushView.animateWindowsAddSubView(wxShareToFriendsModel, WXTimelineModel: wxTimeLineModel, QQModel: qqModel)

        
        if isHidden
        {
            view.hiddenQQShareButtonShareToFriends()
        }
        
        //分享回调
        view.shareCallback = { (isSuccess: Bool) in
            self.cancelClickAction()
            if isHidden == true
            {
                //领取money
                self.loadDataFromServer(1)
            }
            
        }

    }
    //MARK: - 放弃机会
    func abandonClick(_ sender:UIButton)
    {
        self.cancelClickAction()
        self.loadDataFromServer(1)
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("InvitedViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
}
