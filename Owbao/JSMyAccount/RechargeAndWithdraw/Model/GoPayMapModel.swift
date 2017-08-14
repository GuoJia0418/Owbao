//
//  GoPayMapModel.swift
//  Owbao
//
//  Created by Panda on 16/5/27.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class GoPayMapModel: BaseModel {
    var amount:Double = 0.00
    var src:String? = ""
    
    var payTime:Double = 0.00       //充值时间
    var confirmTime:Double = 0.00    //第三方确认时间
    var paySuccessTime:Double = 0.00  //充值成功时间 
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
