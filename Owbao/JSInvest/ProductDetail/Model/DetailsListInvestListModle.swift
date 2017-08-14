//
//  DetailsListInvestListModle.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class DetailsListInvestListModle: NSObject {
    var amount: Double = 0.00      //投资金额
    var realName: String = ""       //名称
    var investTime: Double = 0.00   //投资时间
    var mobilephone: String? = ""    //手机号
    var sex: Int = 0
    var idCards: String? = ""        //身份证号
    var joinType: Int = 0            // 0=PC,1=IOS,2=android,3=微信
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
