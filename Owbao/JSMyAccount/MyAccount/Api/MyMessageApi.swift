//
//  MyMessageApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyMessageApi: BaseApi {
    var uid: Int = 0
    var type :Int = 0
    var pageOn:Int = 0
    var pageSize:Int = 8
    init(Uid:Int,Type:Int,PageOn:Int)
    {
        super.init()
        uid = Uid
        type = Type
        pageOn = PageOn
    }
    
    override func requestUrl() -> String! {
        return MyMessage_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"type":type,"pageOn":pageOn,"pageSize":pageSize]
    }
}
