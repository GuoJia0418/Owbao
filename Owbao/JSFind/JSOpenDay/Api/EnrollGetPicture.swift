//
//  EnrollGetPicture.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class EnrollGetPicture: BaseApi {
    
    var uid: Int = 0
    
    init(Uid: Int) {
        super.init()
        self.uid = Uid
    }
    
    override func requestUrl() -> String! {
        return EnrollGetPicture_Api
    }
    
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}
