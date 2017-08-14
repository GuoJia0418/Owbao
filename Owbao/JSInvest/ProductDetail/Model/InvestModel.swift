//
//  InvestModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestModel: NSObject {
    var errorCode: String = ""
    var errorMsg: String = ""
    
    var success: Bool = false
    var flag: Bool = false
    var map: InvestMapModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
//        if key == "errorCode" {
//            let dict = ["1001": "交易密码错误", "1002": "产品已募集完","1003": "项目可投资金额不足", "1004": "小于起投金额","1005": "非递增金额整数倍", "1006": "投资金额大于项目单笔投资限额","1007": "账户可用余额不足", "1008": "已投资过产品，不能投资新手产品","1009": "用户不存在", "1010": "优惠券不可用"]
//            errorCode = dict[value as! String]
//            return
//        }
        if key == "map" {
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = InvestMapModel(dict: dict)
            }

            return
        }
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
