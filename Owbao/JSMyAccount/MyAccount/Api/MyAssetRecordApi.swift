//
//  MyAssetRecordApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAssetRecordApi: BaseApi {
    var uid: Int = 0
    var pageOn:Int = 0
    var pageSize: Int = 16
    var tradeType:Int = 0
    
    init(Uid:Int,PageOn:Int,TradeType:Int)
    {
        super.init()
        uid = Uid
        pageOn = PageOn
        tradeType = TradeType
    }
    
    override func requestUrl() -> String! {
        return MyAssetRecord_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pageOn":pageOn,"pageSize":pageSize,"tradeType":tradeType]
    }
}
