//
//  FeedbackModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/22.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class FeedbackModel: NSObject {
    var success:Bool = false
    var errorCode:String?
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "errorCode" {
            let dict = ["9999": "系统错误","9998": "登陆失效,请重新登陆"]
            errorCode = dict[value as! String]
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
