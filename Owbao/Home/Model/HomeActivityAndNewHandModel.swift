//
//  HomeActivityModel.swift
//  Owbao
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class HomeActivityAndNewHandModel: BaseModel {

    var rate: Double = 0.00           //产品利率
    //    var amoubt:Double = 0.00
    var deadline: Int = 0            //投资期限
    var leastaAmount: Double = 0.00   //起投金额
    var maxAmount: Double = 0.00      //限投金额
    var id: Int = 0
    var simpleName: String?
    var fullName: String?
    var atid: Int = 0                 //活动标
    var type: Int = 0
    var pert: Double = 0.00 //募集的百分比
    var status: Int = 0 //募集状态
    var activityRate: Double = 0.00   //新手标增加的rate
    
    //2.0改版首页新增的字段
    var iphonePicUrl: String = ""        //首页展示图片
    var iphoneDeatilUrl: String = ""     //Iphone7跳转链接
    var iphoneLabel:String? = ""         //IPhone7标签
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
