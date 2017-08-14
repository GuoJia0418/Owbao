//
//  BaseViewController.swift
//  Owbao
//
//  Created by mac on 16/2/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var errorView: NetworkErrorView!
    var isShowLeftItem: Bool = true //默认是显示
    var loadingCount: Int = 0       //请求服务器的次数，默认是0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(popActionWillExecute), name: NSNotification.Name(rawValue: popActionBeforPostNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !NetworkDetector.sharedInstance.isLinkNetwork {
            NetworkIndicator().show("网络中断链接，请检查您的网络设置")
        }
        self.setNavigationBarBarButtonItem() //设置左边返回按钮和导航栏颜色
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //切换界面将要被执行
    func popActionWillExecute() {
        
    }
    
    //************************* 新增方法 *****************//
    func setNavigationBarBarButtonItem() {
        
        //显示左返回按钮
        if self.self.isShowLeftItem == true {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_arrows"), style: .plain, target: self, action: nil)
        } else { //隐藏返回按钮
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.backBarButtonItem = nil
        }
        
        //判断navigationBar显示颜色
        let navController = self.navigationController as? RootNavigationController
        
        if self.barType == .red {
            
            //重新设置颜色
            if self.navigationItem.leftBarButtonItem != nil {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_arrows"), style: .plain, target: self, action: #selector(leftBarButtonItemAction))
            }
            
            navController?.setRedNavigationBar(self)
            
        } else if self.barType == .white {
            
            //重新设置颜色
            if self.navigationItem.leftBarButtonItem != nil {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "返回.png"), style: .plain, target: self, action: #selector(leftBarButtonItemAction))
            }
            
            navController?.setWhiteNavigationBar(self)
        }
    }
    
    //点击事件
    func leftBarButtonItemAction() -> () {
        let navController = self.navigationController as? RootNavigationController
        navController?.popAction(true,popController: self)
    }
    
    //************************* 旧的方法 *****************//
    func loadData() {
        
    }
    
    // 獲取数据成功后的結果
    func hideErrorView() {
        // 如果有网的时候，删除掉，所有的 NetworkErrorView（无网络处理视图）
        for subView  in view.subviews {
            if subView.classForCoder == NetworkErrorView.classForCoder() {
                subView.removeFromSuperview()
            }
        }
    }
    
    // 获取数据失败的处理操作
    func loadDataError() {
        //没有网络的时候添加 无网络视图 --- NetworkErrorView
        self.errorView = Bundle.main.loadNibNamed("NetworkErrorView", owner: nil, options: nil)!.first as!  NetworkErrorView
        self.errorView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadData)))
        self.errorView.backgroundColor = DEFAULT_GRAYCOLOR
        self.view.addSubview(self.errorView)
    }
    
    //第一次请求显示的loading界面
    func loadFirstLoadingView() {
        let loadingView = Bundle.main.loadNibNamed("JSLodingView", owner: nil, options: nil)!.first as!  JSLodingView
        loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        loadingView.backgroundColor = DEFAULT_GRAYCOLOR
        loadingView.indicatorView.startAnimating()
        self.view.addSubview(loadingView)
    }
    
    //隐藏第一次请求的loading界面
    func hideFristLoadingView() {
        
        for view in self.view.subviews {
            
            if view.isKind(of: JSLodingView.classForCoder()) {
                view.removeFromSuperview()
            }
        }
    }
    
    //获取数据失败的处理操作
    func loadDataErrorWithErrorString(_ errorString: String?) {
        //没有网络的时候添加 无网络视图 --- NetworkErrorView
        self.errorView = Bundle.main.loadNibNamed("NetworkErrorView", owner: nil, options: nil)!.first as!  NetworkErrorView
        self.errorView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadData)))
        self.errorView.backgroundColor = DEFAULT_GRAYCOLOR
        self.view.addSubview(self.errorView)
        
        if errorString != nil && errorString != "" {
            self.errorView.errInoLB.text = errorString
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
