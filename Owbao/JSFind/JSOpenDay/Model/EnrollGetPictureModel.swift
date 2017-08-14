//
//  EnrollGetPictureModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class EnrollGetPictureModel: NSObject {
    
    var map: EnrollGetPictureMapModel?
    
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
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = EnrollGetPictureMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


class EnrollGetPictureMapModel: NSObject {
    
    var jsSpecial: EnrollGetPictureJsSpecialModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "jsSpecial" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                jsSpecial = EnrollGetPictureJsSpecialModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class EnrollGetPictureJsSpecialModel: NSObject {
    
    var h5TopBanner: String = "" //h5的顶部图片
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
   
}
