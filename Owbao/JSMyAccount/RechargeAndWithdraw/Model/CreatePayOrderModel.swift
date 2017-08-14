//
//  CreatePayOrderModel.swift
//  Owbao
//
//  Created by Panda on 16/5/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class CreatePayOrderModel: BaseModel {
    var map :CreatePayOrderMapModel?
    var success:Bool = false
    var errorCode:String?
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = CreatePayOrderMapModel(dict: dict)
            }
            return
        }
        
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
