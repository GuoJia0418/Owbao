
//
//  MyCouponsListModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyCouponsListModel: NSObject {
    
    var amount: Double = 0.00         //投资项目的金额
    var enableAmount: Int = 0        //最低使用金额
    var type :Int = 0               //类型:1：返现券  2：加息券 3：体验金 4：翻倍券
    var raisedRates: Double = 0.00 //加息利率
    var expireDate: Double = 0.00  //有效期
    var addtime: Double = 0.00   //发放时间
    
    var multiple: Double = 0.00   //翻倍倍数
    var status: Int = 0           //状态 0：未使用  1：已使用 2：已过期 3: 不可用
    var remark: String?           //优惠券备注
    var id: Int = 0
    var productDeadline: Int = 0 //期限
    var pid: Int = 0             //优惠券绑定产品
    
    var productType: Int = 0    //产品type
    var fullName: String?      //产品名称
    var name: String?          //名字
    
    
    var source: Int = 0     //100=未激活 99=激活&体验金，其他都为激活
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
