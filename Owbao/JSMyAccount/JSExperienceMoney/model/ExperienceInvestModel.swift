//
//  ExperienceInvestModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ExperienceInvestModel: NSObject {
    var map: ExperienceInvestMapModel?
    var success: Bool = false
    var errorCode: String = ""
    var errorMsg: String = ""
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = ExperienceInvestMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ExperienceInvestMapModel: NSObject {
    
    var info: ExperienceInvestInfoModel?
    var investCount: Int = 0             //投资人数
    var experienceAmount: ExperienceInvestAmountModel? //投资模型
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "Info" {
            if let arr = value as? [String: AnyObject] {
                // 然后开始遍历
                self.info = ExperienceInvestInfoModel(dict: arr)
            }
            return
        }
        
        if key == "experienceAmount" {
            if let arr = value as? [String: AnyObject] {
                // 然后开始遍历
                self.experienceAmount = ExperienceInvestAmountModel(dict: arr)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ExperienceInvestInfoModel: NSObject {
    
    var deadline: Int = 0           //产品借款期限
    var fullName: String = ""       //产品名称
    var activityRate: Double = 0.0  //活动利率
    var id: Int = 0                 //产品ID
    var rate: Double = 0             //利率
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ExperienceInvestAmountModel: NSObject {
    
    var ids: String = ""           //Ids，以’,’分割
    var experAmount: Double = 0.0  //体验金金额
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


