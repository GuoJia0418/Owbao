//
//  HomeApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class HomeApi: BaseApi {
   
    var uid:Int = 0
    init(Uid:Int)
    {
        super.init()
        uid = Uid
    }
   
    override func requestUrl() -> String! {
        return Home_Api
    }
    override func untreatedArgument() -> Any! {
        if uid == 0 {
            return [:]
        }
        return ["uid": uid]
    }
}
