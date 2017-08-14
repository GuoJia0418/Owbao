//
//  AppLastLoginApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/16.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class AppLastLoginApi: BaseApi {
    var uid:Int = 0
    
    init(Uid: Int) {
        super.init()
        self.uid = Uid
    }
    override func requestUrl() -> String! {
        return  LastLogin_Api
    }
    override func untreatedArgument() -> Any! {
        
        return ["uid": uid]
    }
}
