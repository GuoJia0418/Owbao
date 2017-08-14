//
//  Model.swift
//  Owbao
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class AddContinueRewardModel: NSObject {

    var success:Bool = false
    var errorCode: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
