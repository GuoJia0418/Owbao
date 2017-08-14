//
//  RegisterProtocolViewController.swift
//  Owbao
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RegisterProtocolViewController: BaseViewController,UIWebViewDelegate {

    var webView:UIWebView!
    var urlStr: String?
    var protocolName: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = protocolName
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        self.view.backgroundColor = UIColor.white
        webView.scalesPageToFit = true
        webView.delegate = self
        self.view.addSubview(webView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController!.navigationBar.hidden = false
        if (navigationController?.navigationBar.isHidden)! {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        view.showLoadingHud()
        
//        let urlStr =  PROTOCOL_URL + RegisterProtocol_Api
        webView.loadRequest(URLRequest(url: URL(string: urlStr!)!))

    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.view.hideHud()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.view.hideHud()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //        print("请求的请求是什么\(request.URL!)")
        
        return true
    }

}
