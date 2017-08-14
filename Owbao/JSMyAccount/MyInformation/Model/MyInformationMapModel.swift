//
//  MyInformationMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyInformationMapModel: NSObject {
    
    var bankId: Int = 0
    var bankName: String = ""
    var bankNum: String = ""
    var idCards: String = ""
    var mobilephone: String = ""
    var realName: String = ""
    var realVerify: Int = 0
    var tpwdFlag: Int = 0
    
    var isFuiou: Int = 0 //
    var bankIdFuiou: Int = 0
    var bankMobileFuiou: String = ""
    var bankNameFuiou: String = ""
    var bankNumFuiou: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
