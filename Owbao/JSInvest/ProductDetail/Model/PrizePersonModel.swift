//
//  PrizePersonModel.swift
//  Owbao
//
//  Created by Apple on 16/10/21.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PrizePersonModel: NSObject {

    var map: PrizePersonMapModel?
    var success: Bool = false
    var errorCode: String = ""
    var errorMsg: String = ""
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dictionary)
    }
    
    // MARK: - 构造函数
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = PrizePersonMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
