//
//  MyInvestApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyInvestApi: BaseApi {
    var uid: Int = 0
    var status:Int = 0
    var pageOn:Int = 0
    var pageSize:Int = 8
    init(Uid:Int,Status:Int,PageOn:Int)
    {
        super.init()
        uid = Uid
        status = Status
        pageOn = PageOn
    }
    
    override func requestUrl() -> String! {
        return MyInvest_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"status":status,"pageOn":pageOn,"pageSize":pageSize]
    }
}
