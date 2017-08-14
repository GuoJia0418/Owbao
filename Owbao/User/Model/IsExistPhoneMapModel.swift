//
//  IsExistPhoneMapModel.swift
//  Owbao
//
//  Created by Panda on 16/6/6.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class IsExistPhoneMapModel: NSObject {
    var exists:Int = 0
    var time:String = ""  //手机token
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
    
        super.setValue(value, forKey: key)
    }
    
     override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
