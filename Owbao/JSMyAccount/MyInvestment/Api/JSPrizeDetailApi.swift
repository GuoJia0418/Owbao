//
//  JSPrizeDetailApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSPrizeDetailApi: BaseApi {
    var uid:Int = 0
    var pid: Int = 0
    var investId: Int = 0
    
    init(Uid: Int,Pid: Int,InvestId: Int) {
        super.init()
        uid = Uid
        pid = Pid
        investId = InvestId
    }
    
    override func requestUrl() -> String! {
        return MyInvest_PrizeDetail_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pid": pid,"investId": investId]
    }

}
