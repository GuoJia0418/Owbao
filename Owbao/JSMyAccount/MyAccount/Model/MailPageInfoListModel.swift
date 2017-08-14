//
//  MailPageInfoListModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MailPageInfoListModel: NSObject {
    var limit : Int = 0
    var offset : Int = 0

    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
