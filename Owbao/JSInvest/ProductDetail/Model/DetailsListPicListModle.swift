//
//  DetailsListPicListModle.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class DetailsListPicListModle: NSObject {
    var bigUrl: String?    //图片链接
    var name: String?      //图片名称
    var showShort: Int = 0 //显示顺序
    var type: Int = 0      //0-企业资料，1-贷款合同
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
