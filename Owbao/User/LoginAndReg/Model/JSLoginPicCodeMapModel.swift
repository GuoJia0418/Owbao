//
//  JSLoginPicCodeMapModel.swift
//  Owbao
//
//  Created by 陆凤 on 2017/3/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLoginPicCodeMapModel: NSObject {
    var code:String? = ""
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
