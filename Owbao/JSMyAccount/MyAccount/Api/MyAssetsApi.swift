//
//  MyAssetsApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAssetsApi: BaseApi {
    var uid: Int = 0
    init(Uid:Int)
    {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return MyAssets_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}
