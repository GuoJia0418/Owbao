//
//  IsExistPhoneApi.swift
//  hyq2.0
//
//  Created by iOS on 15/6/3.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class IsExistPhoneApi: BaseApi {
    var mobilephone: String?
    init(phoneNo: String) {
        super.init()
        mobilephone = phoneNo
    }
    override func requestUrl() -> String! {
        return VERIFY_PHONE_EXISIT_API
    }
    override func untreatedArgument() -> Any! {
        return ["mobilephone": mobilephone!]
    }
}
