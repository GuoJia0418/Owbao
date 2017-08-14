//
//  JSMyAccountSettingViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyAccountSettingViewController: BaseViewController {
    @IBOutlet weak var pushLabel: UILabel!      //消息推送
    @IBOutlet weak var clearCacheLabel: UILabel!    //本地缓存
    @IBOutlet weak var versionLabel: UILabel!   //当前版本
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let IOS8 = ((UIDevice.current.systemVersion as NSString).doubleValue >= 8.0) ? true : false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        clearCacheLabel.text = self.readCacheSize() as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        self.setPushLabel()
        versionLabel.text = "\(SYSTEM_VERSION)"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    //MARK: - 推送消息设置
    @IBAction func pushClick(_ sender: UIButton) {
        
        //prefs:root=NOTIFICATIONS_ID
        
        if IOS8
        {
            if UIApplication.shared.isRegisteredForRemoteNotifications != true
            {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }
        else
        {
            if UIApplication.shared.enabledRemoteNotificationTypes() == UIRemoteNotificationType()
            {
               UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }

    }
    
    //MARK: - 设置push
    func setPushLabel()
    {
        if IOS8
        {
            if UIApplication.shared.isRegisteredForRemoteNotifications == true
            {
                pushLabel.text = "已开启"
            }
            else
            {
                pushLabel.text = "未开启"
            }
        }
        else
        {
            if UIApplication.shared.enabledRemoteNotificationTypes() == UIRemoteNotificationType()
            {
                pushLabel.text = "未开启"
            }
            else
            {
                pushLabel.text = "已开启"
            }
        }

    }
    
    
    //MARK: - 清除本地缓存
    @IBAction func clearCache(_ sender: UIButton) {
        let alertView: UIAlertController = UIAlertController(title: "提示", message: "您确定要清除所有缓存数据吗?", preferredStyle: UIAlertControllerStyle.alert)
        let alertViewAction: UIAlertAction = UIAlertAction.init(title: "清除", style: UIAlertActionStyle.destructive) { (UIAlertAction) in
            self.activityIndicator.startAnimating()
            
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: basePath!)
            {
                let childrenPath = fileManager.subpaths(atPath: basePath!)
                for childPath in childrenPath! {
                    let cachePath = ((basePath)! + "/") + childPath
                    do {
                        try fileManager.removeItem(atPath: cachePath)
                        if childPath == childrenPath?.last{
                           self.view.showTextHud("清除完毕")
                        }
                        
                        } catch  {
                        
                    }
                }
            }
//            if (self.readCacheSize() as String) == "0.00 MB"
//            {
//                self.view.showTextHud("清除完毕")
//            }
            self.clearCacheLabel.text = self.readCacheSize() as String
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.view.showTextHud("清除完毕")
        }
//        alertViewAction.setValue(DEFAULT_REDCOLOR, forKey: "_titleTextColor")
        
        let alertViewCancelAction:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
//        alertViewCancelAction.setValue(DEFAULT_DARKGRAYCOLOR, forKey: "_titleTextColor")
        
        alertView.addAction(alertViewAction)
        alertView.addAction(alertViewCancelAction)
        self.present(alertView, animated:true , completion: nil)
    }
    
    //MARK: - 退出登录
    @IBAction func loginOutClick(_ sender: UIButton) {
        self.showAlertController()
    }
    
    func showAlertController()
    {
        let alertView: UIAlertController = UIAlertController(title: "是否确定退出?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let alertViewAction: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) in
            
            UserModel.shareInstance.logout()
            self.view.showTextHud("退出成功")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginOutInvest"), object: "nil")
            
            delay(1, block: { () -> () in
                RootNavigationController.goToHomeController(controller: self)
            })
            
        }
//        alertViewAction.setValue(DEFAULT_REDCOLOR, forKey: "_titleTextColor")
        
        let alertViewCancelAction:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
//        alertViewCancelAction.setValue(DEFAULT_DARKGRAYCOLOR, forKey: "_titleTextColor")
        
        alertView.addAction(alertViewAction)
        alertView.addAction(alertViewCancelAction)
        self.present(alertView, animated:true , completion: nil)
    }
    
    //MARK: - 缓存文件的获取
    func readCacheSize()->String
    {
        //取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
        print("总的文件路径cachePath = \(cachePath)")
        let fileManager = FileManager.default
        var big: UInt64 = UInt64(0.0)
        if fileManager.fileExists(atPath: cachePath!)
        {
            var fileSize : UInt64
            let childrenPath = fileManager.subpaths(atPath: cachePath!)
            if childrenPath != nil
            {
//                print("childrenPath文件路径 = \(childrenPath)")
                for path in childrenPath! {
                    let childPath = (cachePath! + "/") + path
//                    print("childPath文件路径 = \(childPath)")
                    do {
                        
                        let attr = try FileManager.default.attributesOfItem(atPath: childPath)
                        fileSize = attr[FileAttributeKey.size] as! UInt64
                        //if you convert to NSDictionary, you can get file size old way as well.
                        let dict = attr as NSDictionary
                        fileSize = dict.fileSize()
                        big += fileSize
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        print("big == \(big)")
        return self.covertToFileString(with: big)
//        return NSString(format: "%.2f MB", Double(big) / 1024.0 / 1024.0) as String as NSString
    }
    
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        print("covertToFileString输出的数据是\(convertedValue)")
        var multiplyFactor = 0
        let tokens = ["KB", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        
        while convertedValue > 1024
        {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        if multiplyFactor == 0
        {
            convertedValue = 0
        }

        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
    //MARK: - UIAlertViewDelegate
    func showAlertView()
    {
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "是否确定退出?"
        alertView.addButton(withTitle: "取消")
        alertView.addButton(withTitle: "确定")
        alertView.show()
        
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            UserModel.shareInstance.logout()
            self.view.showTextHud("退出成功")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginOutInvest"), object: "nil")
            
            delay(1, block: { () -> () in
                RootNavigationController.goToHomeController(controller: self)
            })
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
        let nibNameOrNil = String?("JSMyAccountSettingViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }


}
