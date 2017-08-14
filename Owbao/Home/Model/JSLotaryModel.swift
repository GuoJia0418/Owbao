//
//  JSLotaryModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/25.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLotaryModel: BaseModel {

    var success :Bool = false
    var errorCode:String? = ""
    var errorMsg:String? = ""
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
