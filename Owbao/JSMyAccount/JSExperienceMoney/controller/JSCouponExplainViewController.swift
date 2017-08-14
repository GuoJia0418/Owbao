//
//  JSCouponExplainViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/29.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSCouponExplainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券温馨提示"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSCouponExplainViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
