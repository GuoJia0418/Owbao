//
//  RechargeHomeSysArticleListModel.swift
//  Owbao
//
//  Created by Feng Lu on 2016/12/27.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class RechargeHomeSysArticleListModel: NSObject {
    
    var bankId:Int = 0
    var summaryContents:String? = ""
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
