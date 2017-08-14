//
//  JSProductActivityBannerApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/17.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProductActivityBannerApi: BaseApi {

    var uid: Int = 0
    
    init(Uid: Int) {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return JSInvetProductActivity_APi
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}
