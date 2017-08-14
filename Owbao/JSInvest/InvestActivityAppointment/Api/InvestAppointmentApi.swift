//
//  InvestAppointmentApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/27.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestAppointmentApi: BaseApi {
    var uid: Int = 0
    var ppid: Int = 0
    init(Uid:Int,Ppid: Int) {
        super.init()
        uid = Uid
        ppid = Ppid
    }
    
    override func requestUrl() -> String! {
        return InvestAppoinment_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"ppid": ppid]
    }
}
