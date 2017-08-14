//
//  MyAccountGetMoneyNowApi.swift
//  Owbao
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit


class MyAccountGetMoneyNowApi: BaseApi {

    var uid: Int = 0 //用户ID
    var afid: Int = 0  //活动id
    init(Uid: Int,Afid: Int)
    {
        super.init()
        uid = Uid
        afid = Afid
    }
    override func requestUrl() -> String! {
        return MyAccountGetMoney_Api
    }
    override func untreatedArgument() -> Any! {
        
        return ["uid": uid,"afid": afid]
    }

}
