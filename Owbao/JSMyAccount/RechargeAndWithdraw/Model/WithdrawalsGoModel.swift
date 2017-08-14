//
//  WithdrawalsGoModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class WithdrawalsGoModel: NSObject {
    var errorCode :String = ""
    var success:Bool = false
    var map: JSWithdrawalsGoMapModel?
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
        
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = JSWithdrawalsGoMapModel(dict: dict)
            }
            return
        }
        
//        if key == "errorCode" {
//            let dict = ["9999": "系统错误", "1001": "提现金额有误","1002":"交易密码不能为空", "1003": "交易密码错误","1004":"余额不足","1005":"提现失败，请再次申请","1006":"处理中","1007":"该笔需要收取手续费","1008":"该笔不需要收取手续费","1009":"渠道不能为空","2001":"2001","2002":"2002","XTWH":"XTWH"]
//            errorCode = dict[value as! String]
//        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
