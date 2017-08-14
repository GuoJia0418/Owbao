//
//  DetailsListMapModle.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class DetailsListMapModle: NSObject {
    
    var investList = [DetailsListInvestListModle]()
    var picList = [DetailsListPicListModle]()
    
    var projectList = [String]()
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "investList" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = DetailsListInvestListModle(dict: dict)
                    investList.append(invest)
                }
            }
            return
        }
        if key == "picList" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = DetailsListPicListModle(dict: dict)
                    picList.append(invest)
                }
            }
            return
        }
        if key == "projectList" {
            if let arr = value as? [String] {
                // 然后开始遍历
                for str in arr {
//                    let invest = DetailsListPicListModle(dict: dict)
//                    picList.append(invest)
                    projectList.append(str)
                    
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
