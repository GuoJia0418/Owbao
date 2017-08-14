//
//  ExtendInfosModel.swift
//  Owbao
//
//  Created by Panda on 16/6/15.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ExtendInfosModel: NSObject {
    var content:String?     //内容
    var title:String?       //标题
    var isShow:Bool = true

    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
