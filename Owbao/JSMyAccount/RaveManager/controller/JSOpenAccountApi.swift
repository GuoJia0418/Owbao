//
//  JSOpenAccountApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOpenAccountApi: BaseApi {
    
    var open_uid: Int = 0
    var open_cust_nm: String = ""       //客服的姓名
    var open_certif_id: String = ""     //身份证号码
    var open_mobile_no: String = ""     //手机身
    var open_city_id: String = ""       //开户行地区代码
    var open_parent_bank: String = ""   //开户行代码
    var open_capAcntNo: String = ""     //帐号
    var open_password: String = ""      //密码
    var open_conformPassword: String = "" //重复密码
    
    init(uid: Int,
         cust_nm: String,
         certif_id: String,
         mobile_no: String,
         city_id: String,
         parent_bank: String,
         capAcntNo: String,
         password: String,
         conformPassword: String) {
        
        super.init()
        
        self.open_uid = uid
        self.open_cust_nm = cust_nm
        self.open_certif_id = certif_id
        self.open_mobile_no = mobile_no
        self.open_city_id = city_id
        self.open_parent_bank = parent_bank
        self.open_capAcntNo = capAcntNo
        self.open_password = password
        self.open_conformPassword = conformPassword
        
    }
    
    override func requestUrl() -> String! {
        return OpenAccount_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": open_uid,"cust_nm": open_cust_nm,"certif_id": open_certif_id,"mobile_no": open_mobile_no,"city_id": open_city_id,"parent_bank_id": open_parent_bank,"capAcntNo": open_capAcntNo,"password": open_password,"rpassword": open_conformPassword]
    }
}
