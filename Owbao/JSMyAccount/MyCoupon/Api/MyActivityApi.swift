//
//  MyActivityApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyActivityApi: BaseApi {
    var uid: Int = 0
    var status: Int = 0     // 0=未使用，1=已使用，2=已失效（不传值查所有）
    var flag: Int = 0       //1=查红包 2=返现券 3=加息券 4=翻倍券 0=体验金（不传值查所有）
    
    init(Uid:Int,Status:Int,Flag: Int) {
        super.init()
        uid = Uid
        status = Status
        flag = Flag
    }
    
    override func requestUrl() -> String! {
        return MyActivity_Api
    }
    
    override func untreatedArgument() -> Any! {
        if status >= 0 {
            return ["uid": uid,"status":status,"flag" : flag]
        } else {
            return ["uid": uid,"flag" : flag]
        }
    }
}
