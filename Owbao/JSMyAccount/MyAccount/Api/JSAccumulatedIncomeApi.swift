//
//  JSAccumulatedIncomeApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  累计收益

import UIKit

class JSAccumulatedIncomeApi: BaseApi {
    var pageOn: Int = 0
    var pageSize: Int = 10
    var uid: Int = 0
    
    init(Uid: Int,PageOn: Int) {
        super.init()
        uid = Uid
        pageOn = PageOn
    }
    
    override func requestUrl() -> String! {
        return MyAccumulatedIncome_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pageOn": pageOn,"pageSize": pageSize]
    }
}
