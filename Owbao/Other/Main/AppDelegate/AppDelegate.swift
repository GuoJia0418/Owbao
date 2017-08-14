//
//  AppDelegate.swift
//  Owbao
//
//  Created by lufeng on 16/2/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate,WXApiDelegate {
    
    var window: UIWindow?                           //显示的window
    var rootVC: RootTabBarController?             //根管理器
    var updateViewCtrl: SystemUpdateViewController? //系统维护控制器
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.applicationIconBadgeNumber = 0
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.rootVC = RootTabBarController()
        self.window?.rootViewController = self.rootVC
        self.window?.makeKeyAndVisible()
        
        //设置网络框架
        configureFunction()
        
        //程序启动配置各种view(引导页、广告等等)
        APPStartManager.appStartConfigure(window!)
        
        //服务器需要客户端的时间(1天调用一次)
        APPStartManager.manager.invokeServersFunction()
        
        PushManager.share().registerUMPushManager(launchOptions, umPushKey: UMENG_KEY)
        
        //判断是否是通过推送进入程序 并进行处理
        let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if userInfo != nil {
            PushManager.share().handleRemoteNotification(userInfo as! [AnyHashable : Any])
        }
        
        return true
    }
    
    func configureFunction() {
        //向微信注册  嗷呜金服
        WXApi.registerApp(WX_KEY)
        
        //网络的框架
        let config = YTKNetworkConfig.sharedInstance()
        config?.baseUrl = BASE_URL
        
        //友盟  嗷呜金服
        let UMConfigInstance = UMAnalyticsConfig.sharedInstance()
        UMConfigInstance?.appKey = UMENG_KEY
        UMConfigInstance?.channelId = "iOS"
        MobClick.setAppVersion(SYSTEM_VERSION)
//        MobClick.start(withConfigure: UMConfigInstance)
    }

    //MARK:WXApiDelegate
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return  WXApi.handleOpen(url, delegate: PD_Share.shareInstance()) || QQApiInterface.handleOpen(url, delegate: QQShareManager.default())
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
           print(url)
        
        return WXApi.handleOpen(url, delegate: PD_Share.shareInstance()) || QQApiInterface.handleOpen(url, delegate: QQShareManager.default())
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        UMessage.registerDeviceToken(deviceToken)
        
        //获取到deviceToken
        let nsdataStr = NSData.init(data: deviceToken)
        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        	
        PushManager.share().deviceToken = datastr
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        PushManager.share().handleRemoteNotification(userInfo)
    }

    //收到本地通知
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
         APPStartManager.manager.resignDate = Date()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WEBPOST"), object: nil)
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        APPStartManager.manager.configureGestureUnlock()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

