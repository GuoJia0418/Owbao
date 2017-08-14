//
//  ApponintmentApi.swift
//  Owbao
//
//  Created by GuoJia on 16/11/22.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//  

import UIKit

class ApponintmentApi: BaseApi {
    var prid: Int = 1
    var amount: Double = 0
    var uid: Int = 0
    
    init(Prid:Int,Amount: Double,Uid:Int)
    {
        super.init()
        prid = Prid
        uid = Uid
        amount = Amount
    }
    
    override func requestUrl() -> String! {
        return Apponintment_Api
    }
    
    override func untreatedArgument() -> Any!
    {
        return ["prid": prid,"amount":amount,"uid":uid]
        
    }
}
