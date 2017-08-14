//
//  JSInvitedModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvitedModel: JSBaseModel {
    var map: JSInvitedMapModel?
}

class JSInvitedMapModel: NSObject {
    var recommendedCount: Int = 0  //总共邀请几人
    var threePresentRewards: Double = 0.0 //三重礼奖金
    var threePresentUnclaimed: Double = 0.0 //三重礼未领奖金
    var nowRanking: Int = 0   //当前排行
    var firstAmount: Double = 0.0  //第一名年化

    var threePresentAfid: Int = 0 //三重礼活动id
    var firstInvestCount: Int = 0 //已首投好友数
    var reInvestCount: Int = 0    //已复投好友数
    
    var activity: JSInvestActivityModel?  //活动对象
    var firstInvestList = [JSInvestListModel]()  //首投
    var repeatInvestList = [JSRepeatInvestListModel]() //复投
    
    class func modelContainerPropertyGenericClass() -> NSDictionary {
        return NSDictionary(dictionary: ["firstInvestList": JSInvestListModel.classForCoder(),"repeatInvestList": JSRepeatInvestListModel.classForCoder()])
    }
}

class JSInvestListModel: NSObject {
    
    var status: Int = 0 //0 = 未领取 ，1 = 已领取
    var rebateAmount: Double = 0.0 //返利金额
    var investAmount: Double = 0.0 //投资金额
    var realname: String = ""     //姓名
}

class JSRepeatInvestListModel: NSObject {
    
    var status: Int = 0 //0 = 未领取 ，1 = 已领取
    var rebateAmount: Double = 0.0 //返利金额
    var investAmount: Double = 0.0 //投资金额
    var realname: String = ""     //姓名
    var investOrder: Int = 0 //投资次数
}

class JSInvestActivityModel: NSObject {
    var status: Int = 0 //1-进行中，2-已结束
    var startDate: Double = 0.0 //活动开始时间
    var endDate: Double = 0.0 //活动结束时间
    
    var appPutImg: String = ""     //app推送图片
    var appPutUrl: String = ""     //app推送链接地址
}


