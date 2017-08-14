//
//  AddContinueRewardApi.swift
//  Owbao
//
//  Created by Apple on 16/11/29.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class AddContinueRewardApi: BaseApi {
    var uid: Int = 0
    var period:Int = 0
    
    init(Uid:Int,Period:Int)
    {
        super.init()
        uid = Uid
        period = Period
    }
    
    override func requestUrl() -> String! {
        return AddContinueReward_Api
    }
    
    override func untreatedArgument() -> Any!
    {
        return ["uid":uid,"period":period]
        
    }
}
