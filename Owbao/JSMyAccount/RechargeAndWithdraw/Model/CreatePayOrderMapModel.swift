//
//  CreatePayOrderMapModel.swift
//  Owbao
//
//  Created by Panda on 16/5/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class CreatePayOrderMapModel: BaseModel {
    var payNum:String?
    var bankMobilePhone:String? = ""   //银行预留手机号
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
