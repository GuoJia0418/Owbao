//
//  JSHomePreferredInvestModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSHomePreferredInvestModel: BaseModel {

    var preferredName:String? = ""   //标题
    var minRate:Double = 0.00       //最小
    var maxRate:Double = 0.00
    var minDeadline:Int = 0
    var isCash:Int = 0              //是否有红包标签 0 = 否 1=是
    var isInterest:Int = 0          //是否有加息券标签0 = 否 1=是
    var isDouble:Int = 0          //是否有翻倍劵标签0 = 否 1=是
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
