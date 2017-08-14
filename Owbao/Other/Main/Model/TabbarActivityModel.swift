//
//  TabbarActivityModel.swift
//  Owbao
//
//  Created by Feng Lu on 2016/12/22.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class TabbarActivityModel: NSObject {

    var success: Bool = false
    var map: TabbarActivityMapModel?
    var errorCode: String?
    
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
                map = TabbarActivityMapModel(dict: dict)
            }
            return
        }
    }
}

class TabbarActivityMapModel: NSObject {
    
    var isInDoubleEggActivity:Bool = false
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String){
        super.setValue(value, forKey: key)
    }
}

