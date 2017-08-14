//
//  APPStartConfigure.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/20.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class APPStartManager: NSObject,UpdateAlertViewDelegate,UIAlertViewDelegate {
    
    static let manager  = APPStartManager()
    fileprivate override init() {
    }
    
    var window:     UIView?                     //保存的app窗口
    var resignDate: Date?                       //锁屏时间，超过5分钟就跳出手势密码弹窗
    
    fileprivate var startLogView: APPLogoView?              //启动的logView
    fileprivate var advertisementView: AdvertisementView?   //广告视图
    fileprivate var appVersion: String?                     //appStore 版本号
    
    //MARK: 开始加载app更新（先保存父视图）、广告页、引导页、
    class func appStartConfigure(_ superView: UIView) -> () {
        
        //初始化保存父视图
        let configure = APPStartManager.manager
        configure.window = superView
        configure.startLogView = APPLogoView.configureAPPLogoView(superView) //保存启动视图
        
        //获取服务器更新数据
        configure.downRenewalData()
    }
    
    //手势密码设置逻辑
    func configureGestureUnlock() -> () {
        
        if UserModel.shareInstance.isLogin == 1 {
            
            if UserModel.shareInstance.isPromptGesturePassword == 0 && UserModel.shareInstance.isSetGestureUnlock == 0 && UserModel.shareInstance.realVerify == 1 { //没有提示过 没有设置过 已经实名认证过
                
                //跳出提示，是否设置手势密码
                UserModel.shareInstance.isPromptGesturePassword = 1        //第一次跳出提示
                let alertView = UIAlertView()
                alertView.delegate = self
                alertView.title = "提示"
                alertView.message = "是否立即设置手势密码?"
                alertView.addButton(withTitle: "暂不设置")
                alertView.addButton(withTitle: "立即设置")
                alertView.show()
                
            } else if UserModel.shareInstance.isSetGestureUnlock == 1 && Defaults.object(forKey: "GesturePassword") != nil { // 设置过手势密码
                
                if resignDate == nil || resignDate!.timeIntervalSinceNow / 60 <= -5 { //时间大于5分钟
                    
                    let gestureUnlockViewController = GestureUnlockViewController()
                    gestureUnlockViewController.createView()
                    gestureUnlockViewController.state = GestureUnlockState.verify
                    gestureUnlockViewController.verifyResult = {
                        result in
                        
                        if result {
                            
                            //验证密码成功！！！！！！！！
                        } else {
                            
                            //尝试3次验证密码都失败了
                            UserModel.shareInstance.isLogin = 0
                            UserModel.shareInstance.uid = 0
                            
                            let login = JSLoginViewController.getLoginControllerDismissGoHome()
                            gestureUnlockViewController.navigationController?.pushViewController(login, animated: true)
                            login.phoneNum = UserModel.shareInstance.mobilephone
                            login.view.showLongTextHud("您密码错误3次，请使用账号登录！")
                        }
                    }
                    
                    let nvController = RootNavigationController(rootViewController: gestureUnlockViewController)
                    nvController.isNavigationBarHidden = true
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rootVC!.present(nvController, animated: true, completion: nil)
                }
            }
        }
    }

    fileprivate func AdvertisementViewPushAction(_ URLString: String,title: String) -> () {
        
        self.startLogView?.removeFromSuperview() //移除logo视图
        self.advertisementView?.removeFromSuperview() //移除广告视图
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let controller = LocationController()
        controller.hidesBottomBarWhenPushed = true
        controller.model = HomeBannerModel(dict: ["location": URLString as AnyObject,"title": title as AnyObject])
        let nav =  delegate.rootVC?.viewControllers![0] as! RootNavigationController
        nav.pushViewController(controller, animated: true)
    }

    //请求服务器获知本地app是否需要更新
    fileprivate func downRenewalData() {
        
        RenewalApi().startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("版本更新得到的数据\(resultDict)")

            let renewModel = RenewalModel(dict: resultDict!)
            
            //本地
            let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            
            if renewModel.success == true {
                
                if renewModel.map?.isMaintenance != "" {
                    
                    //创建系统维护view
                    let updateView = JSSystemUpdateView.createSystemUpdateView((renewModel.map?.isMaintenance)!)
                    self.startLogView?.addSubview(updateView) //加载在logView上
                    
                } else {
                    
                    if PD_NumDisplayStandard.compareVersions(currentVersion, second: renewModel.map?.sysAppRenewal?.releaseVersion) < 0 {
                        
                        //版本更新提示请求
                        if renewModel.map?.sysAppRenewal?.isForceUpdate != 0 {
                            
                            let forceUpdataVersion = renewModel.map?.sysAppRenewal?.version
                            if PD_NumDisplayStandard.compareVersions(currentVersion, second: forceUpdataVersion) < 0 {
                                
                                //判断是否含有系统维护中
                                if renewModel.map?.sysAppRenewal?.content != nil {
                                    
                                    if renewModel.map?.sysAppRenewal?.content?.contains("系统维护中") == true {
                                        let alertView = UIAlertView(title: "", message: "系统维护中", delegate: self, cancelButtonTitle: nil)
                                        alertView.show()
                                        
                                    } else {
                                        
                                        let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), buttonTitles: ["立即更新"],text:(renewModel.map?.sysAppRenewal?.content)!)
                                        self.startLogView!.addSubview(updateAlertView)
                                        updateAlertView.delegate = self
                                        return
                                    }
                                    
                                } else {
                                    
                                    let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), buttonTitles: ["立即更新"],text:(renewModel.map?.sysAppRenewal?.content)!)
                                    self.startLogView!.addSubview(updateAlertView)
                                    updateAlertView.delegate = self
                                    return
                                }
                                
                            } else {
                                //print("不强制更新")
                                let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), buttonTitles: ["取消","立即更新"],text:(renewModel.map?.sysAppRenewal?.content)!)
                                self.startLogView!.addSubview(updateAlertView)
                                updateAlertView.delegate = self
                                return
                            }
                            
                        } else {
                            //本地 < app store 不是强制更新   isForce == 0
                            //print("不强制更新")
                            let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), buttonTitles: ["取消","立即更新"],text:(renewModel.map?.sysAppRenewal?.content)!)
                            self.startLogView!.addSubview(updateAlertView)
                            updateAlertView.delegate = self
                            return
                        }
                        
                    } else {
                        //本地 >= 服务器
                        self.goNextAction()
                    }
                }
                
            } else {
                self.goNextAction()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            self.startLogView?.removeFromSuperview() //移除
        }
    }
    
    //开始下一步操作,显示广告页
    func goNextAction() {
        
        //这里的逻辑是新版本需要，引导页加载完才出现广告
        if self.isNewVersion(false) == false {
            
            //开始加载广告页
            let view = AdvertisementView.loadAdsImage(superView: self.window!)
            self.advertisementView = view
            
            weak var weakSelf = self
            view.callback = {(isSuccess: Bool) in
                weakSelf?.startLogView?.removeFromSuperview() //移除
            }
            
            //点击广告视图回调(这个回调，必须从服务器链接获取正确才会回调)
            view.tapAdvertisementViewCallback = {
                (URLString: String,title: String) in
                weakSelf?.AdvertisementViewPushAction(URLString,title: title) //加载广告页
            }
            
        } else { //第一次安装,需要加载引导页
            self.guideViewAction()
        }
    }
    
    //视图消失与显示判断逻辑
    fileprivate func guideViewAction() -> () {
        
        if self.isNewVersion(true) == true { //第一次安装
            
            let leadView =  APPLeadView.displayAPPLeadView(self.startLogView!) //创建引导页
            
            leadView.tapCallback = { //引导页点击回调
                
                //开始加载广告页
                let view = AdvertisementView.loadAdsImage(superView: self.window!)
                self.advertisementView = view
                weak var weakSelf = self
                
                view.callback = {(isSuccess: Bool) in
                    weakSelf?.startLogView?.removeFromSuperview() //移除
                }
                
                //点击广告视图回调(这个回调，必须从服务器链接获取正确才会回调)
                view.tapAdvertisementViewCallback = {
                    (URLString: String,title: String) in
                    weakSelf?.AdvertisementViewPushAction(URLString,title: title) //加载广告页
                }
            }
            
        } else { //非第一次安装
            self.startLogView?.removeFromSuperview() //移除
        }
    }
    
    /**
     *  判断是否新版
     *  @param  isSave:true 保存，false不保存
     *  @returns: 返回true就是第一次安装
     */
    fileprivate func isNewVersion(_ isSave: Bool) -> Bool {
        let currentVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        if Defaults.object(forKey: "oldVersion") != nil {
            let oldVersion = Defaults.object(forKey: "oldVersion") as! String
            if currentVersion == oldVersion {
                return false
            } else {
                if isSave {
                    Defaults.set(currentVersion, forKey: "oldVersion")
                }
                return true
            }
        } else {
            if isSave {
                Defaults.set(currentVersion, forKey: "oldVersion")
            }
            return true
        }
    }

    //MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        if buttonIndex == 1 {
            
            let gestureUnlockViewController = GestureUnlockViewController()
            gestureUnlockViewController.createView()
            gestureUnlockViewController.state = GestureUnlockState.set
            
            gestureUnlockViewController.setSuc = {
                psw in
                Defaults.setValue(psw, forKeyPath: "GesturePassword")
                UserModel.shareInstance.isSetGestureUnlock = 1
                delegate.rootVC?.view.showTextHud("设置手势密码成功")
            }
            
            gestureUnlockViewController.transitorilyNotSet = {
                UserModel.shareInstance.isSetGestureUnlock = 0
            }
            
            delegate.rootVC?.present(gestureUnlockViewController, animated: true, completion: nil)
            
        } else {
            delegate.rootVC?.view.showLongTextHud("可以在我的信息-手势密码 中进行修改")
        }
    }
    
    //MARK: UpdateAlertViewDelegate
    func updateButtonAction(_ buttonIndex: Int, alertView: UpdateAlertView) {
        
        if buttonIndex == 0 || buttonIndex == 2 {
            // 嗷呜金服
            UIApplication.shared.openURL(URL(string:APP_URL)!)
        }
        
        if buttonIndex > 0 {
            alertView.delegate = nil
            alertView.removeFromSuperview()
            self.guideViewAction()
        }
    }
    
    //MARK: 最后登录时间更新
    func invokeServersFunction() -> () {
        
        if UserModel.shareInstance.invokeFunctionTime == nil { //程序第一次调用
            
            self.performFunction()
            
        } else { //非第一次调用
            let timer = NSDate().timeIntervalSince(UserModel.shareInstance.invokeFunctionTime! as Date)
            
            if timer > 24 * 60 * 60 { //表示已经超过一天了
                self.performFunction()
            }
        }
    }
    
    private func performFunction() -> () {
        AppLastLoginApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            UserModel.shareInstance.invokeFunctionTime = NSDate() //保存时间
            
        }) { (request:YTKBaseRequest!) in
            UserModel.shareInstance.invokeFunctionTime = NSDate() //保存时间
        }
    }
}
