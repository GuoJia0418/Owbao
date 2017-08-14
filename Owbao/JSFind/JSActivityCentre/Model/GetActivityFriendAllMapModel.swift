//
//  GetActivityFriendAllMapModel.swift
//  Owbao
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetActivityFriendAllMapModel: NSObject {

//    var pageInfo:GetActivityFriendAllPageModel?
    var Page:GetActivityFriendAllPageModel?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "Page" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                Page = GetActivityFriendAllPageModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
