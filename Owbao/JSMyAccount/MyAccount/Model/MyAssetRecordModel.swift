//
//  MyAssetRecordModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyAssetRecordModel: NSObject {
    var map :MyAssetMapModel?
    var success:Bool = false
    var errorCode:String?
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = MyAssetMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
