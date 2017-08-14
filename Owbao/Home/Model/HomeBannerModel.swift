//
//  HomeBannerModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class HomeBannerModel: BaseModel {
    
    var imgUrl: String = ""    //图片地址
    var location: String = ""  //图片跳转地址
    var title: String = ""     //标题
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
