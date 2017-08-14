//
//  CreatePayOrderAPI.swift
//  Owbao
//
//  Created by Panda on 16/5/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class CreatePayOrderAPI: BaseApi {
    var uid: Int = 0
    var amount:String?
    init(Uid:Int,Amount:String?) {
        super.init()
        uid = Uid
        amount = Amount
    }
    
    override func requestUrl() -> String! {
        return CreatePayOrder_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid":uid,"amount":amount!]
    }
}
