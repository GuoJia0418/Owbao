//
//  JSAccumulatedIncomeModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSAccumulatedIncomeModel: NSObject {
    
    var map: JSAccumulatedIncomeMapModel?
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
                map = JSAccumulatedIncomeMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class JSAccumulatedIncomeMapModel: NSObject {
    
    var AccumulatedIncome: Double = 0.0
    var page: JSAccumulatedIncomePageModel?
    
    // MARK: - 构造函数
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
                page = JSAccumulatedIncomePageModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class JSAccumulatedIncomePageModel: NSObject {
    
    var rows = [JSAccumulatedIncomeRowsModel]()
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "rows" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let rowsModel = JSAccumulatedIncomeRowsModel(dict: dict)
                    rows.append(rowsModel)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class JSAccumulatedIncomeRowsModel: NSObject {
    var addTime: Double = 0.0     //添加时间
    var amount: Double = 0.0       //金额
    var remark: String = ""       //备注
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}



