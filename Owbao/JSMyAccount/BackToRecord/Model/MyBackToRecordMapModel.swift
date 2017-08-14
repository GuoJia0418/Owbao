//
//  MyBackToRecordResultModel.swift
//  Owbao
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyBackToRecordMapModel: NSObject
{
    
    var backRecordModel = [BackRecordModel]()
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String)
    {
        
        if key == "result"
        {
            if let arr = value as? [[String: AnyObject]]
            {
                for dict in arr {
                    let notice = BackRecordModel(dict: dict)
                    backRecordModel.append(notice)
                }
            }
            return

        }
        super.setValue(value, forKey: key)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
