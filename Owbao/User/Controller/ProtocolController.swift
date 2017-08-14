//
//  ProtocolController.swift
//  Owbao
//
//  Created by lufeng on 16/3/21.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProtocolController: BaseViewController,UIWebViewDelegate {
    var Open:Bool = false
    var url:URL?
    var model:MyInvestRowsModel?
    var agreementType:Int = 0       //协议类型
    var isShowEntrustAgreement:Bool?    = false //是否显示委托协议
    var progress: UIProgressView?
    var isAnimation: Bool = false
    
    @IBOutlet weak var webview: UIWebView!
    var protocolName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.scalesPageToFit = true
        webview.delegate = self
        navigationItem.title = "\((protocolName)!)"

        loadProtocol(protocolName)
    }

    //MARK: - createView
//    func createView()
//    {
//        //进度条
//        let progress = UIProgressView()
//        progress.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2)
//        progress.progressTintColor = DEFAULT_REDCOLOR
//        progress.progressViewStyle = .default
//        progress.trackTintColor = UIColor.white
//        self.view.addSubview(progress)
//        self.progress = progress
//        
//        //添加观察者
//        self.webview.addObserver(self, forKeyPath: "estimatedProtocolProgress", options: [.new,.old], context: nil)
//        
//    }
    
//    deinit {
////        self.webview.removeObserver(self, forKeyPath: "estimatedProtocolProgress")
////        self.webview.navigationDelegate = nil
//    }
    
    //观察回调
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        if keyPath == "estimatedProgress" {
//            
//            self.progress?.alpha = 1.0
//            self.progress?.setProgress(Float(self.web.estimatedProgress), animated: true)
//            
//            if self.web.estimatedProgress >= 1.0 {
//                
//                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
//                    self.progress?.alpha = 0
//                }, completion: { (complete) in
//                    if complete {
//                        self.progress?.setProgress(0, animated: false)
//                    }
//                })
//            }
//        }
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController!.navigationBar.hidden = false
        if (navigationController?.navigationBar.isHidden)! {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }


    func loadProtocol(_ fileName: String?)
    {
        if Open == true
        {
            if model != nil
            {
                if model?.sid == 0
                {
                    url = URL(string:PROTOCOL_URL + LoanProtocol_Api + "?pid=\(model!.pid)&uid=\(model!.uid)&investId=\(model!.id)")
                }
                else
                {
                    if model?.prePid == 0
                    {
                        //借款
                        url = URL(string:PROTOCOL_URL + LoanProtocol_Api + "?pid=\(model!.pid)&uid=\(model!.uid)&investId=\(model!.id)")
                    }
                    else
                    {

                        url = URL(string:PROTOCOL_URL + LoanProtocol_Api + "?pid=\(model!.pid)&uid=\(model!.uid)&investId=\(model!.id)")
                        // 转让
//                        url = NSURL(string:"http://www.duorongcf.com/mytransfer?uid=\(model!.uid)&pid=\(model!.pid)&investId=\(model!.id)")
                        
                    }
                }
                
            }
            else
            {
                if agreementType == 1 {
                    url = URL(string: PROTOCOL_URL + LoanProtocol_Api)
                    
                }
                else if agreementType == 3
                {
                    url = URL(string: PROTOCOL_URL + AuthenticationInformation_Api)
                }
            }
        }
        else if isShowEntrustAgreement == true
        {
            //显示“认证支付协议”
//            url = NSURL(string:"http://www.duorongcf.com/entrust")
        
        }
        else
        {
            let filePath = Bundle.main.path(forResource: protocolName!, ofType: "pdf")
            url = URL(fileURLWithPath: filePath!)
        }
        print("打印一下url = \(url)")
        let request = URLRequest(url: url!)
        webview.loadRequest(request)
        self.view.hideHud()
    }
   
    /*
     MARK:WebviewDelegate
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.showLoadingHud()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideHud()
    }

//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        
//        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
//            self.progress?.alpha = 0
//        }, completion: { (complete) in
//            
//            if complete {
//                self.progress?.setProgress(0, animated: false)
//            }
//        })
//    }
    
    //MARK: - init 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience  init() {
        let nibNameOrNil = String?("ProtocolController")
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
}
