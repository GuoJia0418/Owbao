//
//  LocationController.swift
//  Owbao
//
//  Created by lufeng on 16/3/28.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class LocationController: BaseViewController,UIWebViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate ,WKScriptMessageHandler {
    
    var model: HomeBannerModel?                  //点击banner传过来的banner model
    var shareModel:JSLotaryModel?                //翻翻乐分享后的model
    var bottomWindow:UIWindow?                  //显示弹窗的
    var web: WKWebView!                         //显示网页的浏览器
    var productID: Int! = 0                      //产品ID，用户有时候页面跳转传递ID
    var belowButton: UIButton!                  //视图最下面的按钮、有时需要显示立即注册等等内容
    var homeBtnIndex: Int = 0                    //点击进入网页的按钮标记
    var activityView: HYActivityView?            //分享
    //赚钱任务
    var afid: Int = 0                //活动id
    var activityUrl: String? = ""    //活动url
    //web链接
    var linkURL: String? = ""   //iphone活动标链接web
    var progress: UIProgressView?
    var isAnimation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_arrows"), style: .plain, target: self, action: #selector(LocationController.leftBarButtonItemAction(_:)))
        self.createView()
        //iphone7活动标分享
        setupRightBtn()
        self.refreshView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden ?? true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
//        self.clearCache()
    }

    override func popActionWillExecute() {
        self.refreshView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearCache()
    }
    
    deinit {
        // 一定要移除
        if self.web != nil {
            self.web.configuration.userContentController.removeScriptMessageHandler(forName: "ShareMethod")
            self.web.removeObserver(self, forKeyPath: "estimatedProgress")
            self.web.navigationDelegate = nil
        }
    }
    
    //MARK: - 设置右侧按钮
    func setupRightBtn()
    {
        ///iPhone
        ///app2lottery
        let iphoneStr = "/special"
        let lotteryStr = "/app2lottery"
        if (model != nil) && (model?.location != "") && (model?.location.contains(lotteryStr) == true)
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "js_banner_share"), style: .plain, target: self, action: #selector(LocationController.shareIphone))
        }
        else if (model != nil) && (model?.location != "") && (model?.location.contains(iphoneStr) == true)
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "js_banner_share"), style: .plain, target: self, action: #selector(LocationController.shareIphoneProduct))
        }
        
        
        if self.linkURL != nil && self.linkURL != ""
        {
            //去除空格
            self.linkURL = self.linkURL?.replacingOccurrences(of: " ", with: "")
            if self.linkURL?.contains(lotteryStr) == true
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "js_banner_share"), style: .plain, target: self, action: #selector(LocationController.shareIphone))
            }
            else if self.linkURL?.contains(iphoneStr) == true
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "js_banner_share"), style: .plain, target: self, action: #selector(LocationController.shareIphoneProduct))
            }
        }

    }
    
    //MARK: - 翻翻乐分享
    func shareIphone()  {
        self.pageShare(1002)
    }
    //MARK: - iphone7标分享
    func shareIphoneProduct()  {
        self.pageShare(1003)
    }
    
    //MARK: - 视图初始化
    func createView() {
        
        let height = SCREEN_HEIGHT - 60
        self.belowButton = UIButton(frame: CGRect(x: 0,y: height,width: SCREEN_WIDTH, height: 44))
        self.belowButton.setTitle("立即注册", for: UIControlState())
        self.belowButton.setTitleColor(UIColor.white, for: UIControlState())
        self.belowButton.backgroundColor = DEFAULT_ORANGECOLOR
        self.belowButton.addTarget(self, action: #selector(LocationController.belowButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.belowButton)
        
        // 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self as WKScriptMessageHandler, name: "ShareMethod")
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        // 高端的自定义配置创建WKWebView
        self.web = WKWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.view.bounds.size.height - 64), configuration: config)
        // 设置代理
        self.web.navigationDelegate = self
        
//        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
//        let request = URLRequest(url: url!)
//        self.web.load(request)
        
        // 将WebView添加到当前view
        self.view.addSubview(self.web)
        
        //进度条
        let progress = UIProgressView()
        progress.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2)
        progress.progressTintColor = DEFAULT_REDCOLOR
        progress.progressViewStyle = .default
        progress.trackTintColor = UIColor.white
        self.view.addSubview(progress)
        self.progress = progress
        
        //添加观察者
        self.web.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.old], context: nil)
    }
    
    //观察回调
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            self.progress?.alpha = 1.0
            self.progress?.setProgress(Float(self.web.estimatedProgress), animated: true)
            
            if self.web.estimatedProgress >= 1.0 {
                
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
                    self.progress?.alpha = 0
                }, completion: { (complete) in
                    if complete {
                        self.progress?.setProgress(0, animated: false)
                    }
                })
            }
        }
    }
    
    
    func leftBarButtonItemAction(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
//        if self.web.canGoBack == false{
//            self.navigationController?.popViewController(animated: true)
//        }else{
//            self.web.goBack()
//        }
    }

   //MARK: - 修改跳转的地方
    func refreshView() {
        
        var url:URL!
        if model == nil
        {
            if homeBtnIndex == 1 {  //iphone7的活动详情页
                self.linkURL = self.linkURL?.replacingOccurrences(of: " ", with: "")
                url = URL(string: self.linkURL!)
                navigationItem.title = "活动详情"
            }
            else if homeBtnIndex == 3
            {
                url = URL(string: BASE_URL + BankLimitAmount_Api)
                navigationItem.title = "银行限额"
            }
            else if  homeBtnIndex == 4
            {
                if activityUrl != ""
                {
                    let aUrl = self.activityUrl?.replacingOccurrences(of: " ", with: "")
                    self.activityUrl = aUrl! + "?uid=\((UserModel.shareInstance.uid)!)&afid=\(afid)"
                    url = URL(string: self.activityUrl!)
                    navigationItem.title = "邀请详情"
                }
            }
            else if homeBtnIndex == 5
            {
                if self.linkURL != nil && self.linkURL != ""
                {
                    //去除空格
                    self.linkURL = self.linkURL?.replacingOccurrences(of: " ", with: "")
                    url = URL(string: self.linkURL!)
                    if UserModel.shareInstance.uid != 0
                    {
                        url = URL(string: self.linkURL! + "?uid=\((UserModel.shareInstance.uid)!)")
                    }
                    else
                    {
                        url = URL(string: self.linkURL!)
                    }
                    navigationItem.title = "iPhone活动标"
                }
                
            }
            else if homeBtnIndex == 6
            {
                //点击查看中奖者视频
                if self.linkURL != nil && self.linkURL != ""
                {
                    //去除空格
                    self.linkURL = self.linkURL?.replacingOccurrences(of: " ", with: "")
                    url = URL(string: self.linkURL!)
                    navigationItem.title = "中奖者感言"
                }
                
            } else if homeBtnIndex == 7 {
                url = URL(string: BASE_URL + GetMoneyDidSelected_Api + "?uid=\((UserModel.shareInstance.uid)!)")
                navigationItem.title = "详情"
                
            } else if homeBtnIndex == 8 { //开放日
//                url = URL(string: BASE_URL + ActList + "?uid=\((UserModel.shareInstance.uid)!)")
                url = URL(string: BASE_URL + Openday_Url)
                navigationItem.title = "活动详情"
            }
            
        } else {
            navigationItem.title = "\((model?.title)!)"
            if UserModel.shareInstance.isLogin == 1
            {
                url = (model?.location.contains("?") == true) ? URL(string: "\((model?.location)!)&uid=\((UserModel.shareInstance.uid)!)&channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)") : URL(string: "\((model?.location)!)?uid=\((UserModel.shareInstance.uid)!)&channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)")
                
            }
            else
            {
                url = (model?.location.contains("?") == true) ? URL(string: "\((model?.location)!)&channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)") : URL(string: "\((model?.location)!)?channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)")
                
//                if model?.location.contains("/app2lottery") == true
//                {
//                    url = (model?.location.contains("?") == true) ? URL(string: "\((model?.location)!)&channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)") : URL(string: "\((model?.location)!)?channel=\(1)&version=\(SYSTEM_VERSION)&token=\((UserModel.shareInstance.token)!)")
//                }
//                else
//                {
//                    url = URL(string: "\((model?.location)!)")
//                }
            }
        }
        
//        let height = SCREEN_HEIGHT - 60
        self.web.frame = CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT - 64)
        
        //测试注释一下
        print("输出url = \(url)")
        
        if url != nil {
            let request = URLRequest(url: url!)
            web.load(request)
        }

    }
    
    //MARK: - 清除缓存
    func clearCache() {
        let dateFrom: NSDate = NSDate.init(timeIntervalSince1970: 0)
        if #available(iOS 9.0, *)
        {
            let websiteDataTypes: NSSet = WKWebsiteDataStore.allWebsiteDataTypes() as NSSet
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date) {
                print("清空缓存完成")
            }
            
        } else {
            
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = (libraryPath as NSString).appending("/Cookies")
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
        
    }
    
    //MARK: - WKNavigationDelegate 代理方法
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        self.view.showLoadingHud()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
            self.progress?.alpha = 0
        }, completion: { (complete) in
            
            if complete {
                self.progress?.setProgress(0, animated: false)
            }
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlStr = navigationAction.request.url?.absoluteString
        print("decidePolicyFor 链接地址\(urlStr)")
        
        if urlStr != nil {
            self.analysisURLString(urlStr!,navigationAction: navigationAction,decisionHandler: decisionHandler)
        }
    }
    
    /**
     *  解析URLString字符串
     *  URLString: 待解析的URL
     *  decisionHandler： 回调
     */
    func analysisURLString(_ URLString: String,navigationAction: WKNavigationAction,decisionHandler: (WKNavigationActionPolicy) -> Void) -> () {
        
        if (URLString.hasPrefix("jsmp:")) {
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            let parameterStr = URLString.replacingOccurrences(of: "jsmp://", with: "")
            let replaceQuestionStr = parameterStr.replacingOccurrences(of: "?", with: "&")
            let strArray = replaceQuestionStr.components(separatedBy: "&")
            var dict: Dictionary<String,String> = [:]
            
            for str in strArray {
                
                let keyValueArray = str.components(separatedBy: "=")
                if keyValueArray.count >= 2 {
                    dict[keyValueArray[0]] = keyValueArray[1]
                }
            }
            
            var page = 0
            var pid = 0
            var phoneNo: String? = ""
            var ptype = 0
            var atid = 0
            var giftmoney = 0
            var ppid = 0
            
            //体验标
            var phone:String? = ""
            
            //开放日
            var artiId = 0
            var openDayId = 0
            
            if dict["page"] != nil {
                page = Int(dict["page"]!)!
            }
            
            if dict["pid"] != nil {
                pid = Int(dict["pid"]!)!
            }
            
            if dict["ppid"] != nil {
                ppid = Int(dict["ppid"]!)!
            }
            
            if dict["phoneNo"] != nil {
                phoneNo = dict["phoneNo"]!
            }
            
            if dict["ptype"] != nil {
                ptype = Int(dict["ptype"]!)!
            }
            if dict["atid"] != nil {
                atid = Int(dict["atid"]!)!
            }
            if dict["giftmoney"] != nil {
                giftmoney = Int(dict["giftmoney"]!)!
            }
            if dict["phone"] != nil {
                phone = dict["phone"]!
            }
            
            //开放日
            if dict["artiId"] != nil {
                artiId = Int(dict["artiId"]!)!
            }
            
            if dict["openDayId"] != nil && dict["openDayId"] != "" {
                openDayId = Int(dict["openDayId"]!)!
            }
            
            switch page {
                
            case 1:
                self.navigationController?.popViewController(animated: true)
                break
            case 2:
                
                if homeBtnIndex == 4
                {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.toInvestListVC()
                    RootNavigationController.goToInvestList(controller: self)

                }
                else
                {
                    self.navigationController?.popViewController(animated: false)
                    self.toInvestListVC()
                    
                    RootNavigationController.goToInvestList(controller: self)
                }
                
                break
            case 3:
                self.toNoviceVC(pid)
                break
            case 4:
                self.toLoginView()
                break
            case 5:
                self.toConfirmPassWordVC(phoneNo!)
                break
            case 6:
                self.toFindPasswordVC(phoneNo!)
                break
            case 7:
                self.toRegisterVC(phoneNo!)
                break
            case 8:
                RootNavigationController.goToInvestList(controller: self)
                break
            case 9:
                self.toProductDetailVC(pid, ptype: ptype, atid: atid)
                break
            case 10:
                self.toConfirmNvestmentVC(pid, ptype: ptype, atid: atid)
                break
            case 11:
                self.toMyaccountVC()
                break
            case 12:
                self.toMyMailVC()
                break
            case 13:
                self.toMyRechargeVC()
                break
            case 14:
                self.toWithdrawalsVC()
                break
            case 15:
                self.toMyAssetsVC()
                break
            case 16:
                self.toMycouponVC()
                break
            case 17:
                self.toMyInvitationVC()
                break
            case 18:
                self.toMyInfoVC()
                break
            case 19:
                
                break
            case 20:
                self.toJYPasswordVC()
                break
            case 21:
                self.toMyInvestVC()
                break
            case 22:
                self.toMyDetailVC()
                break
            case 23:
                self.toMoreVC()
                break
            case 24:
                self.toAboutVC()
                break
            case 25:
                self.toProposalVC()
                break
            case 26:
                self.toMyBankVC()
                break
            case 27:
                self.toAuthenticationVC()
                break
            case 28:
                self.toProtocalVC()
                break
            case 29:
                self.toUserAgreementVC()
                break
            case 30:
                self.toServiceAgreementVC()
                break
            case 31:
                self.toBankLimit()
                break
            case 32:
                self.toNoviceVC(pid)
                break
            case 35:  //进入详情
                self.toInvestActivity(pid)
                break
            case 36: //预约
                self.toAppointmentController(ppid)
                break
            case 37://去修改地址
                self.toModifyAddressController()
                break
            case 38://去春节压岁钱界面
                self.toSpringFestivalController()
                break
            case 39://去体验金界面
                self.toEperienceController()
                break
            case 40://去体验标详情
                self.toEperienceDetailController()
                break
            case 41://去微信
                self.openWechat()
                break
            case 42://开放日报名
                self.openEnrollViewController(openDayId)
                break
            case 43://开放日详情
                self.openEnrollDetailViewController(artiId)
                break
            case 100:
                //邀请好友三重礼
                self.pageShare(page)
                break
            case 101:
                self.shareAction(page,giftMoney: giftmoney)
                break
            case 102:
                self.toExperienceRegisterVC(phone!)
                break
            case 200:
                self.shareActionWithInvitedActivity()
                break
            case 500://异地登录弹窗
                self.toLogin()
                break
            default:
                break
            }
            
        } else if URLString.contains("/bankBillList") == true {
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            RootNavigationController.goToInvestList(controller: self)
            
        } else if URLString.contains("/zhuce") == true || URLString.contains("/dl") == true {
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            
            if UserModel.shareInstance.isLogin == nil || UserModel.shareInstance.isLogin == 0 {
                self.toLoginView()
            } else {
                let alertView = UIAlertView()
                alertView.delegate = self
                alertView.message = "您已领取，请投资新手标？"
                alertView.addButton(withTitle: "取消")
                alertView.addButton(withTitle: "确定")
                alertView.show()
            }
            
        } else {
            
            if navigationAction.targetFrame == nil {
                web.load(navigationAction.request)
            }
            print("url跳转")
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            
            if self.productID == 0 {
                self.view.showTextHud("您已购买过新手标")
            } else {
                self.toInvestmentView(self.productID!)
            }
        }
    }
    
    /**
     *  登录页
     */
    func toLoginView(){
        
        if UserModel.shareInstance.isLogin == 1 {
            self.view.showTextHud("当前账号已登录请退出重试")
        } else {
            //弹出登录控制器
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
        }
    }
    
    /**
     * 异地登录
     */
    func toLogin(){
        
        //弹出登录控制器
        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
    }
    
    
    /**
     *  新手购买页
     */
    func toInvestmentView(_ pid:Int){
        
        
    }
    
    /**
     *  去新手页
     *
     *  @parameter pid: 新手标产品id
     */
    func toNoviceVC(_ pid:Int) {
        let controller = JSInvestDetailViewController()
        controller.productNameID = pid
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /**
     *  去忘记密码页
     *
     *  @parameter phoneNo: 手机号码
     */
    func toFindPasswordVC(_ phoneNo:String){
        let findVC = FindPasswordViewController()
        findVC.phoneNo = phoneNo
        findVC.type = 2
        self.navigationController?.pushViewController(findVC, animated: true)
    }
    /**
     去输入密码页
     
     - parameter phone: 手机号码
     */
    func toConfirmPassWordVC(_ phoneNo:String){
        let confirmVC = ConfirmPassWordController()
        confirmVC.phoneNo = phoneNo // 传入所需手机号
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }
    
    /**
     *  去注册页
     *
     *  @parameter phoneNo: 手机号码
     */
    func toRegisterVC(_ phoneNo:String){

        if UserModel.shareInstance.isLogin == 1 {
            self.view.showTextHud("有账号已登录请退出重试")
        } else {
            self.present(JSRegisterPhoneViewController.getPresentController(), animated: true, completion: nil)
        }
        
    }
    
    /**
     *  体验标注册
     *
     *  @parameter phoneNo: 手机号码
     */
    func toExperienceRegisterVC(_ phoneNum:String){
        
        if UserModel.shareInstance.isLogin == 1 {
            self.view.showTextHud("有账号已登录请退出重试")
        } else {
//            let controller = JSRegisterViewController()
//            controller.phoneNo = phoneNum.replacingOccurrences(of: " ", with: "") //传入所需手机号
//            let nvc = RootNavigationController(rootViewController:controller)
//            controller.popType = .dismissGoHome
//            self.present(nvc, animated: true, completion: nil)
            let controller = JSRegisterPhoneViewController()
//            controller.phoneNo = phoneNum.replacingOccurrences(of: " ", with: "") //传入所需手机号
            let nvc = RootNavigationController(rootViewController:controller)
            controller.popType = .dismissGoHome
            self.present(nvc, animated: true, completion: nil)
        }
    }
    
    /**
     * 产品详情页
     *
     * @parameter pid: 产品id
     */
    func toProductDetailVC(_ pid: Int, ptype: Int , atid:Int) {
        let productDetailVC = JSInvestDetailViewController()
        productDetailVC.productNameID = pid
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    /**
     *  确认投资页
     *
     *  @parameter pid: 产品id
     */
    func toConfirmNvestmentVC(_ pid: Int, ptype: Int , atid:Int){
        
        let productDetailVC = JSInvestDetailViewController()
        productDetailVC.productNameID = pid
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    //MARK: - 去投资列表界面
    func toInvestListVC()
    {
        RootNavigationController.goToInvestList(controller: self)
    }
    
    /**
     *  我的账户 
     */
    func toMyaccountVC(){
        RootNavigationController.goToMyAccount(controller: self)
    }
    
    /**
     *  我的消息
     */
    func toMyMailVC(){
        let myMail = MoreScreenSlidingRootController()
        myMail.vcType = 0
        self.navigationController?.pushViewController(myMail, animated: true)
    }
    
    /**
     *  我要充值
     */
    func toMyRechargeVC() {
        

    }
    
    /**
     * 我要提现
     */
    func toWithdrawalsVC(){
        
        
    }
    
    /**
     * 我的资产
     */
    func toMyAssetsVC(){
        
        
    }
    
    /**
     * 我的红包
     */
    func toMycouponVC(){
        let moreScreenVC = MoreScreenSlidingRootController()
        moreScreenVC.vcType = 1
        self.navigationController?.pushViewController(moreScreenVC, animated: true)
    }
    
    /**
     * 我的邀请
     */
    func toMyInvitationVC(){
        let invita = JSInvitedViewController()
        self.navigationController?.pushViewController(invita, animated: true)
    }
    
    /**
     * 我的信息
     */
    func toMyInfoVC() {
        let myInformation = JSMyInformationViewController()
        self.navigationController?.pushViewController(myInformation, animated: true)
    }
    
    /**
     * 我的明细
     */
    func toMyDetailVC(){
        
        
    }
    
    //MARK: 我的投资
    func toMyInvestVC(){
        let moreScreenVC = MoreScreenSlidingRootController()
        moreScreenVC.vcType = 2
        self.navigationController?.pushViewController(moreScreenVC, animated: true)
    }
    
    //MAKR: 重置交易密码
    func toJYPasswordVC(){
        let vc = JYPassWordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 更多
    func toMoreVC(){
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 3
    }
    
    //MARK: 关于我们
    func toAboutVC(){
        let aboutVC = JSAboutUsViewController()
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    //MARK: 意见反馈
    func toProposalVC(){
        let proposalVC = JSSuggestionViewController()
        self.navigationController?.pushViewController(proposalVC, animated: true)
    }
    
    //MARK: 我的银行卡
    func toMyBankVC(){
        let myBankCard = MyBankCardController()
        self.navigationController?.pushViewController(myBankCard, animated: true)
    }
    
    //MARK: 信息认证（开通存管）
    func toAuthenticationVC(){
        let controller = JSOpenAccountFuiouViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
//        let authentication = JSAuthenticationInformationVC()
//        self.navigationController?.pushViewController(authentication, animated: true)
    }
    
    //MARK: 债权转让协议
    func toProtocalVC() {
//        let protocalVC = ProtocolController()
//        protocalVC.protocolName = "债权转让协议"
//        protocalVC.Open = true
//        self.navigationController?.pushViewController(protocalVC, animated: true)
    }
    
     //MARK: 用户协议
    func toUserAgreementVC(){
//        let protocalVC = ProtocolController()
//        protocalVC.protocolName = "用户协议"
//        self.navigationController?.pushViewController(protocalVC, animated: true)
    }
    
    //MARK: 服务协议
    func toServiceAgreementVC(){
//        let protocalVC = ProtocolController()
//        protocalVC.protocolName = "服务协议"
//        self.navigationController?.pushViewController(protocalVC, animated: true)
    }
    
    //MARK: 银行限额
    func toBankLimit(){
        let locationVC = LocationController()
        locationVC.homeBtnIndex = 3
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    //MARK: 去投即送详情
    func toInvestActivity(_ pid: Int) -> () {
        let controller = JSInvestDetailViewController()
        controller.productNameID = pid
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 去预约
    func toAppointmentController(_ pid: Int) -> () {
        let controller = InvestActivityAppointmentViewController()
        controller.productNameID = pid
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 去修改地址控制器
    func toModifyAddressController() -> () {
//        let controller = ModifyAddressController()
//        controller.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 去修改地址控制器
    func toEperienceController() -> () {
        //去我的体验金
        let moreScreenVC = MoreScreenSlidingRootController()
        moreScreenVC.vcType = 5
        self.navigationController?.pushViewController(moreScreenVC, animated: true)
    }
    
    //MARK: 去春节压岁钱控制器
    func toSpringFestivalController() -> () {
        
        
    }
    
    //MARK: 去体验标详情界面
    func toEperienceDetailController() -> () {
        let controller = ExperienceInvestViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 跳转到微信并复制微信号
    func openWechat() -> () {
        
        if WXApi.isWXAppInstalled() == true {
            UIApplication.shared.openURL(URL(string: "weixin://\(WX_KEY)")!)
            let pastet = UIPasteboard.general
            pastet.string = "jsfax2016"
        } else {
            self.view.showTextHud("请先安装微信")
        }
    }
    
    //MARK: 跳转到开放日报名界面
    func openEnrollViewController(_ openDayId: Int) -> () {
        let controller = EnrollViewController()
        controller.openDayId = openDayId
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 跳转到活动详情
    func openEnrollDetailViewController(_ artiId: Int) -> () {
        let controller = LocationController()
        controller.model = HomeBannerModel(dict: ["location": BASE_URL + "/GGXQ?artiId=\(artiId)&from=kfr" as AnyObject,"title": "活动详情" as AnyObject])
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /**
     *  投即送的分享
     *
     */
    func shareActionWithInvitedActivity() -> () {
    
        self.shareMethod(title: SHARE_TITLE4, description: SHARE_DESCRIPTION4, url: BASE_URL + "/tjs?wap=true", picUrl: SHARE_ICON_URL4, picName: "toujisong_fenxiang", shareflag: "", haveParam: "0")
        
    }

    func belowButtonAction(_ sender: UIButton) {
        
        if navigationItem.title == "邀请好友" {
            shareAction(0,giftMoney: -1)
        }
        
        if navigationItem.title == "注册送礼" {
            view.layoutIfNeeded()
            //弹出登录控制器
//            UserModel.shareInstance.logout() //退出登录
//            
//            let controller = JSLoginViewController()
//            controller.popType = .dismissGoHome
//            
//            let navController = RootNavigationController(rootViewController: controller)
//            self.present(navController, animated: true, completion: nil)
            
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
        }
    }

    //MARK: page == 100的分享
    func pageShare(_ page: Int)
    {
        if page == 100
        {
            //邀请好友三重礼
            self.shareMethod(title: SHARE_TITLE2, description: SHARE_DESCRIPTION2, url: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", picUrl: SHARE_ICON_URL, picName: "wechat", shareflag: "", haveParam: "0")
            
        }
        else if page == 1002
        {
            if UserModel.shareInstance.isLogin == 1
            {
                //翻翻乐活动的分享
//                self.shareMethod(title: SHARE_TITLE_LOTTERY, description: SHARE_DESCRIPTION_LOTTERY, url: BASE_URL + "/app2lottery?wap=true", picUrl: SHARE_ICON_URL_LOTTERY, picName: "js_banner_app2lottery", shareflag: "", haveParam: "0", successBlock: {
//                    //调分享的接口
//                    self.lotteryData()
//                })

                var image = UIImage(named: "js_banner_app2lottery")
                let urlStr = URL(string: SHARE_ICON_URL_LOTTERY)
                let data = try? Data(contentsOf: urlStr!)
                
                if data != nil {
                    if UIImage(data: data!) != nil {
                        image = UIImage(data: data!)!
                    }
                }
                
                //分享给微信朋友模型
                //UIImage(named: "wechat")!
                let wxShareToFriendsModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: BASE_URL + "/app2lottery?wap=true", shareTitle: SHARE_TITLE_LOTTERY,shareDescription: SHARE_DESCRIPTION_LOTTERY)
                
                //分享到微信朋友圈模型
                let wxTimeLineModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: BASE_URL + "/app2lottery?wap=true", shareTitle: SHARE_TITLE_LOTTERY,shareDescription: SHARE_DESCRIPTION_LOTTERY)
                
                //分享到QQ用到的模型
                let qqModel = ShareInfoModel(shareImageURLString: SHARE_ICON_URL_LOTTERY, shareImage: UIImage(), shareURLString: BASE_URL + "/app2lottery?wap=true", shareTitle: SHARE_TITLE_LOTTERY,shareDescription: SHARE_DESCRIPTION_LOTTERY)
                
                //开始分享
                let view = InvitedBottowPushView.animateWindowsAddSubView(wxShareToFriendsModel, WXTimelineModel: wxTimeLineModel, QQModel: qqModel)
                
                //分享回调
                view.shareCallback = { (isSuccess: Bool) in
                    print("\(isSuccess)")
                    if isSuccess == true
                    {
                        //调分享的接口
                        self.lotteryData()
                    }
                }

            }
            else
            {
                self.toLoginView()
            }
            
        }
        else if page == 1003
        {
            if UserModel.shareInstance.isLogin == 1
            {
                //IPhone7活动的分享
                self.shareMethod(title: SHARE_IPHONE_TITLE, description: SHARE_IPHONE_DESCRIPTION, url: BASE_URL + "/special?upgrade=1&wap=true", picUrl: SHARE_IPHONE_ICON_URL, picName: "js_iphone_share", shareflag: "", haveParam: "0")
                
            }
            else
            {
                self.toLoginView()
            }
            
        }
        else if page == 300
        {
            if UserModel.shareInstance.isLogin == 1
            {
                //端午节分享
                self.shareMethod(title: SHARE_DragonBoatFestival_TITLE, description: SHARE_DragonBoatFestival_DESCRIPTION, url: BASE_URL + "/dragonboat?upgrade=1&wap=true", picUrl: SHARE_DragonBoatFestival_ICON_URL, picName: "js_dragonboat_share", shareflag: "", haveParam: "0")
                
            }
            else
            {
                self.toLoginView()
            }
            
        }

    }

    //MARK: - 翻翻乐
    func lotteryData()
    {
        JSLotaryApi(Uid: UserModel.shareInstance.uid!).startWithCompletionBlock(success: { (request:YTKBaseRequest?) in
            let resultDict = request?.responseJSONObject as? [String: AnyObject]
            print("分享后的\(resultDict!)")
            self.shareModel = JSLotaryModel(dict: resultDict!)
            if self.shareModel?.success == true
            {
                self.bottomWindow =  JSLotaryView.dispayPopView()
            }
            else
            {
                if self.shareModel?.errorCode == "1001"
                {
                    self.view.showTextHud("已经分享过")
                }
                else
                {
                    self.view.showTextHud((self.shareModel?.errorMsg)!)
                }
            }
            
        }) { (request:YTKBaseRequest?) in
            
            self.view.showTextHud("系统错误")
        }
    }
    //MARK: - 分享
    func shareAction(_ page: Int,giftMoney:Int)
    {
        if homeBtnIndex == 4
        {
            self.shareMethod(title: SHARE_TITLE1, description: "", url: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", picUrl: "https://www.jushengcaifu.com/images/newbie.png", picName: "js_invite_share", shareflag: "", haveParam: "0")
            
        }
        else if page == 101
        {
            let SHARE_TITLE_PARTY = "我在参加双蛋party,抽中了\(giftMoney)元现金，你也来参加吧！"
            self.shareMethod(title: SHARE_TITLE_PARTY, description: "", url: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", picUrl: "https://www.jushengcaifu.com/images/activity_shangdan.png", picName: "js_invite_share", shareflag: "", haveParam: "0")

        }
        else
        {
            self.shareMethod(title: SHARE_TITLE, description: "", url: BASE_URL + "/zhuce?recommCode=\((UserModel.shareInstance.mobilephone)!)", picUrl: "https://www.jushengcaifu.com/images/applogo.png", picName: "js_invite_share", shareflag: "", haveParam: "0")
        }
        
    }
    
    func testJS(){
        
    }
    
    //MARK: - WKScriptMessageHandler 的方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // 判断是否是调用原生的
        if "ShareMethod" == message.name {
            // 判断message的内容，然后做相应的操作
            if message.body is NSDictionary{
            
                let dict = message.body as! NSDictionary
                self.shareMethod(title: dict["title"] as! String, description: dict["description"] as! String, url: dict["url"] as! String, picUrl: dict["picUrl"] as! String, picName: "js_share_summer_icon", shareflag: dict["shareflag"] as! String, haveParam: "1")
            }
            else{
//                print("输出webView的内容==\(message.body)")
            }
        }
    }
    
    
    //MARK: - 分享
    func shareMethod(title: String,description: String, url: String,picUrl: String,picName: String, shareflag: String,haveParam: String)
    {
        if UserModel.shareInstance.isLogin == 1
        {
            var image = UIImage(named: picName)
            let urlStr = URL(string: picUrl)
            let data = try? Data(contentsOf: urlStr!)
            
            if data != nil {
                if UIImage(data: data!) != nil {
                    image = UIImage(data: data!)!
                }
            }
            // haveParam = 0: 不拼接参数  1：拼接参数
            var shareUrl = ""
            if haveParam == "1"{
                shareUrl = url + "?recommCode=\((UserModel.shareInstance.mobilephone)!)&uid=\((UserModel.shareInstance.uid)!)&shareflag=\(shareflag)&wap=true"
            }else{
                shareUrl = url
            }
            
            //分享给微信朋友模型
            let wxShareToFriendsModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: shareUrl, shareTitle: title,shareDescription: description)
            
            //分享到微信朋友圈模型
            let wxTimeLineModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: shareUrl, shareTitle: title,shareDescription: description)
            
            //分享到QQ用到的模型
            let qqModel = ShareInfoModel(shareImageURLString: picUrl, shareImage: UIImage(), shareURLString: shareUrl, shareTitle: title,shareDescription: description)
            
            //开始分享
            let view = InvitedBottowPushView.animateWindowsAddSubView(wxShareToFriendsModel, WXTimelineModel: wxTimeLineModel, QQModel: qqModel)
            
            //分享回调
            view.shareCallback = { (isSuccess: Bool) in
                print("分享结果==\(isSuccess)")
//                if isSuccess == true {
//                    if successBlock != nil{
//                        successBlock!()
//                    }
//                }
            }
            
        }
        else
        {
            self.toLoginView()
        }
        
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("LocationController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
