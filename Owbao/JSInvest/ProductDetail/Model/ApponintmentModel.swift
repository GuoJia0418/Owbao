//
//  ApponintmentModel.swift
//  Owbao
//
//  Created by GuoJia on 16/11/22.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class ApponintmentModel: NSObject {
     var success: Bool = false
     var errorCode: String?
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}
