//
//  NewHeadExpireMapModel.swift
//  Owbao
//
//  Created by Panda on 16/7/11.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class NewHeadExpireMapModel: NSObject {
    
    //弹窗路径 url为空不是首投，不为空首投
    var url :String?
   
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
       super.setValue(value, forKey: key)
    }
}
