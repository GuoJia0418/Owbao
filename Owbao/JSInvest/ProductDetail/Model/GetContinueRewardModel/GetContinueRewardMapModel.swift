//
//  GetContinueRewardMapModel.swift
//  Owbao
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

open class GetContinueRewardMapModel: NSObject {

    var parcelList = [GetContinueRewardParcelListModel]()
    var rewardList = [GetContinueRewardListModel]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override open func setValue(_ value: Any?, forKey key: String) {
        if key == "parcelList" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = GetContinueRewardParcelListModel(dict: dict)
                    parcelList.append(invest)
                }
            }
            return
        }
        if key == "rewardList" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = GetContinueRewardListModel(dict: dict)
                    rewardList.append(invest)
                }
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
