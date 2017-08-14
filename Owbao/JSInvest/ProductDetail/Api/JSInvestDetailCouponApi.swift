//
//  JSInvestDetailCouponApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/28.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestDetailCouponApi: BaseApi {
    var amount: Double = 0.0
    var pid: Int = 0
    var uid: Int = 0
    
    init(Uid: Int,Pid: Int,Amount: Double) {
        super.init()
        uid = Uid
        pid = Pid
        amount = Amount
    }
    
    override func requestUrl() -> String! {
        return JSInvestDetailCoupon_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pid": pid,"amount": amount]
    }
    
}
