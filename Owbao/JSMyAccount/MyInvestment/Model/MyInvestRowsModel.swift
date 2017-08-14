//
//  MyInvestRowsModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyInvestRowsModel: NSObject {
    var amount:Double = 0.00
    var fullName:String?
    var deadline :Int = 0
    var rate:Double = 0.00
    var factAmount:Double = 0.00
    var factInterest:Double = 0.00
    var expireInterest:Double = 0.00  //到期收益
    var establish:Double = 0.00     //计息日期 也是成立日期
    var expireDate:Double = 0.00
    var repayType:Int = 0
    var iShow:Bool = false
    var investTime:Double = 0.00        //投资日期
    var couponType:Int = 0              //1=返现，2=加息，3=体验金额，4=翻倍券
    var couponAmount:Double = 0.00      //优惠券金额
    var couponRate:Double = 0.00
    var multiple:Double = 0.00
    var id:Int = 0
    var pid:Int = 0
    var uid:Int = 0
    var prePid:Int = 0
    var sid:Int = 0
    var continuePeriod:Int = 0      //续投期限 (新手标续投期限（到期续投xx天标）)
    
    //APP2.0 
    var periodLabel:String = ""     //新手标续投标签 如果是新手标并且已续投则有值
    
    var activityRate:Double = 0.00  //活动利率
    var type:Int = 0                //3-新手标 2-普通标 5-体验标
    var specialRate:Double = 0.00
    
    //APP2.0
    var productStatus:Int = 0       //产品状态
    var productType:Int = 0         //0-普通标 1-投即送 2-送iPhone7
    var prizeName:String = ""       //奖品名称
    
    //app2.0
    var interestTime:Double = 0.00  //
    var isPerfect: Int = 1  //1 = 已完善，0 = 未完善 默认是已经完善
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
