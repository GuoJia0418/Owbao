//
//  MyAssetRowsModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAssetRowsModel: NSObject {
    var amount: Double = 0.00
    var balance: Double = 0.00
    var type: Int = 0 //0=支出，1=收入
    var status: Int = 0
    var addTime: Double = 0.00
    var tradeType: Int = 0 //1=充值，2=提现，3=投资，4=活动,5=提现手续费，6=回款,,7=体验金
    var remark: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
