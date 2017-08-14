//
//  CompanyAndYanZiViewController.swift
//  Owbao
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class CompanyAndYanZiViewController: BaseViewController,UIWebViewDelegate {

    var webView: UIWebView!
    var pageID: Int = 0
    
    var uid: Int = 0 //用户uid
    var afid: Int = 0 //标id 
    var titleMoney:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createUI()
    }
    
    //创建UI
    func createUI()  {
        self.view.backgroundColor = UIColor.white
        switch pageID {
        case 0:
            self.navigationItem.title = "公司简介"
            break
        case 1:
            self.navigationItem.title = "一亿验资"
            break
        case 2:
            self.navigationItem.title = "安全保障"
            break
        case 3:
            self.navigationItem.title = titleMoney!
            break
            
        default:
            break
        }
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        webView.delegate = self
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (navigationController?.navigationBar.isHidden)! {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        var urlStr = ""
        switch pageID {
        case 0:
            urlStr = BASE_URL + CompanySituation_Api
            break
        case 1:
            urlStr = BASE_URL + YanZi_Api
            break
        case 2:
            urlStr = BASE_URL + MoreSecurity_Api
            break
        case 3:
            
//            url = NSURL(string:BASE_URL + GetMoneyDidSelected_Api + "?uid=\(uid)&afid=\(afid)")
            
            urlStr = BASE_URL + GetMoneyDidSelected_Api + "?uid=\(uid)&afid=\(afid)"
            print("输出web的urlStr = \(urlStr)")
            break
            
        default:
            break
        }
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
    
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.view.hideHud()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.view.hideHud()
    }

    /*
     MARK:WebviewDelegate
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.showLoadingHud()
    }

    //MARK: - 设置XIB
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    convenience  init() {
//        let nibNameOrNil = String?("CompanyAndYanZiViewController")
//        self.init(nibName: nibNameOrNil, bundle: nil)
//    }

}
