//
//  MyCouponsMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyCouponsMapModel: NSObject {
    
    var list = [MyCouponsListModel]()
    var amountSum: Double = 0.0
    
    var newHandId: Int = 0   //新手标的id
    
    // MARK: - 构造函数
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
                    let invest = MyCouponsListModel(dict: dict)
                    list.append(invest)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
