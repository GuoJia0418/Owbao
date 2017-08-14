//
//  JSRechargeModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSRechargeModel: JSBaseModel {
    var map: JSRechargeMapModel?
}

class JSRechargeMapModel: NSObject {
    
    var confirmTime: Double = 0.00
    var paySuccessTime: Double = 0.00
    var payTime: Double = 0.00
}
