//
//  ExperienceInvestApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ExperienceInvestApi: BaseApi {
    var uid: Int = 0
    init(Uid:Int) {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return ExperienceDetail
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}


