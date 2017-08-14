//
//  InvestmentRowModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestmentRowModel: NSObject {
    var alreadyRaiseAmount:Double = 0.00  //已募集金额
    var amount:Double = 0.00              //产品金额
    var code:String?                      //产品编号
    var accept:String? = ""               // 承兑机构
    var deadline:Int = 0                 // 产品借款期限
    var fullName:String?                 // 产品全称
    var id:Int = 0                       //产品ID
    var leastaAmount:Int = 0             //产品金额
    var maxAmount:Double = 0.00          //产品投资限额
    var increasAmount:Double = 0.00      //产品投资递增金额
    var pert:Double = 0.00 {             // 产品募集百分比
        didSet {
            if pert > 0 && pert < 1 {
                pert = 1
            }
        }
    }
    var type:Int = 1                  // 区别于活动标 0  普通标 1
    
    var rate:Double = 0.00            // 产品利率
    var repayType:Int = 0             //还款方式  默认为1 到期还本付息
    
    //这是一个时间锉
    var startDate:Double = 0.00       //上架日期
    var status:Int = 0                //产品状态
    var surplusAmount:Double = 0.00   //产品剩余金额
    
    var isCash:Int = 0             //返现券 0：不可用  1：可用
    var isDeductible:Int = 0       //抵扣券 0：不可用  1：可用
    var isInterest:Int = 0         //加息券 0：不可用  1：可用
    var isDouble:Int = 0           //翻倍券 0：不可用  1：可用
    var isHot:Int = 0              //热推
    var billType:Int = 1           //票据类型 1:商票   2：银票
    
    var atid:Int = 0                    //是否是活动标  非0：活动标
    
    var isEgg: Int = 0                      //是否已砸蛋  1-未砸蛋，2-已砸蛋
    var maxActivityCoupon: Double = 0.00    //如果为空，表示不显示金蛋，有值则显示，示例：maxActivityCoupon :1%
    var activityRate:Double = 0.00          //活动利率
    
    //新加的：0正常的标 反之表示是投即送标
    var prizeId: Int = 0
    
    //新加的，用来刷新tableView特定的那几个的数据
    var pageOn: Int = 0 //第几行
    var pageSize: Int = 0 //请求个数
    
    //app2.0
    var investSendLabel: String = ""        //内容为投即送或者送iphone7的标签
    var prizeName: String = ""              //奖品名称
    var count: Int = 0                      //判断投资列表活动组当前有几个活动的

    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
