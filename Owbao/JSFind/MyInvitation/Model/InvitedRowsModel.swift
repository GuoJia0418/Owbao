//
//  InvitedRowsModel.swift
//  Owbao
//
//  Created by GuoJia on 16/11/25.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedRowsModel: NSObject {
    var isInvest: String?       //是否投资,需要转码
    var mobilePhone: String?   //手机号码
    var realName: String?     //真实姓名,需要转码
    var regTime: String?      //注册时间
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
