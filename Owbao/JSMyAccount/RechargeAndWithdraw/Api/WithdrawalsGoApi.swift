//
//  WithdrawalsGoApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class WithdrawalsGoApi: BaseApi {
    var amount: String?    
    var tpw:String?
    var uid:Int = 0
    var isChargeFlag:Int = 0
    var channel:Int = 1
    init(Uid: Int,Amount:String?,Tpw:String?,IsChargeFlage:Int) {
        super.init()
        uid = Uid
        amount = Amount
        tpw = Tpw
        isChargeFlag = IsChargeFlage
    }
    override func requestUrl() -> String! {
        return WithdrawalsGo_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"amount":amount!,"tpw":tpw!,"isChargeFlag":isChargeFlag,"channel":channel]
    }
}
