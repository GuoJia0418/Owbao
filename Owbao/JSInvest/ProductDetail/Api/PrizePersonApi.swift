//
//  PrizePersonApi.swift
//  Owbao
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PrizePersonApi: BaseApi {
    
    var id: Int = 0
//    var id: String? = ""
    init(Pid: Int)
    {
        super.init()
        id = Pid
    }
    
    override func requestUrl() -> String! {
        return PrizePerson_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["id": id]
    }
}
