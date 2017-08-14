//
//  PrizePersonListModel.swift
//  Owbao
//
//  Created by Apple on 16/10/21.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PrizePersonListModel: NSObject {

    var prizeCode:   String?    //中奖号码
    var prizeMobile: String?    //中奖人
    var prizeImgUrl: String?    //中奖人照片
    var prizeContent:String?    //中奖人介绍
    var activityPeriods: Int = 0  //第几期中奖
    var prizeHeadPhoto: String?   //中奖人头像
    var prizeVideoLink:String?    //中奖者视频链接
    var pcDetailImg:String?       //产品详情图片（URL）
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
