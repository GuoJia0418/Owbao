//
//  RechargeMsgModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/14.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RechargeMsgModel: NSObject {
    var errorCode :String?
    var success:Bool = false
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "errorCode" {
            let dict = ["9999": "系统错误","1002":"短信发送失败"]
            errorCode = dict[value as! String]
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
