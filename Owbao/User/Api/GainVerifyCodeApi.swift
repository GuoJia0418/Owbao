//
//  GainVerifyCodeApi.swift
//  hyq2.0
//
//  Created by iOS on 15/10/12.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class GainVerifyCodeApi: BaseApi {
    var mobilephone: String?
    var type:String?
    var time:String? = ""
    
    init(mobilephone: String,type:String,Time:String) {
        super.init()
        self.mobilephone = mobilephone
        self.type = type
        self.time = Time
    }
    override func requestUrl() -> String! {
        return GAIN_VERIFY_CODE_API
    }
    override func untreatedArgument() -> Any! {
        return ["mobilephone": mobilephone!,"type":type!,"time":time!]
    }
}
