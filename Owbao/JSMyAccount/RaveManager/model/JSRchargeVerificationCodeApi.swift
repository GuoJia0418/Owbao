//
//  JSRchargeVerificationCodeApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSRchargeVerificationCodeApi: BaseApi {
    
    var verificationCodeUid: Int = 0
    var verificationCodeAmount: String = ""
    var verificationCodeBank_mobile: String = ""
    
    init(uid: Int,
         amount: String,
         bank_mobile: String) {
        
        super.init()
        self.verificationCodeUid = uid
        self.verificationCodeAmount = amount
        self.verificationCodeBank_mobile = bank_mobile
    }
    
    override func requestUrl() -> String! {
        return RchargeVerification_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": verificationCodeUid,"amt": verificationCodeAmount,"bank_mobile": verificationCodeBank_mobile]
    }
}
