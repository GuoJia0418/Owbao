//
//  HomeModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class HomeModel: BaseModel {
    
    var success :Bool = false
    var map : HomeMapModel?
    var errorCode:String? = ""
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {

        if key == "map" {
            super.setValue(value, forKey: key)

            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = HomeMapModel(dict: dict)
            }
            return
        }
        
        if key == "success" || key == "map" || key == "errorCode"{
            super.setValue(value, forKey: key)
            
        }
    }
}

