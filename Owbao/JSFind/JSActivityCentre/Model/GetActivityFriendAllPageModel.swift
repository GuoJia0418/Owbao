//
//  GetActivityFriendAllPageModel.swift
//  Owbao
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetActivityFriendAllPageModel: NSObject {

    var pageInfo:GetActivityFriendAllPageInfoModel?
    var rows = [GetActivityFriendAllRowsModel]()
    var total:Int = 0
    var totalPage:Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "pageInfo" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                pageInfo = GetActivityFriendAllPageInfoModel(dict: dict)
            }
            return
        }
        if key == "rows" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let activityCenter = GetActivityFriendAllRowsModel(dict: dict)
                    rows.append(activityCenter)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
