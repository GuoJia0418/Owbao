//
//  GetPrizeModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/29.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetPrizeModel: NSObject {
    
    var map: GetPrizeMapModel?
    var success: Bool = false
    var errorCode: String = ""
    var errorMsg: String = ""
    init(dictionary: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [String: AnyObject] {
                map =  GetPrizeMapModel(dict: arr)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
}

class GetPrizeMapModel: NSObject {
    
    var prize: ProductDetailsMapPrizeModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "prize" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [String: AnyObject] {
                prize =  ProductDetailsMapPrizeModel(dict: arr)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
}
