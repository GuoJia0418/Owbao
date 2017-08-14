//
//  HomeNewHandModle.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class HomeNewHandModle: BaseModel {
    
    var rate:Double = 0.00           //产品利率
//    var amoubt:Double = 0.00
    var deadline :Int = 0            //投资期限
    var leastaAmount:Double = 0.00   //起投金额
    var maxAmount:Double = 0.00      //限投金额
    var id:Int = 0
    var simpleName:String?
    var fullName:String?
    var atid:Int = 0                 //活动标不为0  其他标 为0
    var type:Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
