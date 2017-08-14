//
//  BaseModel.swift
//  Owbao
//
//  Created by Panda on 16/5/18.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String){
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        super.setValue(value, forUndefinedKey: key)

    }
}
