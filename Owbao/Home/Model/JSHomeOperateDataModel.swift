//
//  JSHomeOperateDataModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/6/17.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSHomeOperateDataModel: BaseModel {
    var regCount: Double = 0.00     //注册人数
    var investCumulative:Double = 0.00  //累计投资金额
    var profitCumulative:Double = 0.00  //累计收益
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
