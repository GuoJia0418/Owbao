
//
//  JSSystemUpdateView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/11.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class JSSystemUpdateView: UIView {

    @IBOutlet weak var webView: UIWebView!

    //创建JSSystemUpdateView
    class func createSystemUpdateView(_ URLString: String) -> JSSystemUpdateView {
        
        let view = Bundle.main.loadNibNamed("JSSystemUpdateView", owner: self, options: nil)?.last as! JSSystemUpdateView
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.webView.loadRequest(URLRequest(url: URL(string: URLString)!))
        return view
    }
    
    @IBAction func leftBarbuttonAction(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
    
}
