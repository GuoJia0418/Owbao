//
//  EnrollApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class EnrollApi: BaseApi {

    var uid: Int = 0
    var sex: Int = 0           //0:男 1:女
    var city: String = ""      //城市
    var userName: String = ""  //姓名
    var openDayId: Int = 0     //活动日id
    
    init(Uid: Int,
         Sex: Int,
         City: String,
         UserName: String,
         OpenDayId: Int) {
        super.init()
        
        self.uid = Uid
        self.sex = Sex
        self.city = City
        self.userName = UserName
        self.openDayId = OpenDayId
    }
    
    override func requestUrl() -> String! {
        return Enroll_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"city": city,"sex": sex,"userName": userName,"openDayId": openDayId]
    }
}
