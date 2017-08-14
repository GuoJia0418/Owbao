//
//  JSOfflineActivityApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOfflineActivityApi: BaseApi {

    var pageOn: Int = 0
    var pageSize: Int = 10
    
    init(PageOn: Int) {
        super.init()
        pageOn = PageOn
    }
    
    override func requestUrl() -> String! {
        return OfflineActivity_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["pageOn": pageOn,"pageSize": pageSize]
    }
}
