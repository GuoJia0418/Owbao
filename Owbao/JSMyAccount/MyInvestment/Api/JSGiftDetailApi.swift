//
//  JSGiftDetailApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGiftDetailApi: BaseApi {
    var investId: Int = 0
    var pid: Int = 0
    
    init(InvestId:Int,Pid:Int)
    {
        super.init()
        investId = InvestId
        pid = Pid
    }
    
    override func requestUrl() -> String! {
        return MyInvest_GiftDetail_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["investId": investId,"pid":pid]
    }

}
