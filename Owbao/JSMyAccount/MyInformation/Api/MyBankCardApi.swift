//
//  MyBankCardApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyBankCardApi: BaseApi {
    var uid: Int = 0
    init(Uid:Int)
    {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return MyBankCard_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}
