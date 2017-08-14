//
//  WithdrawalsHomeMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class WithdrawalsHomeMapModel: NSObject {
    var fuiou_balance: Double = 0.00 //恒丰可用余额
    var funds: Double = 0.00        //可用余额
    
    var bankNum: String?            //银行卡尾号
    var bankNumFuiou: String = ""  //恒丰银行卡尾号
    
    var bankCode: Int = 0          //对应银行ID  realFlag=1 时有值
    var bankCodeFuiou: Int = 0     //恒丰 对应银行ID  realFlag=1 时有值
    
    var quota: Int = 0
    var isChargeFlag: Int = 0   //是否收取手续费
    var isFuiou: Int = 0       //是否存管
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
