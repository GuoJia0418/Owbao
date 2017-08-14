//
//  SendRechargeSmsAPI.swift
//  Owbao
//
//  Created by Panda on 16/5/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class SendRechargeSmsAPI: BaseApi {
    var type:String?
    var payNum:String?
    var uid:Int = 0
    init(Uid:Int,PayNum:String?,Type:String) {
        super.init()
        uid = Uid
        payNum = PayNum
        type = Type
    }
    
    override func requestUrl() -> String! {
        return SendRechargeSms_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid":uid,"payNum":payNum!,"type":type!]
    }
}
