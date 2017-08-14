//
//  JSPrizeDetailMapModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSPrizeDetailMapModel: NSObject {
    var luckCodes:String? = ""   //我的幸运码
    var prizeStatus:Int = 0     //0-未开奖，1-已开奖
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
