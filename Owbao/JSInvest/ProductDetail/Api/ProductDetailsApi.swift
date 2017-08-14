//
//  ProductDetailsApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailsApi: BaseApi {
    var pid: Int = 0
    var uid: Int = 0
    init(Pid:Int,Uid:Int) {
        super.init()
        if Pid > 0 {
            pid = Pid
        }
       
        uid = Uid
        
    }
    
    override func requestUrl() -> String! {
        return ProductDetails_Api
    }
    
    override func untreatedArgument() -> Any! {
        if uid == 0 {
            return ["pid": pid]
        }
        return ["pid": pid,"uid":uid]
    }
}
