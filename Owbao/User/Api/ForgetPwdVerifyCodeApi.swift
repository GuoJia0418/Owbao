//
//  ForgetPwdVerifyCodeApi.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ForgetPwdVerifyCodeApi: BaseApi {
    var uid: Int = 0
    var type:String = "1"
    init(uid: Int,type:String) {
        super.init()
        self.uid = uid
        self.type = type
    }
    override func requestUrl() -> String! {
        return FORGET_PWD_VERIFY_CODE_API
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"type":type]
    }
}
