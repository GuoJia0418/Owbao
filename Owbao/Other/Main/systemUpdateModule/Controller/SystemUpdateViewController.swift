//
//  SystemUpdateViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/27.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class SystemUpdateViewController: BaseViewController,UIWebViewDelegate {
    @IBOutlet weak var systemWebView: UIWebView!
    var webLink: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemWebView.delegate = self
        systemWebView.scalesPageToFit = true
        
        if webLink != "" {
            systemWebView.loadRequest(URLRequest(url: URL(string: webLink!)!))
        } else {
            systemWebView.loadRequest(URLRequest(url: URL(string: BASE_URL + XTWH_Api)!))
        }
    }

    //MARK: - WebviewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideHud()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.view.hideHud()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.showLoadingHud()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //创建系统维护页并弹出，errorCode为XTWH，才会弹出系统维护界面
    class func presentSystemUpdateController(_ URLString: String) -> () {
        
        let controller = SystemUpdateViewController()
        controller.webLink = URLString
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var superController: UIViewController = appDelegate.rootVC! as UIViewController
        
        if ((appDelegate.rootVC?.presentingViewController) != nil) {
            
            superController = (appDelegate.rootVC?.presentingViewController)! //取出弹出self的控制器
            
        } else if((appDelegate.rootVC?.presentedViewController) != nil) {
            
            superController = (appDelegate.rootVC?.presentedViewController)! //取出被self弹出的控制器
        }
        
        if appDelegate.updateViewCtrl == nil {
            superController.present(controller, animated: true, completion: nil)
            appDelegate.updateViewCtrl = controller
        }        
    }
    
    @IBAction func leftAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateViewCtrl = nil
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("SystemUpdateViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
