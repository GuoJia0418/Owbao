//
//  GetActivityFriendAllApi.swift
//  Owbao
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetActivityFriendAllApi: BaseApi {

    var uid:Int = 0
    var status: Int = 0
    var pageOn:Int = 0
    var pageSize:Int = 3
    
    var apiType:Int = 0
    
    init(Uid:Int,Status:Int,PageOn: Int,ApiType:Int)
    {
        super.init()
        uid = Uid
        status = Status
        pageOn = PageOn
        apiType = ApiType
    }
    
    override func requestUrl() -> String! {
        return GetActivityAll_Api
 
    }
    
    override func untreatedArgument() -> Any! {
        if status == 0
        {
            return ["uid": uid,"pageOn":pageOn,"pageSize":pageSize]
        }
        else
        {
            return ["uid": uid,"status":status,"pageOn":pageOn,"pageSize":pageSize]
        }

    }

}
