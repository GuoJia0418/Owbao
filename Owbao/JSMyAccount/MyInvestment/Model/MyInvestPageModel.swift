//
//  MyInvestPageModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/9.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyInvestPageModel: NSObject {
    var pageInfo:MyInvestPageInfoModel?
    var rows = [MyInvestRowsModel]()
    var total:Int = 0
    var  totalPage:Int = 0
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
                pageInfo = MyInvestPageInfoModel(dict: dict)
            }
            return
        }
        if key == "rows" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = MyInvestRowsModel(dict: dict)
                    rows.append(invest)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
