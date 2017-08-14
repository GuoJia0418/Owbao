//
//  JSLotaryApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/25.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLotaryApi: BaseApi {

    var uid:Int = 0
    init(Uid:Int)
    {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return FlopShare_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }

    
}
