//
//  MemberSetModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MemberSetModel: NSObject {
    var errorCode :String?
    var success:Bool = false
    var flag:Bool = false
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
   
    
//    override func setValue(value: AnyObject?, forKey key: String) {
//        super.setValue(value, forKey: key)
//    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
