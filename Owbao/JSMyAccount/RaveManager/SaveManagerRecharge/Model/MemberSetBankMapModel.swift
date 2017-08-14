//
//  MemberSetBankMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MemberSetBankMapModel: NSObject {
    var bankId:Double = 0.00
    var realName:String?
    var idCards:String?
    var bankNum:String?
    var bankName:String?
    var bankCode:Int = 0
    var isCps:Int = 0           //0：非s用户，1：s用户
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
