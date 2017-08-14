//
//  ExperienceInvestingApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/4.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  开始投资api

import UIKit

class ExperienceInvestingApi: BaseApi {
    var uid: Int = 0
    var ids: String = "" //以逗号分开
    var pid: Int = 0    //产品ID
    
    init(Uid: Int,Ids: String,Pid: Int) {
        super.init()
        uid = Uid
        ids = Ids
        pid = Pid
    }
    
    override func requestUrl() -> String! {
        return ExperienceInvest
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid":uid,"ids":ids,"pid":pid]
    }
}
