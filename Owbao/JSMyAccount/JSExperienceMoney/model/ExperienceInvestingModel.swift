//
//  ExperienceInvestingModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/4.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ExperienceInvestingModel: NSObject {
    
    var map: ExperienceInvestingMapModel?
    var success: Bool = false
    var errorCode: String = ""
    var errorMsg: String = ""
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = ExperienceInvestingMapModel(dict: dict)
            }
            return
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ExperienceInvestingMapModel: NSObject {
    var realverify: Bool = false   //实名认证 1:已认证 0:未认证
    var redTotal: Int = 0          //红包数量
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
