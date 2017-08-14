//
//  InvitedModel.swift
//  Owbao
//
//  Created by GuoJia on 16/11/25.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedModel: NSObject {
    
    var isPut: Int = 0                //0不推送，1推送
    var total: Int = 0                //总数
    var banner: String = ""               //广告URL
    var jumpUrl: String = ""              //跳URL
    var content: String = ""              //显示内容
    var investors: Int = 0            //总投资人数
    var endTime: Double = 0             //活动结束时间
    var startTime: Double = 0             //活动开始时间
    var rows = NSMutableArray()
    
    //app 2.0
    var unclaimed: Double = 0.00            //获取最新活动未领取奖励金额
    var afid:Int = 0                        //好友推荐活动id
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "page" {
            // 判断 value

            if  ((value as? NSDictionary) != nil) {
                // 然后开始遍历
                let valueDict = value as? NSDictionary
                if let array = valueDict!["rows"] as? [[String: AnyObject]] {
                    for dict in array {
                        let invest = InvitedRowsModel(dict: dict)
                        rows.add(invest)
                    }
                }
                
//            if  ((value as? NSDictionary) != nil) {
//                // 然后开始遍历
//                if let array = value!["rows"] as? [[String: AnyObject]] {
//                    for dict in array {
//                        let invest = InvitedRowsModel(dict: dict)
//                        rows.add(invest)
//                    }
//                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
