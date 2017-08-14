//
//  JSWithdrawalsGoMapModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/3.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSWithdrawalsGoMapModel: NSObject {
    
    var withdrawalsTime:Double = 0.00   //提现时间
    var confirmTime:Double = 0.00       //第三方确认时间
    var withdrawalsSuccessTime:Double = 0.00    //提现成功时间
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
