//
//  MyBackToRecord.swift
//  Owbao
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyBackToRecordModel: NSObject {

    var success:Bool = false
    var map: MyBackToRecordMapModel?
    var errorCode:String?
    var errorMsg:String? = ""
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = MyBackToRecordMapModel(dict: dict)
            }
            return
            
//            // 判断 value 是否是 一个 有效的 数组
//            if let arr = value as? [[String: AnyObject]] {
//                for dict in arr {
//                    let resultRecord = MyBackToRecordResultModel(dict: dict)
//                    result.append(resultRecord)
//                   
//                }
//            }
//            return
        }
        if key == "errorCode" {
            let dict = ["9999": "系统错误"]
            errorCode = dict[value as! String]
            return
        }
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
