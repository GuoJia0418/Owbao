
//
//  JSMyAccountViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyAccountViewController: BaseTableViewController,UITableViewDelegate,UITableViewDataSource {
    
    var iconArr: [String] = []
    var titleArr: [String] = []
    var bottomWindow:UIWindow?                                //显示弹窗的window
    var accountModel: MyAccountModel?                         //获取的数据mod
    var eyeIsSelected: Bool? = true                            //眼睛是否被选中
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.separatorStyle = .none
        setupArray()
        self.barType = .red
        
        //监听存管操作成功发送的通知
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserModel.shareInstance.isLogin == 1 {
            
            if UserModel.shareInstance.mobilephone != "" {
                navigationItem.title = self.stringByX(UserModel.shareInstance.mobilephone!, startindex: 3, endindex: 7)
            }
            self.loadData()
            
        } else {
            navigationItem.title = "我的"
            showWindow()
            listView.reloadData()
            listView.isHidden = true
        }
        
//        if UserDefaults.standard.value(forKey: "InMyAccountShowFuiouWindow") != nil && UserDefaults.standard.value(forKey: "InMyAccountShowFuiouWindow") as? String == "1"
//        {
//            //展示弹窗
//            self.showOpenFuiouWindow()
//        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "消息"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonClick))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "js_mine_setting"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(JSMyAccountViewController.myAccountSetting))
    }

    func rightBarButtonClick() -> () {
        let controller = JSMessageCentreController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - 展示开户弹窗
    func showOpenFuiouWindow()
    {
        if self.accountModel?.map?.isFuiou == 0 { //没有开通
            self.gotoOpenCustodyAccount()
            
        } else { //开通
            print("已经开通过存管")
        }

    }
    //MARK: - 设置按钮
    func myAccountSetting() {
        
        let settingVC = JSMyAccountSettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    //手机号
    func stringByX(_ str: String,startindex: Int,endindex: Int) -> String {
        //开始字符索引
        let startIndex = str.characters.index(str.startIndex, offsetBy: startindex)
        //结束字符索引
        let endIndex = str.characters.index(str.startIndex, offsetBy: endindex)
        let range = Range<String.Index>(startIndex..<endIndex)
        var s = String()
        for _ in 0..<endindex - startindex{
            s += "*"
        }
        return str.replacingCharacters(in: range, with: s)
    }
    
    //MARK: - 数据
    override func loadData() {
        self.loadDataFromsServers()
    }
    
    //MARK: - 请求数据
    func loadDataFromsServers() -> () {
        
        MyAccountApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            self.view.hideHud()
            if self.listView.isHidden {
                self.listView.isHidden = false
            }
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("我的账户 - 首页数据\(resultDict)")
            self.accountModel = MyAccountModel(dict: resultDict!)
            self.listView.reloadData()
            
            self.listView.mj_header.endRefreshing()
            
            if self.accountModel?.success == false {
                self.view.hideHud()
                if self.accountModel?.errorCode == "9998" {
                    self.view.showTextHud("登录失效,请重新登录")
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    self.view.showTextHud("系统错误")
                }
                
            } else if self.accountModel?.errorCode == "9998" {
                self.view.showTextHud("登录失效,请重新登录")
                //弹出登录控制器
                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
            } else {
                
                if UserModel.shareInstance.isShowOpenWindow == 1
                {
                    if self.accountModel?.map?.isFuiou == 0 { //没有开通
                        self.gotoOpenCustodyAccount()
                        
                    } else { //开通
                        print("已经开通过存管")
                    }
                    
                }
                
                self.listView.reloadData()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            self.view.hideHud()
            self.view.showTextHud("网络错误")
            self.listView.mj_header.endRefreshing()
        }
    }
    
    //MARK: - 显示弹窗,马上领取弹窗
    func showWindow() {
        
        let x = (SCREEN_WIDTH - 248.5 * SCREEN_SCALE_W) / 2
        let y = 75 * SCREEN_SCALE_W
        let width = 248.5 * SCREEN_WIDTH / 320
        let height = 301.5 * SCREEN_WIDTH / 320
        
        let firstOpenImageView = UIImageView(frame:CGRect(x: x, y: y, width: width, height: height))
        firstOpenImageView.image = UIImage(named: "js_mine_alert_window")

        // 注册
        let btnHeight = 48 * SCREEN_WIDTH / 320
        
        let regBtn = UIButton(type: UIButtonType.custom)
        regBtn.frame = CGRect(x: x, y: firstOpenImageView.y + firstOpenImageView.height + 20, width: width, height: btnHeight)
        regBtn.setTitle("新用户注册拿红包", for: UIControlState())
        regBtn.setTitleColor(UIColor.white, for: UIControlState())
        regBtn.backgroundColor = Global_yellow_deep
        regBtn.layer.cornerRadius = 5
        regBtn.layer.masksToBounds = true
        regBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        regBtn.addTarget(self, action: #selector(JSMyAccountViewController.regClick(_:)), for: UIControlEvents.touchUpInside)
        
        //登录
        let loginBtn = UIButton(type: UIButtonType.custom)
        loginBtn.frame = CGRect(x: x, y: regBtn.y + regBtn.height + 15, width: width, height: btnHeight)
        loginBtn.setTitle("我要登录", for: UIControlState())
        loginBtn.setTitleColor(UIColor.white, for: UIControlState())
        loginBtn.backgroundColor = UIColor.clear
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.layer.borderWidth = 1
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginBtn.addTarget(self, action: #selector(JSMyAccountViewController.loginClick(_:)), for: UIControlEvents.touchUpInside)
        
        //取消按钮
        let cancelbtn = UIButton(type: UIButtonType.custom)
        cancelbtn.addTarget(self, action: #selector(JSMyAccountViewController.cancelClick(_:)), for: UIControlEvents.touchUpInside)
        cancelbtn.frame = CGRect(x: x + width - 10, y: y - 32 * SCREEN_SCALE_W, width: 32, height: 32)
        cancelbtn.backgroundColor = UIColor.clear
        cancelbtn.setImage(UIImage(named: "js_mine_cancle_btn"), for: UIControlState())
        
        let cover = UIButton(frame: UIScreen.main.bounds)
        cover.backgroundColor = UIColor.black
        cover.alpha = 0.5

        firstOpenImageView.isUserInteractionEnabled = true
        let wd = UIWindow(frame: UIScreen.main.bounds)
        wd.windowLevel = UIWindowLevelAlert
        wd.addSubview(cover)
        wd.addSubview(cancelbtn)
        wd.addSubview(firstOpenImageView)
        wd.addSubview(regBtn)
        wd.addSubview(loginBtn)
        wd.makeKeyAndVisible()
    
        bottomWindow = wd
    }
    
    //MARK: - 注册
    func regClick(_ sender: UIButton) {
        self.cancelClickAction()
        MobClick.event("0100001")
        self.present(JSRegisterPhoneViewController.getPresentController(), animated: true, completion: nil)
    }
    
    //MARK: - 登录
    func loginClick(_ sender: UIButton) {
        
        self.cancelClickAction()
        //弹出登录控制器
        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
    }

    //MARK: - 取消按钮
    func cancelClick(_ sender:UIButton) {
       self.cancelClickAction()
       loadData()
    }
    
    //MARK: -
    func cancelClickAction() {
        self.bottomWindow?.isHidden = true
        self.bottomWindow = nil
    }

    //MARK: - UITableViewDelegate,UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if self.accountModel != nil {
                
                if self.accountModel?.map != nil {
                    self.myAccountCell?.configureCellWithAccountModel((self.accountModel?.map)!,isSelected: self.eyeIsSelected!)
                }
            }
            
            //点击回调
            self.myAccountCell?.callbackAction = {
                (type: accountCellCallbackType) in
                
                if type == accountCellCallbackType.sumIncome {
                    let controller = JSAccountAssetsViewController()
                    controller.segmentIndex = 1
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                 else if type == accountCellCallbackType.available {
                    let controller = JSAccountAssetsViewController()
                    controller.segmentIndex = 0
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
            //点击眼睛
            self.myAccountCell?.eyeClick = {(isSelected:Bool) in
                self.eyeIsSelected = isSelected
                self.listView.reloadData()
//                self.listView.reloadRows(at: [indexPath], with: .none)
            }
            
            return self.myAccountCell!
            
        } else if indexPath.row == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSRechargeAndWithdrawsCell") as! JSRechargeAndWithdrawsCell!
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSRechargeAndWithdrawsCell", owner: self, options: nil)?.first as? JSRechargeAndWithdrawsCell
            }
            
            if self.accountModel != nil {
                cell?.setupModel(self.accountModel)
            }
            
            //提现
            cell?.withdrawBlock = {
                MobClick.event("0500001")
                self.withdrawChooseSelect()
            }
            
            //充值
            cell?.rechargeBlock = {
                self.rechargeSelectWithFuiou()
            }
            
            //新手标
            cell?.newHandBlock = {
                
                //完善资料
                if self.accountModel?.map?.isPerfect != 1 {
                    let controller = JSInvestGiveSuccessController()
                    controller.productNameID = self.accountModel?.map?.pid
                    controller.investId = (self.accountModel?.map?.investId)!
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
            return cell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyAccountDetailCell") as! JSMyAccountDetailCell!
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSMyAccountDetailCell", owner: self, options: nil)?.first as? JSMyAccountDetailCell
            }
            
            cell?.setupView(iconArr[indexPath.row - 2], title: titleArr[indexPath.row - 2])
            
            //数据
            if accountModel != nil && accountModel?.map != nil {
                
                cell?.setupModel(accountModel!,row:indexPath.row)
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return JSMyAccountCell.cellHeight()
            
        } else if indexPath.row == 1 {
            
            if self.accountModel?.map?.isPerfect == 1 {
                return 86
            } else {
                return 117
            }
            
        } else {
            return 49 * SCREEN_SCALE_W
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 2: //我的投资
            let myInvestVC = JSMyInvestViewController()
            self.navigationController?.pushViewController(myInvestVC, animated: true)
            break
        case 3: //优惠券
            //去我的红包
//            let moreScreenVC = MoreScreenSlidingRootController()
//            moreScreenVC.vcType = 6
//            self.navigationController?.pushViewController(moreScreenVC, animated: true)
            let controller = JSCouponBaseViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
            break
        case 4: //体验金
            let controller = JSExperienceListController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 5: //我的邀请
            let controller = JSInvitedViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case 6: //安全中心
            let myInformation = JSMyInformationViewController()
            self.navigationController?.pushViewController(myInformation, animated: true)
        default: break
            
        }
    }
    
    //MARK: - 充值,只有存管充值
    func rechargeSelectWithFuiou() {
        
        if self.accountModel != nil && self.accountModel?.map != nil {
            
            if self.accountModel?.map?.isFuiou == 0 { //没有开通
                self.gotoOpenCustodyAccount()
                
            } else { //已经开通了
                MobClick.event("0300001")
                let rechargeVC = JSSaveRechargeViewController()
                rechargeVC.barType = .red
                self.navigationController?.pushViewController(rechargeVC, animated: true)
            }
        }
    }
    
    //MARK: - 提现,选择提现方式
    func withdrawChooseSelect() -> () {
        
        if self.accountModel != nil && self.accountModel?.map != nil {
    
            if self.accountModel?.map?.balance == 0.0 { //平台账户等于0
                
                if self.accountModel?.map?.isFuiou == 0 { //没有开通
                    self.gotoOpenCustodyAccount()
                    
                } else { //开通
                    self.withdrawFuiou() //存管提现
                }
                
            } else { //平台账户有余额

                if self.accountModel?.map?.isFuiou == 0 { //没有开通
                    var view: JSChooseViewFirst?
                    view = JSChooseViewFirst.animateWindowsAddSubView(status: 0)
                    view?.titleLabel_1.text = "(账户余额：" + PD_NumDisplayStandard.numDisplayStandard("\((self.accountModel?.map?.balance)!)", decimalPointType: 1, numVerification: false) + ")"
                    
                    view?.leftBottomButtonCallback = { //去开通
                        let controller = JSOpenAccountFuiouViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                    view?.rightBottomButtonCallback = { //继续提现
                         self.withdrawSelect() //平台提现
                    }
                    
                } else { //开通
                    
                    var view: JSChooseView?
                    
                    view = JSChooseView.animateWindowsAddSubView(status: 0)
                    view?.titleLabel_1.text = "(账户余额：" + PD_NumDisplayStandard.numDisplayStandard("\((self.accountModel?.map?.balance)!)", decimalPointType: 1, numVerification: false) + ")"
                    view?.titleLabel_2.text = "(账户余额：" + PD_NumDisplayStandard.numDisplayStandard("\((self.accountModel?.map?.balanceFuiou)!)", decimalPointType: 1, numVerification: false) + ")"
                    
                    view?.bottomClickCallback = { (indicateFlag: Int,status: Int)in
                        
                        if status == 0 { //两个都有
                            
                            if indicateFlag == 0 {
                                MobClick.event("0500007")
                                self.withdrawSelect() //平台提现
                                
                            } else {
                                MobClick.event("0500002")
                                self.withdrawFuiou() //存管提现
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    //去平台提现
    func withdrawSelect() {
        self.view.showLoadingHud()
        WithdrawalsApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            self.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("我的账户 - 提现\(resultDict)")
            let withdrawalsHomeModel = WithdrawalsHomeModel(dict: resultDict!)
            
            if withdrawalsHomeModel.map != nil {
                
                if withdrawalsHomeModel.map?.bankNum == nil {
                    let controller = JSOpenAccountFuiouViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else {
                    let withdrawal = JSWithdrawViewController1()
                    withdrawal.barType = .red
                    withdrawal.model = withdrawalsHomeModel.map
                    self.navigationController?.pushViewController(withdrawal, animated: true)
                }
            }
            
        }, failure: { (request: YTKBaseRequest!) -> Void in
            self.view.hideHud()
            self.view.showTextHud("网络错误")
        })
    }
    
    //存管提现
    func withdrawFuiou() {
        let withdrawal = JSWithdrawFuiouViewController()
        withdrawal.barType = .red
        self.navigationController?.pushViewController(withdrawal, animated: true)
    }
    
    //MARK: 提示开户弹窗
    func gotoOpenCustodyAccount() {
        
        let custodyAccountView: JSIndicateDepositoryPopView = Bundle.main.loadNibNamed("JSIndicateDepositoryPopView", owner: self, options:nil)?.first as! JSIndicateDepositoryPopView
        custodyAccountView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        custodyAccountView.isUserInteractionEnabled = true
        
        let wd = UIWindow(frame: UIScreen.main.bounds)
        wd.windowLevel = UIWindowLevelAlert
        wd.addSubview(custodyAccountView)
        wd.makeKeyAndVisible()
        
        self.bottomWindow = wd
        
        //暂不开通
        custodyAccountView.cancleOpenAccountBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
            
            UserModel.shareInstance.isShowOpenWindow = 0
        }
        
        //立即开通
        custodyAccountView.openCustodyAccountBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
            let controller = JSOpenAccountFuiouViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
            UserModel.shareInstance.isShowOpenWindow = 0
        }
        
        //关闭弹窗
        custodyAccountView.closeBtnBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
            
            UserModel.shareInstance.isShowOpenWindow = 0
        }
    }
    
    //MARK: 懒加载
    lazy var myAccountCell:JSMyAccountCell? = {
        let cell:JSMyAccountCell = Bundle.main.loadNibNamed("JSMyAccountCell", owner: self, options: nil)?.first as! JSMyAccountCell
        cell.selectionStyle = .none
        return cell
    }()
    
    //MARK: 变量赋值
    func setupArray() {
        
        iconArr = ["js_mine_detail1","js_mine_detail2","js_mine_detail3","js_mine_detail4","js_mine_detail5"]
        titleArr = ["我的投资","优惠券","体验金","我的邀请","安全中心"]
    }
    
    /*
     上拉加载更多
     */
    override func pullRefresh(){
        super.pullRefresh()
    }
    
    /**
     下拉刷新
     */
    override func dropDownLoading(){
        
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSMyAccountViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
