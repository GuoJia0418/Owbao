//
//  GetAddressApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetAddressApi: BaseApi {
    
    var uid: Int = 0
    var prizeType = 1     //1.50话费虚拟投即送 2、实物类型的投即送
    var investId: Int = 0
    
    init(Uid: Int,PrizeType: Int) {
        super.init()
        uid = Uid
        prizeType = PrizeType
    }
    
    override func requestUrl() -> String! {
        return GetAddress_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"prizeType": prizeType]
    }
}



