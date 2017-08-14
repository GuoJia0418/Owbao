//
//  NavigationCotrollerPopExtension.swift
//  Test
//
//  Created by 一言难尽 on 2017/5/19.
//  Copyright © 2017年 一言难尽. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    //各种pop动作（注意：如果主动调用该方法，需要保证子控制器已经被RootNavigationController管理了）
    func popAction(_ animated: Bool,popController: UIViewController) {
        
        if popController.popType == .nomarl { //返回上一级控制器
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.nomarl)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            _ = self.popViewController(animated: animated)
            
        } else if popController.popType == .popToRoot { //回到根控制器
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.popToRoot)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            self.popToRootViewController(animated: animated) //去根控制器
            
        } else if popController.popType == .reloadApp {
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.reloadApp)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            RootNavigationController.reloadApp()       //刷新app
            
        } else if popController.popType == .investList {
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.investList)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            RootNavigationController.goToInvestList(controller: popController as! BaseViewController)  //去投资列表界面
            
        } else if popController.popType == .dismissGoHome {  //回到主界面
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.dismissGoHome)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            //先进行dismiss操作
            popController.dismiss(animated: animated, completion: nil)
            RootNavigationController.goToHomeController(controller: popController as! BaseViewController) //回到首页
            
        } else if popController.popType == .dismissInvestList {
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.dismissInvestList)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            //先进行dismiss操作
            popController.dismiss(animated: animated, completion: nil)
            RootNavigationController.goToInvestList(controller: popController as! BaseViewController) //回到列表
            
        } else if popController.popType == .dismiss {  //dismiss操作
            
            //操作之前进行回调
            if popController.popBeforeCallback != nil {
                popController.popBeforeCallback!(.dismiss)
            }
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
            
            popController.dismiss(animated: animated, completion: nil)
        }
        
        popController.popType = .nomarl;
    }
    
    //重新刷新app
    class func reloadApp() -> () {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let controller = RootTabBarController()
        delegate.rootVC = controller
        delegate.window?.rootViewController = controller
        delegate.window?.makeKeyAndVisible()
    }
    
    //去投资列表界面
    class func goToInvestList(controller: BaseViewController) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rootVC?.presentedViewController != nil { //表示当前有present的控制器，需要把先dimiss
            
            controller.dismiss(animated: false, completion: nil)
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 1
            delegate.rootVC!.tabBar.isHidden = false
            
        } else { //从正常界面push进来的
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 1
            delegate.rootVC!.tabBar.isHidden = false
        }
    }
    
    //去我的账户界面
    class func goToMyAccount(controller: BaseViewController) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rootVC?.presentedViewController != nil { //表示当前有present的控制器，需要把先dimiss
            
            controller.dismiss(animated: false, completion: nil)
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 3
            delegate.rootVC!.tabBar.isHidden = false
            
        } else { //从正常界面push进来的
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 3
            delegate.rootVC!.tabBar.isHidden = false
        }
    }
    
    //回到首页
    class func goToHomeController(controller: BaseViewController) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rootVC?.presentedViewController != nil { //表示先present
            
            controller.dismiss(animated: false, completion: nil)
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 0
            delegate.rootVC!.tabBar.isHidden = false
            
        } else { //从正常界面push进来的
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let nav: UINavigationController = delegate.rootVC!.viewControllers![delegate.rootVC!.selectedIndex] as! UINavigationController
            nav.popToRootViewController(animated: false)
            delegate.rootVC!.selectedIndex = 0
            delegate.rootVC!.tabBar.isHidden = false
        }
    }
    
    //设置导航栏红色，导航栏文字白色（返回按钮只能进行pop动作）
    func setRedNavigationBar(_ controller: UIViewController) -> () {
        //导航栏
        let navBar = self.navigationBar
        navBar.tintColor = UIColor.white
        navBar.setBackgroundImage(Common.image(with: UIColorFromRGB(255, green: 127, blue: 43)), for: UIBarMetrics.default) //UIImage(named: "common_background")
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName: UIColor.white] //白色的navigationBar
        navBar.shadowImage = UIImage()
    }
    
    //设置导航栏白色，导航栏文字深灰色（返回按钮只能进行pop动作）
    func setWhiteNavigationBar(_ controller: UIViewController) {
        //导航栏
        let navBar = self.navigationBar
        navBar.tintColor = UIColor.darkGray
        navBar.setBackgroundImage(Common.image(with: UIColor.white), for: UIBarMetrics.default)
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName: UIColor.darkGray] //白色的navigationBar
        navBar.shadowImage = Common.image(with: UIColorFromRGB(237, green: 237, blue: 237))
    }
    
    //以当前屏大小截图
    func captureScreen() -> UIImage {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let scale =  UIScreen.main.scale * 0.7 //截图缩放比例，越低越模糊
        
        UIGraphicsBeginImageContextWithOptions((delegate.window?.bounds.size)!, (delegate.window?.isOpaque)!, CGFloat(scale)) //获取当前手机像素比例
        let context = UIGraphicsGetCurrentContext()
        delegate.window?.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
