//
//  GetAddressModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetAddressModel: NSObject {
    
    var map: GetAddressMapModel?
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
                map = GetAddressMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

class GetAddressDetailModel: NSObject {
    
    var address: String = ""        //地址
    var name: String = ""           //姓名
    var phone: String = ""          //手机号码
    
    var detailAddress: String = ""          //详细的地址,用户自己填写的地址
    var chooseLocationAddress: String = ""  //用户自己选择的地址
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class GetAddressMapModel: NSObject {
    var jsMemberInfo: GetAddressDetailModel?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "jsMemberInfo" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [String: AnyObject] {
                // 然后开始遍历
                self.jsMemberInfo = GetAddressDetailModel(dict: arr)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

