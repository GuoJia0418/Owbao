//
//  GetContinueRewardApi.swift
//  Owbao
//
//  Created by Apple on 16/11/29.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetContinueRewardApi: BaseApi {
    
    var uid: Int = 0
    
    init(Uid:Int)
    {
        super.init()
        uid = Uid
    }
    
    override func requestUrl() -> String! {
        return GetContinueReward_Api
    }
    
    override func untreatedArgument() -> Any!
    {
        return ["uid":uid]
        
    }
}
