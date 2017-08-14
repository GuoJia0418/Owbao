//
//  NewHeadModel.swift
//  Owbao
//
//  Created by Panda on 16/6/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class NewHeadModel: BaseModel {
    var success :Bool = false
    var map : NewHeadMapModel?
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
                map = NewHeadMapModel(dict: dict)
            }
            return
        }
        
        
    }

}
