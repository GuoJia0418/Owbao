//
//  PrizePersonMapModel.swift
//  Owbao
//
//  Created by Apple on 16/10/21.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PrizePersonMapModel: NSObject {

    var list = [PrizePersonListModel]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let activityCenter = PrizePersonListModel(dict: dict)
                    list.append(activityCenter)
                }
            }

            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
