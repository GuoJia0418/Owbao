//
//  ForgetPwdModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ForgetPwdModel: NSObject {
    var errorCode :String? = ""
    var success:Bool = false
    var msg:String?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "errorCode" {
            let dict = ["9999": "系统错误", "1001": "发送失败","8888":"频繁操作"]
            errorCode = dict[value as! String]
        }
    }
}
