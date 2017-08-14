//
//  ProductDetailsInfoModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailsInfoModel: NSObject {
    var alreadyRaiseAmount :Double = 0.00
    var amount :Double = 0.00
    var code :String?
    var deadline:Int = 0
    var fullName:String?
    var id:Int = 0
    var leastaAmount:Double = 0.00 //最少投资金额
    var maxAmount:Double = 0.00 //最大投资金额
    var increasAmount:Double = 0.00
    var pert:Double = 0.00
    var rate:Double = 0.00
    var activityRate:Double = 0.00  //增加的rate
    var repayType: Int = 0       //还款方式 1,到期付息还本，2每月付息到期还本
    var startDate: Double = 0.00 //上架日期
    var endDate: Double = 0.00 //募集结束时间
    var status: Int = 0
    var surplusAmount: Double = 0.00  //产品剩余金额
    
    var isCash: Int = 0
    var isDeductible: Int = 0
    var isInterest: Int = 0
    var isDouble: Int = 0
    
    var repaySource: String? = ""    //还款来源
    var windMeasure: String? = ""    //还款保障
    var introduce: String? = ""      //产品介绍
    var borrower: String? = ""       //借款用途
    var principleH5: String = ""     //h5原理图url
    
    // 添加 6.23
    var establish: Double = 0.00  //成立日期
    var expireDate: Double = 0.00  //到期日期
    var billType:Int = 1
    var fid: Int = 0         //上一个产品ID
    var atid: Int = 0        //判断是否是活动标(活动标里面包括：投即送、iPhone7)
    
    var isEgg: Int = 0       //1 为砸蛋  2：已经砸蛋
    var maxActivityCoupon: Double = 0.00
    
    //app2.0新增
    var isPrize: Int = 0             //0=不是iphone7标，1=开奖2=未开奖
    var type: Int = 2                //3:存管新手标，1:老新手标，2:普通标，5:体验标
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
