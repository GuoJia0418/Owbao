//
//  JSOfflineActivityPageModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOfflineActivityPageModel: NSObject {
    var total:Int = 0
    var totalPage:Int = 0
    var rows = [JSOfflineActivityRowsModel]()
    var pageInfo: JSOfflineActivityPageInfoModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "pageInfo" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                pageInfo = JSOfflineActivityPageInfoModel(dict: dict)
            }
            return
        }
        if key == "rows" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = JSOfflineActivityRowsModel(dict: dict)
                    rows.append(invest)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
