//
//  GetPrizeApi.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/29.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetPrizeApi: BaseApi {

    var uid: Int = 0
    var id: Int = 0
    init(Uid:Int,Id: Int) {
        super.init()
        uid = Uid
        id = Id
    }
    
    override func requestUrl() -> String! {
        return SelectProduct_Prize
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"id": id]
    }
}
