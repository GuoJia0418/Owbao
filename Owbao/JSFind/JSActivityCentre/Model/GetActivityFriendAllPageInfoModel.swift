//
//  GetActivityFriendAllPageInfoModel.swift
//  Owbao
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class GetActivityFriendAllPageInfoModel: NSObject {

    var limit:Int = 0
    var offset:Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
