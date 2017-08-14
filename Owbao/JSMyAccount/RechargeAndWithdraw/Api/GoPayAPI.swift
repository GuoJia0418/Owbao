//
//  GoPayAPI.swift
//  Owbao
//
//  Created by Panda on 16/5/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class GoPayAPI: BaseApi {
    var payNum:String?
    var smsCode:String?
    var uid:Int = 0
    init(Uid:Int,PayNum:String?,SmsCode:String) {
        super.init()
        uid = Uid
        payNum = PayNum
        smsCode = SmsCode
    }
    
    override func requestUrl() -> String! {
        return GoPay
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid":uid,"payNum":payNum!, "smsCode":smsCode!]
    }
}
