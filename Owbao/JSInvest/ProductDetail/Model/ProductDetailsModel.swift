//
//  ProductDetailsModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailsModel: JSBaseModel {
    
    var map: ProductDetailsMapModel?
    var size: [CGFloat] = [0,0,0,0]
    
    // MARK: - 构造函数
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = ProductDetailsMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    class func modelContainerPropertyGenericClass() -> NSDictionary {
        return NSDictionary(dictionary: ["map": ProductDetailsMapModel.classForCoder()])
    }
}
