//
//  RechargeGoApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RechargeGoApi: BaseApi {
    var amount: Double = 0.00
    var tpw:String?
    var uid:Int = 0
    var channel:Int = 1
    init(Uid: Int,Amount:Double,Tpw:String?) {
        super.init()
        uid = Uid
        amount = Amount
        tpw = Tpw
    }
    override func requestUrl() -> String! {
        return RechargeGo_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"amount":amount,"smsCode":tpw!,"channel":channel]
    }
}
