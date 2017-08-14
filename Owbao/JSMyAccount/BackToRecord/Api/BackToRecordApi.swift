//
//  BackToRecordApi.swift
//  Owbao
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BackToRecordApi: BaseApi {
    
    var pid: Int = 0 //产品id
    var uid: Int = 0 //用户ID
    var id: Int = 0  //投资记录ID
    init(Uid: Int,Pid: Int,Id: Int)
    {
        super.init()
        uid = Uid
        if Pid > 0 {
            pid = Pid
        }
        
        id  = Id
    }
    override func requestUrl() -> String! {
        return MyBackToRecord_Api
    }
    override func untreatedArgument() -> Any! {
    
        return ["uid": uid,"pid": pid,"id": id]
    }
}
