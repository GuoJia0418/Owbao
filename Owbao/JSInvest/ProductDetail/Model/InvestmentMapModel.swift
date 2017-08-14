//
//  InvestmentMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestmentMapModel: NSObject {
    
    var page: InvestmentPageModel?
    var activity_60: Double = 0.00
    var activity_180: Double = 0.00
    var activityUrl: String = ""      //活动url
    
    var newHandLabel: String = ""
    var activityProduct: InvestmentActivityProductModel?    //投资列表下面有个90天活动标组需要展示
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "page" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                page = InvestmentPageModel(dict: dict)
            }
            return
        }
        
        if key == "activityProduct" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                activityProduct = InvestmentActivityProductModel(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class InvestmentActivityProductModel: NSObject {
    var activityRate: Double = 0.00          //活动利率
    var rate: Double = 0.00                    //利率
    var maxRate: Double = 0.00                 //最大活动利率
    var title: String = ""                  //标题
    var deadline: Int = 0                 // 产品借款期限
    var count: Int = 0                    //当前有多少活动标
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}



