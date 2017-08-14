//
//  UrgentnoticeMapModel.swift
//  Owbao
//
//  Created by Panda on 16/4/27.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UrgentnoticeMapModel: NSObject {
    var urgentNotice = [UrgentNoticeModel]()
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "urgentNotice" {
//            // 判断 value 是否是 一个 有效的 字典
//            if let dict = value as? [String: AnyObject] {
//                
//                urgentNotice = UrgentNoticeModel(dict: dict)
//            }
//            return
            if let arr = value as? [[String: AnyObject]]
            {
                for dict in arr {
                    let notice = UrgentNoticeModel(dict: dict)
                    urgentNotice.append(notice)
                }
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
