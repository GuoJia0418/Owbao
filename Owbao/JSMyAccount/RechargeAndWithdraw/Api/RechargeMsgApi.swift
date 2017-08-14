//
//  RechargeMsg_Api.swift
//  Owbao
//
//  Created by lufeng on 16/3/14.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RechargeMsgApi: BaseApi {
    var uid: Int = 0
    var type: String = "1"
    init(Uid: Int,Type:String) {
        super.init()
        self.uid = Uid
        self.type = Type
    }
    override func requestUrl() -> String! {
        return RechargeMsg_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"type":type]
    }
}
