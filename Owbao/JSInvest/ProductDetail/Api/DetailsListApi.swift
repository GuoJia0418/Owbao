//
//  DetailsListApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class DetailsListApi: BaseApi {
        var pid: Int = 0
        var type: Int = 0
        init(Pid:Int,Type:Int)
        {
            super.init()
            pid = Pid
            type = Type
        }
        
        override func requestUrl() -> String! {
            return DetailsList_Api
        }
        
        override func untreatedArgument() -> Any! {
            return ["pid": pid,"type":type]
        }
}
