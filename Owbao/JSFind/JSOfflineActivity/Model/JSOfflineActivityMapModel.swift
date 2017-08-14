//
//  JSOfflineActivityMapModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOfflineActivityMapModel: NSObject {
    var page: JSOfflineActivityPageModel?
    var openDayLabel:String = ""
    var openDayPicUrl:String = ""
    
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
                page = JSOfflineActivityPageModel(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
