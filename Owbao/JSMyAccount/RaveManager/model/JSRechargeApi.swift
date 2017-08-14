//
//  JSRechargeViewModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSRechargeApi: BaseApi {
    
    var rechargeUid: Int = 0
    var rechargeYzm: String = ""
    var rechargeBank_mobile: String = ""
    var amount: String = ""
    var order: String = ""
    
    init(uid: Int,
         yzm: String,
         bank_mobile: String,Amount: String,Order: String) {
        
        super.init()
        
        self.rechargeUid = uid
        self.rechargeYzm = yzm
        self.rechargeBank_mobile = bank_mobile
        self.amount = Amount
        self.order = Order
    }
    
    override func requestUrl() -> String! {
        return Rcharge_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": rechargeUid,"yzm": rechargeYzm,"bank_mobile": rechargeBank_mobile,"amt":amount,"order":order]
    }
}
