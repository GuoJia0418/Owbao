//
//  MyAssetsFundsModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAssetsFundsModel: NSObject {
    var balance: Double = 0.00           //账户余额
    var freeze: Double = 0.00            //冻结金额
    var investAmount: Double = 0.00      //总投资金额
    var investProfit: Double = 0.00      //投资获得的收益
    var spreadProfit: Double = 0.00      //用户推广获得的收益
    var winterest: Double = 0.00         //待收收益
    var wprincipal: Double = 0.00        //待收本金
    var fuiou_balance: Double = 0.0      //存管可用余额
    var fuiou_freeze: Double = 0.0       //存管冻结资金
    var fuiou_wprincipal: Double = 0.0   //存管待收本金
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
