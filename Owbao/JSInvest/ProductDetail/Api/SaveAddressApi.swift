//
//  SaveAddressApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class SaveAddressApi: BaseApi {

    var uid: Int = 0
    var name: String = ""
    var phone: String = ""
    var address: String = ""
    var investId: Int = 0
    
    /**
     *  Uid: 用户ID
     *  Name: 收货人名字
     *  Phone: 收货人手机号码
     *  Address: 收货人地址
     *  InvestId: 投资id
     */
    init(Uid:Int,Name: String,Phone: String,Address: String,InvestId: Int) {
        
        super.init()
        uid = Uid
        name = Name
        phone = Phone
        address = Address
        investId = InvestId
    }
    
    override func requestUrl() -> String! {
        return SaveAddress_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"name": name,"phone": phone,"address": address,"investId": investId]
    }
    
}
