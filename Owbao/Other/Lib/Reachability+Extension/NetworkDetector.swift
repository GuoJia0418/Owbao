//
//  NetworkCheck.swift
//  wangluocuowuchuli
//
//  Created by Yan on 15/11/5.
//  Copyright © 2015年 xiaoyan. All rights reserved.
//

import UIKit

class NetworkDetector: NSObject {
    var reach: Reachability?
    var status: NetworkStatus?
    let TEST_URL = "www.baidu.com"
    var isLinkNetwork: Bool {
        return (status!.rawValue != 0)
    }
    static let sharedInstance = NetworkDetector()
    
    override init() {
        super.init()
        setupReach()
    }
    func setupReach() {
        reach = Reachability.forInternetConnection()
//        reach!.reachableOnWWAN = false
        // // 在通知中心注册联网状态监测
        NotificationCenter.default.addObserver(self,
            selector: #selector(NetworkDetector.reachabilityChanged(_:)),
            name: NSNotification.Name.reachabilityChanged,
            object: nil)
        status = reach!.currentReachabilityStatus()
        // 启动监听
        self.reach!.startNotifier()
    }
    func reachabilityChanged(_ notification: Notification) {
        
        
//        if self.reach!.isReachableViaWÔiFi() || self.reach!.isReachableViaWWAN() {
//            print("Service avalaible!!!")
//        } else {
//            NetworkIndicator().show("網絡中斷連接，請檢查您的網絡設置")
//            print("No service avalaible!!!")
//        }
 
        switch reach!.currentReachabilityStatus() {
        case NetworkStatus.NotReachable:
//             NetworkIndicator().show("当前网络中断连接")
            status = .NotReachable
        case NetworkStatus.ReachableViaWWAN:
            status = .ReachableViaWWAN
        case NetworkStatus.ReachableViaWiFi:
             NetworkIndicator().show("当前网络处于wifi环境")
            status = .ReachableViaWiFi
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// 網絡指示器
class NetworkIndicator: NSObject {
    lazy var window: UIWindow = UIApplication.shared.keyWindow!
    //
    func show(_ message: String?) {
        
        let height: CGFloat = 35
        let rect = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        
        promptLB.text = message
        promptLB.frame = rect
        
        UIView.animate(withDuration: 1.2, animations: {
            self.promptLB.alpha = 1
            self.promptLB.frame = rect.offsetBy(dx: 0, dy: height + 20)
            
            }, completion: { (_) -> Void in
                
                UIView.animate(withDuration: 1.2, animations: { () -> Void in
                    self.promptLB.frame = rect
                    }, completion: { (Bool) -> Void in
                        self.dismiss()
                })
        }) 
        
    }
    func dismiss() {
        promptLB.removeFromSuperview()
    }
    // MARK: - 提示 文字
    fileprivate lazy var promptLB: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 16) //[UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
        lb.backgroundColor = UIColor(red: 0.35 , green: 0.35 , blue: 0.35 , alpha: 1.0)
        lb.textAlignment = NSTextAlignment.center
        lb.alpha = 0
        self.window.addSubview(lb)
        
        return lb
        }()

    override init() {
        super.init()
        
    }
}

