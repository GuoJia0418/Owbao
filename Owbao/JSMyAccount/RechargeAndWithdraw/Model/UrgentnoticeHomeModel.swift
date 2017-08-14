//
//  UrgentnoticeHomeModel.swift
//  Owbao
//
//  Created by Panda on 16/4/27.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UrgentnoticeHomeModel: NSObject {
    var map :UrgentnoticeMapModel?
    var success:Bool = false
    var errorCode:String?
    
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
                map = UrgentnoticeMapModel(dict: dict)
                
            }
            return
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
