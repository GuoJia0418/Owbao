//
//  GetActivityFriendAllRowsModel.swift
//  Owbao
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetActivityFriendAllRowsModel: NSObject {

//    var name: String?           //活动名称
//    var startDate:Double = 0.00 //奖励周期开始时间
//    var endDate:Double = 0.00   //奖励周期结束时间
//    var status:Int = 0          //活动状态:1：进行中2：已结束
    var periods:Int = 0           //期数
//    var id: Int = 0             //活动id
    
    var activityDate:String? = ""       //活动时间
    var appPic:String? = ""             //活动图片地址
    var title:String? = ""              //活动名称
    var appUrl:String? = ""                 //活动链接地址
    var id: Int = 0                     //活动id
    var status:Int = 0                  //活动状态:1：进行中2：已结束
    var isTop:Int = 0                   //是否置顶

    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
