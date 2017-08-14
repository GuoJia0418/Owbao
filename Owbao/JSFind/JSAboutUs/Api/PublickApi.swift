//
//  PublickApi.swift
//  Owbao
//
//  Created by GuoJia on 16/11/28.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PublickApi: BaseApi {
    var uid: Int = 0
    var pageSize: Int = 10
    var pageOn: Int = 1
    var proId: Int = 14  //1=公司动态，2=公司新闻，14=公司公告,这里写成默认的
    
    init(Uid: Int,PageOn: Int,ProId: Int) {
        super.init()
        uid = Uid
        pageOn = PageOn
        proId = ProId
    }
    
    override func requestUrl() -> String! {
        return PublicNotice_api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"pageOn": pageOn,"pageSize": 10,"proId": proId]
    }
}
