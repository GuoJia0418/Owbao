//
//  NewHeadMapModel.swift
//  Owbao
//
//  Created by Panda on 16/6/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class NewHeadMapModel: BaseModel {
    var isNewHead:Bool = false
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String){
        super.setValue(value, forKey: key)
    }
}
