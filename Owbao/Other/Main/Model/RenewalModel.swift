//
//  RenewalModel.swift
//  Owbao
//
//  Created by Panda on 16/6/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RenewalModel: NSObject {

    var success :Bool = false
    var map : RenewalMapModel?
    var maxVersion:String? = "0.0.0"
    
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
                map = RenewalMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class RenewalMapModel: NSObject {
    
    var isMaintenance: String? = ""      //是否系统维护
    var maxVersion: String? = ""
    var sysAppRenewal: SysAppRenewalModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "sysAppRenewal" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                sysAppRenewal = SysAppRenewalModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class SysAppRenewalModel: NSObject {
    
    var version: String? = ""
    var isForceUpdate: Int? = 0
    var content: String? = ""
    var addUser: Int! = 0
    var id: Int! = 0
    var containers: Int! = 0
    var status: Int! = 0
    var remark: Int! = 0
    var releaseVersion: String? = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "isForceUpdate" {
            
            let numValue = value as? Int
            if numValue == 0 {
                isForceUpdate = 0
            } else {
                isForceUpdate = 1
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
