//
//  ProductDetailsCouponListModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/19.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailsCouponListModel: NSObject {
    var name: String?
    var id: Int = 0
    var enableAmount: Double = 0
    var amount: Double = 0.00
    var type: Int = 3
    var source: Int = 1
    var multiple: Double = 1.0
    
    var pid: Int = 0
    var raisedRates: Double = 0.0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
