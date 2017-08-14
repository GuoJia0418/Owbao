//
//  RootNavigationController.swift
//  Owbao
//
//  Created by Panda on 16/5/20.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    var popDelegate: UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar.appearance()
        navBar.setBackgroundImage(Common.image(with: UIColorFromRGB(255, green: 127, blue: 43)), for: UIBarMetrics.default)
        
        // 去掉navBar的黑线
        navBar.shadowImage = Common.image(with: UIColorFromRGB(237, green: 237, blue: 237))
        
        // 设置 nav bar 的主题色 跟 标题的 颜色
        navBar.tintColor = UIColor.darkGray
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName: UIColor.darkGray]

        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
    }

    //重写push方法，添加一些默认属性，比如第二页隐藏tabbar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 && !self.navigationItem.hidesBackButton {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let controller = self.viewControllers.last
        
        if controller?.popType != .nomarl {
            self.popAction(true,popController: controller!) //开始进行pop
        }  else {
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
        }
        
        return super.popViewController(animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        //实现滑动返回功能
        //清空滑动返回手势的代理就能实现
        if viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        } else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
    }
    
}
