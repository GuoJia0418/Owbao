//
//  InvitedApi.swift
//  Owbao
//
//  Created by GuoJia on 16/11/25.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//  我的邀请

import UIKit

class InvitedApi: BaseApi {
    var uid:Int = 0
    var pageSize:Int = 10
    var pageOn:Int = 1
    
    init(Uid:Int,PageOn:Int) {
        super.init()
        uid = Uid
        pageOn = PageOn
    }
    
    override func requestUrl() -> String! {
        return Invited_api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pageOn":pageOn,"pageSize":10]
    }
}
