//
//  JSFuiouResetTradePwdApi.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/25.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSFuiouResetTradePwdApi: BaseApi {
    var busi_tp: String = ""
    var uid: Int = 0
    
    init(Uid: Int,Busi_tp: String) {
        super.init()
        self.uid = Uid
        self.busi_tp = Busi_tp
    }
    
    override func requestUrl() -> String! {
        return ResetFuiouTradePwd_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid,"busi_tp": busi_tp]
    }
}
