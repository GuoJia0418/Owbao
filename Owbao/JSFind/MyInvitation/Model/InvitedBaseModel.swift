
//
//  InvitedBaseModel.swift
//  Owbao
//
//  Created by GuoJia on 16/11/28.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedBaseModel: NSObject {
    
    var invitedModel: InvitedModel?
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
            // 判断 value
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                invitedModel = InvitedModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

//class TestModel: NSObject {
//    var success:Bool = false
//    var errorCode:String = ""
//}
