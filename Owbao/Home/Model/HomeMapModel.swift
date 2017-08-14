//
//  HomeMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class HomeMapModel: BaseModel {
    
    var investCount:Double = 0.00    //投资总额
    var regCount:Int = 0             //注册人数
    var banner = [HomeBannerModel]() //banner
    var newHand: HomeActivityAndNewHandModel?        //新手标信息
    var activity: HomeActivityAndNewHandModel?       //活动标信息
    var fuiouNewHand: HomeActivityAndNewHandModel?   //存管新手标
    var fuiouNewHandInvested: Int = 0                //是否投资过存管新手标 True=投过，false=没投过
    var fuiouNewHandLabel: String = ""   //存管新手标标签
    
    //app 2.0添加
    var newHandLabel: String = ""       //新手标标签
    
    
    //添加预约功能,2016年11月22日
    var isReservation: Bool = false //是否预约
    var realverify: Bool = false  //是否实名
    var prid: Int = 0 //预约规则id
    var name: String? //预约规则名称
    
    //新手标改变需求
    var isInvested: Bool = false //是否投资过Type=2的产品,是否投资过其他
    var newHandInvested: Bool = false //是否投资过新手标
    
    //新增的双旦活动
    var activityUrl: String = "" //活动结束后值会为空
    var activityImgUrl: String = "" //活动结束后值会为空
    var isNative: Bool = false //春节活动，和双旦活动用的用一个字段，春节是跳转原生的，双蛋跳转H5：true：跳转到原生，false：跳转到h5
    
    //新增年末豪礼-投即送
    var investSendPrize: InvestSendPrizeModel?
    
    var videoImgUrl1:String?  = ""          //视频图片
    var videoImgUrl2:String?  = ""
    var videoUrl1:String? = ""              //视频链接
    var videoUrl2:String? = ""

    var bannerDownPic1: String = ""     //banner下图片1
    var bannerDownTitle1: String = ""   //Banner下标题1
    var bannerDownDescribe1: String = "" //Banner下内容1
    var bannerDownUrl1: String = ""      //Banner下跳转链接1
    
    var bannerDownPic2: String = ""
    var bannerDownTitle2: String = ""
    var bannerDownDescribe2: String = ""
    var bannerDownUrl2: String = ""
    
    var preferredInvest:JSHomePreferredInvestModel?     //优选理财
    var operateData: JSHomeOperateDataModel?            //运营数据
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
       setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = HomeBannerModel(dict: dict)
                    banner.append(invest)
                }
            }
            return
        }
        
        //新手标功能下架
        if key == "newHand" {
            // 判断 value 是否是 一个 有效的 字典
//            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
//                newHand = HomeActivityAndNewHandModel(dict: dict)
//            }
            return
        }
        
        if key == "activity" { //这里注释掉: 因为有投资送礼就不能有活动标
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                activity = HomeActivityAndNewHandModel(dict: dict)
            }
            return
        }
        
        if key == "fuiouNewHand" { //这里注释掉: 因为有投资送礼就不能有活动标
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                fuiouNewHand = HomeActivityAndNewHandModel(dict: dict)
            }
            return
        }

        if key == "investSendPrize" {
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                investSendPrize = InvestSendPrizeModel(dict: dict)
            }
            return
        }
        
        if key == "preferredInvest" {
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                preferredInvest = JSHomePreferredInvestModel(dict: dict)
            }
            return
        }

        if key == "operateData" {
        
            if let dict = value as? [String: AnyObject] {
            
                //运营数据
                operateData = JSHomeOperateDataModel(dict:dict)
            }
            return 
        }
        
        super.setValue(value, forKey: key)
    }
    
}

class InvestSendPrizeModel: NSObject {
    
    var deadLine: Int = 0  //截止时期
    var rate: Double = 0.0  //年化率
    var name: String = ""  //名字
    var indexUrl: String = "" //活动跳转URL
    var activityRate: Double =  0.0    //新增的活动利率
    
    //首页显示需要用到的
    var investSendLabel: String = ""    //投即送标签
    var investSendPicUrl: String = ""   //投即送图片
    
    init(dict: [String: AnyObject]) {
        print(dict)
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
