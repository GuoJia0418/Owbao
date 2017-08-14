//
//  CustodyWebViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/29.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class CustodyWebViewController: BaseViewController,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,UIAlertViewDelegate {
    var web: WKWebView!                         //显示网页的浏览器
    var linkURL: String?  = ""                   //链接
    var vcType: Int = 0                          //1:开户   2:充值  3:提现  4:存管账户
    var vcFromController: String? = ""
    var progress: UIProgressView?
    var apiModel: ApiModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_arrows"), style: .plain, target: self, action: #selector(leftBarButtonAction))
        self.createView()
        
        //pop手势
        self.popBeforeCallback = { (popType: JSNavigationPop) in
            
            if popType == .nomarl {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: "nil")
            } else if popType == .popToRoot {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: "nil")
            }
            
        }
        
        if self.apiModel != nil {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: (apiModel?.apiURL)!)
            self.web.loadHTMLString((apiModel?.postData)!, baseURL: request.url)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden ?? true{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.clearCache()
//        self.refreshView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearCache()
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
    
    deinit {
        self.web.removeObserver(self, forKeyPath: "estimatedProgress")
        self.web.navigationDelegate = nil
    }
    
    //MARK: - 视图初始化
    func createView(){
        self.web = WKWebView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: self.view.bounds.size.height - 64))
        self.web.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.view.bounds.size.height - 64)
        self.web.navigationDelegate = self
        self.web.uiDelegate = self
        self.view.addSubview(self.web)
        
        //进度条
        let progress = UIProgressView()
        progress.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2)
        progress.progressTintColor = DEFAULT_REDCOLOR
        progress.trackTintColor = UIColor.white
        progress.progress = 0.0
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
    
    //MARK: - 左侧按钮
    func leftBarButtonAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - 刷新视图
//    func refreshView()
//    {
//        //开通存管 uid&phone&token&channel&version
//        //其他 uid&token&channel&version
//        
//        var url:NSURL!
//        //1:开户   2:充值  3:提现
//        if vcType == 1
//        {
//            if linkURL != nil && linkURL != ""
//            {
//                //去除空格
//                linkURL = linkURL?.replacingOccurrences(of: " ", with: "")
//                
//                linkURL = linkURL! + "?uid=\((UserModel.shareInstance.uid)!)&phone=\((UserModel.shareInstance.mobilephone)!)&token=\((UserModel.shareInstance.token)!)&channel=\((1))&version=\((SYSTEM_VERSION))"
//                
//                url = NSURL(string: self.linkURL!)
//                navigationItem.title = "存管账户"
//            }
//        }
//        else
//        {
//            if linkURL != nil && linkURL != ""
//            {
//                //去除空格
//                linkURL = linkURL?.replacingOccurrences(of: " ", with: "")
//                linkURL = linkURL! + "?uid=\((UserModel.shareInstance.uid)!)&token=\((UserModel.shareInstance.token)!)&channel=\((1))&version=\((SYSTEM_VERSION))"
//                
//                url = NSURL(string: self.linkURL!)
//                
//                if vcType == 2
//                {
//                    navigationItem.title = "充值"
//                }
//                else if vcType == 3
//                {
//                    navigationItem.title = "提现"
//                }
//                else
//                {
//                    navigationItem.title = "存管账户信息"
//                }
//                
//            }
//        }
//        
//        print("输出url = \(url)")
//        if url != nil
//        {
//            let request = NSURLRequest(url: url! as URL)
//            web.load(request as URLRequest)
//        }
//    }
    
    //提现：通过form表单提交数据
    class func getCashAction(superController: UIViewController,
                             amount: Double,
                             isChargeFlag: Int) {
        
        let viewModel = JSGetCashViewModel()
        superController.view.showLoadingHud()
        viewModel.requestServer(JSGetCashApi(uid: UserModel.shareInstance.uid ?? 0,
                                             amount: amount,isChargeFlag: isChargeFlag),
                                modelName: "JSGetCashModel",
                                callback: { (baseModel) in
                                    
                                    let model = baseModel as! JSGetCashModel
                                    superController.view.hideHud()
                                    
                                    if model.success == true {
                                        
                                        let web = CustodyWebViewController()
                                        let model_api = ApiModel()
                                        web.navigationItem.title = "提现"
                                        web.popType = .popToRoot
                                        model_api.apiURL = model.map?.fuiouUrl
                                        model_api.postData = model.getFormString()
                                        web.apiModel = model_api
                                        superController.navigationController?.pushViewController(web, animated: true)
                                        
                                    } else {
                                        
                                        if model.errorCode == "XTWH" {
                                            SystemUpdateViewController.presentSystemUpdateController("")//开始弹出维护页
                                        } else if model.errorCode == "9999" {
                                            superController.view.showTextHud("系统错误")
                                        } else if model.errorCode == "9998" {
                                            superController.view.showTextHud("异地登录，请重新登录")
                                            JSLoginViewController.presentLoginControllerDismissGoHomeType(superController as! BaseViewController)
                                        } else {
                                            superController.view.showTextHud(model.errorMsg)
                                        }   
                                    }
                                    
        }) { (error) in
            superController.view.hideHud()
            superController.view.showTextHud(error)
        }
//
//        let viewModel = JSOpenAccountViewModel()
//        viewModel.requestServer(JSOpenAccountApi(uid: UserModel.shareInstance.uid ?? 0,
//                                                      cust_nm: "guojia",
//                                                      certif_id: "341182199004182460",
//                                                      mobile_no: "17800000001",
//                                                      city_id: "2900",
//                                                      parent_bank: "0308",
//                                                      capAcntNo: "6214831217027515"),
//                                                      modelName: "JSOpenAccountModel",
//                                                      callback: { (baseModel) in
//                                                        
//                                                        
//                                                        
//        }) { (errorString) in
//            
//            
//        }
        
    }
    
    class func testApi() {
        
//        let model = JSRchargeVerificationCodeViewModel()
//        model.requestServer(JSRchargeVerificationCodeApi(uid: UserModel.shareInstance.uid ?? 0, amount: "1000"), modelName: "JSRechargeVerificationModel", callback: { (baseModel) in
//            
//            let model_sub = JSRechargeFuiouViewModel()
//            model_sub.requestServer(JSRechargeApi.init(uid: UserModel.shareInstance.uid ?? 0, yzm: "0000"), modelName: "JSRechargeModel", callback: { (baseModel) in
//                
//                
//                
//            }) { (errorString) in
//                
//            }
//        
//        }) { (errorString) in
//            
//        }
    }
    
    
    // MARK: - WKNavigationDelegate 代理方法
    //Alert弹框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("输出弹出框")
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //confirm弹框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //TextInput弹框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (_) in}
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
//            self.progress?.alpha = 0
//        }, completion: { (complete) in
//            
//            if complete {
//                self.progress?.setProgress(0, animated: false)
//            }
//        })
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let urlStr = navigationAction.request.url?.absoluteString
        print("存管跳转界面 链接地址\(urlStr)")
        
        if (urlStr?.hasPrefix("jsmp:"))!
        {
            decisionHandler(WKNavigationActionPolicy.cancel)
            
            let parameterStr = urlStr?.replacingOccurrences(of: "jsmp://", with: "")
            let replaceQuestionStr = parameterStr?.replacingOccurrences(of: "?", with: "&")

            let strArray = replaceQuestionStr?.components(separatedBy: "&")
            var dict:Dictionary<String,String> = [:]
            
            for str in strArray! {
                
                let keyValueArray = str.components(separatedBy: "=")
                if keyValueArray.count >= 2 {
                    dict[keyValueArray[0]] = keyValueArray[1]
                }
            }
            
            //jsmp://page=999?success=false&errorCode=&errorMsg=X(%CD%0Dpn%1AidNo&type=0&amount=
            //jsmp://page=999?success&type&errorCode&errorMsg
            //success为true是成功；type  0开通存管  1充值  2提现   3修改交易密码
            //errorCode=9999时系统错误，其他时显示errorMsg
            var page:String? = ""
            var success:String? = ""
            var type:String? = ""
            var errorCode:String? = ""
            var errorMsg:String? = ""
            
            if dict["page"] != nil {
                page = dict["page"]!
            }
            
            if dict["success"] != nil {
                success = dict["success"]!
            }
            
            if dict["type"] != nil {
                type = dict["type"]!
            }
            
            if dict["errorCode"] != nil {
                errorCode = dict["errorCode"]!
            }
            
            if dict["errorMsg"] != nil {
                let str = dict["errorMsg"]!
                errorMsg = str.urlDecodeUsingDecoding()
            }
            
            //判断
            if page == "999" {
                //存管界面跳转
                self.fuiouPopViewController(page: page!, success: success!, type: type!, errorCode: errorCode!, errorMsg: errorMsg!)
            }
            
        } else if urlStr?.contains("/bankBillList") == true {
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            RootNavigationController.goToInvestList(controller: self)
        }
        else if urlStr?.contains("/zhuce") == true || urlStr?.contains("/dl") == true
        {
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
        }
        else
        {
            if navigationAction.targetFrame == nil
            {
                web.load(navigationAction.request)
            }
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    //MARK:- 存管的判断跳转
    func fuiouPopViewController(page: String,
                                success: String,
                                type: String,
                                errorCode: String,
                                errorMsg: String) {
        if success == "true" {
            
            var alertMsg:String = ""
            switch type {
            case "0"://开通存管
                alertMsg = "存管开户" + errorMsg
                break
            case "1"://充值
                alertMsg = "充值" + errorMsg
                break
            case "2"://提现
                alertMsg = "提现" + errorMsg
                break
            case "3"://修改交易密码
                alertMsg = "修改交易密码" + errorMsg
                break
            default:
                alertMsg = errorMsg
                break
            }
            
            if type != "3"
            {
                self.web.showTextHud(alertMsg)
            }
            
            self.delayPopViewController(type: type)
            
            //存管操作成功发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
            
        }
        else
        {
            var alertMsg:String = ""
            if errorCode == "9999"
            {
                alertMsg = "系统错误"
            }
            else
            {
                alertMsg = errorMsg
            }
            
            if type != "3"
            {
                self.web.showTextHud(alertMsg)
            }
            else
            {   //重置交易密码  并是系统错误 给出提示  其他错误提示是存管来提示
                if errorCode == "9999"
                {
                    self.web.showTextHud(alertMsg)
                }
            }
            
            self.delayPopViewController(type: type)
        }
    }
    
    //MARK:- 跳转界面
    //MARK:- 跳转界面
    func delayPopViewController(type:String)
    {
        delay(block: {
            
//            if type == "3"
//            {
//                self.navigationController?.popViewController(animated: true)
//            } else if type == "2" {
//                self.navigationController?.popToRootViewController(animated: true)
//            } else {
//                
//                var i:Int = 0
//                for vc in (self.navigationController?.viewControllers)!
//                {
//                    print("遍历的接口是\(type(of: vc.self))==来自\(self.vcFromController)")
//                    i += 1
//                    if  "\(type(of: vc.self))" == self.vcFromController
//                    {
//                        self.navigationController?.popToViewController(vc, animated: true)
//                    }
//                    else
//                    {
//                        if i == self.navigationController?.viewControllers.count
//                        {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//                
//            }
            let naviController = self.navigationController as? RootNavigationController
            naviController?.popAction(true, popController: self)
        })
    }
    
    //MARK: - 跳转界面
    //MARK: 登录页
    func toLoginView(){
        
        if UserModel.shareInstance.isLogin == 1 {
            self.view.showTextHud("当前账号已登录请退出重试")
        }
        else
        {
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
        }
    }
    
    //MARK: 字符串转viewcontroller
    func vcstringToViewController(childControllerName:String)->UIViewController {
        //1.获取命名空间
        // 通过字典的键来取值,如果键名不存在,那么取出来的值有可能就为没值.所以通过字典取出的值的类型为AnyObject?
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("命名空间不存在")
            return UIViewController()
        }
        
        //2.通过命名空间和类名转换成类
        let cls: AnyClass? = NSClassFromString(clsName + "." + childControllerName)
        
        //swift中通过class创建一个对象，必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return UIViewController()
        }
        
        //3.通过clss创建对象
        let childController = clsType.init()
        
        return childController
    }
    
}
