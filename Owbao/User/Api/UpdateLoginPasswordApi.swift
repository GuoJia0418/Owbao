//
//  UpdateLoginPasswordApi.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UpdateLoginPasswordApi: BaseApi {
    var uid: Int = 0
    var pwd: String?
    var smsCode: String?
    var mobilephone:String?
    init(uid: Int, pwd: String, smsCode: String,Mobilephone:String) {
        super.init()
        self.uid = uid
        self.smsCode = smsCode //短信验证码
        self.pwd = pwd   //交易密码
        self.mobilephone = Mobilephone
    }
    override func requestUrl() -> String! {
        return UPDATE_LOGIN_PASSWORD_API
    }
    override func untreatedArgument() -> Any! {
        if uid == 0 {
            return ["smsCode": smsCode!, "pwd": pwd!,"mobilephone":mobilephone!]
        }else{
            return ["uid": uid, "smsCode": smsCode!, "pwd": pwd!]
        }
    }
}
