//
//  RegisterApi.swift
//  hyq2.0
//
//  Created by iOS on 15/10/10.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class RegisterApi: BaseApi {
    var mobilephone: String? // 手机号
    var passWord: String? // 密码
    var password1: String? // 确认密码
    var smsCode: String?// 手机验证码
    var recommPhone: String?// 推荐码
    var checkbox: String? // 协议是否勾选（1为选中，0为未选中）
    var toFrom: String?// toFrom
    
    init(mobilephone: String,  passWord: String,  smsCode: String ,recommPhone:String, toFrom:String) {
        super.init()
        self.mobilephone = mobilephone
        self.passWord = passWord
        self.smsCode = smsCode
        self.recommPhone = recommPhone
        self.toFrom = toFrom
    }
    
    override func requestUrl() -> String! {
        return REGISTER_API
    }
    
    override func untreatedArgument() -> Any! {
        if self.recommPhone?.characters.count == 0 {
            return ["mobilephone":mobilephone!,"passWord":passWord!,"smsCode":smsCode!, "toFrom":toFrom!]
        }
        return ["mobilephone":mobilephone!,"passWord":passWord!,"smsCode":smsCode!,"recommPhone":recommPhone!, "toFrom":toFrom!]
    }
}
