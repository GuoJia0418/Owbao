//
//  GetContinueRewardListModel.swift
//  Owbao
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

open class GetContinueRewardListModel: NSObject {

    var amount:Double = 0.00         //奖励金额
    var deadline:Int = 0             //续投期限
    var investAmount:Double = 0.00   //新手标投资金额
    var rate:Double = 0.00           //预期年化
    var profitAmount:Double = 0.00   //预计收益
    var activityRate: Double = 0.00  //增加的活动利率
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
}
