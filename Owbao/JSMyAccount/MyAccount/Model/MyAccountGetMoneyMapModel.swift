//
//  MyAccountGetMoneyMapModel.swift
//  Owbao
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class MyAccountGetMoneyMapModel: NSObject {

    var amount: Double = 0.00  //本次成功领取金额
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
   
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
