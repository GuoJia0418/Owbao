//
//  InvestAppointmentModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/27.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestAppointmentModel: NSObject {
    var success: Bool = false
    var errorCode: String = ""
    var errorMsg: String = ""
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dictionary)
    }
}
