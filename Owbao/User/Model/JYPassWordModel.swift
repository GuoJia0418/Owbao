//
//  JYPassWordModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class JYPassWordModel: NSObject {
    var errorCode :String?
    var success:Bool = false
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "errorCode" {
//            let dict = ["1001": "验证码错误","1002":"密码为空","1003":"交易密码不合法","9999":"系统错误"]
//            
//            errorCode = dict[value as! String]
//            return
//        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
