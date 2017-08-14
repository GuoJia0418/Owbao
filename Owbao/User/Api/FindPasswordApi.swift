//
//  FindPasswordApi.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class FindPasswordApi: BaseApi {
    var mobilephone: String?
    var uid: Int = 0
    var type:String = "1"
    
    init(uid: Int,Mobilephone:String,type:String) {
        super.init()
        self.uid = uid
        self.mobilephone = Mobilephone
        self.type = type
    }
    override func requestUrl() -> String! {
        return FIND_PASSWORD_API
    }
    override func untreatedArgument() -> Any! {
        if uid == 0 {
            return ["mobilephone": mobilephone!,"type":type]
        }else{
            return ["uid": uid,"type":type]
        }
    }
}
