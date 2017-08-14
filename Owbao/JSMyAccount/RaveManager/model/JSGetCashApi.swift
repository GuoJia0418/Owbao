//
//  JSGetCashApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGetCashApi: BaseApi {

    var getCash_uid: Int = 0
    var getCash_amount: Double = 0.0
    var getCash_isChargeFlag: Int = 0
    
    init(uid: Int,amount: Double,isChargeFlag: Int) {
        super.init()
        
        self.getCash_uid = uid
        self.getCash_amount = amount
        self.getCash_isChargeFlag = isChargeFlag
    }
    
    override func requestUrl() -> String! {
        return GetCash_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": getCash_uid,"amount": "\(getCash_amount)","isChargeFlag": getCash_isChargeFlag]
    }
    
}
