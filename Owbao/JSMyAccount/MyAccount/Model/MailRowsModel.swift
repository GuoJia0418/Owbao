//
//  MailRowsModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MailRowsModel: NSObject {
    var addTime: Double = 0.00   //添加时间
    var content: String?
    var id: Int = 0
    var isRead: Int = 0         //是否阅读，0=未读，1=已读
    var title: String?
    var type: Int = 0
    var isOpen = false
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
