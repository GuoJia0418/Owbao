//
//  MyBankCardMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyBankCardMapModel: NSObject {
    var bankCode:Int = 0
    var bankName:String?
    var bankNum:String?
    var idCards:String?
    var phone:String?
    var realName:String?
    var singleQuota:Double = 0.00
    var dayQuota:Double = 0.00
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
