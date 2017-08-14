//
//  JYPassWordApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/15.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class JYPassWordApi: BaseApi {
    var tpwd: String?
    var smsCode: String?
    var uid: Int = 0

    init(Tpwd: String,SmsCode: String,Uid: Int) {
        super.init()
        tpwd = Tpwd
        smsCode = SmsCode
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return JYPassWord_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["tpwd":tpwd!,"smsCode":smsCode!,"uid":uid]
    }
}
