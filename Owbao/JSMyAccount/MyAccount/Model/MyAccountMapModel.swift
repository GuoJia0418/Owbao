//
//  MyAccountMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAccountMapModel: NSObject {
    var balance: Double = 0.00 //账户余额
    var free: Double = 0.00   //冻结资金
    var realName: String?
    var realVerify: Int = 0
    var sex: Int = 0
    var tpwdFlag: Int = 0
    var unReadMsg: Int = 0
    var unUseFavourable: Int = 0            //未使用红包
    var winterest: Double = 0.00
    var wprincipal: Double = 0.00   //待收本金
    
    var unclaimed: Double = 0.00            //获取最新活动未领取奖励金额
    var afid:Int = 0                        //好友推荐活动id
    
    var isRedPacket: Int = 0                //是否有有效红包
    var isPayment: Int = 0                  //未来7天是否有回款 是=true，否=false
    var accumulatedIncome: Double = 0.0     //累计收益
    
    //app2.0
    var isNewHand:Int = 0                   //0-不可投 1-可投
    var availableExperience:Double = 0.00   //体验金可用金额
    var unTiedCardTitle:String? = ""        //未绑卡标签
    var newHandId:Int  =  0                 //新手标id
    var isPerfect:Int = 0                   //收货信息是否完善 true=完善，false=不完善
    var pid:Int = 0                         //产品ID
    var investId: Int = 0                   //投资id
    
    //存管功能字段
    var balanceFuiou: Double = 0.0          //存管账户余额
    var collectAmountFuiou: Double = 0.0    //存管待收本息
    var wprincipalFuiou: Double = 0.0       //存管待收本金
    var freeFuiou: Double = 0.0             //存管冻结中的资金
    var profitFuiou: Double = 0.0           //存管已经获得的收益
    var winterestFuiou: Double = 0.0        //存管待收收益
    var isFuiou: Int = 0                    //是否开通存管
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
