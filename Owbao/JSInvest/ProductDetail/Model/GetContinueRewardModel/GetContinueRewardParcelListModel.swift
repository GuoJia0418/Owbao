//
//  GetContinueRewardParcelListModel.swift
//  Owbao
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

open class GetContinueRewardParcelListModel: NSObject {

    var amount:Double = 0.00  //领取金额
    var mobilePhone:String?   //手机号

    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
