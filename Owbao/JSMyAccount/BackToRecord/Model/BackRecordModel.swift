//
//  BackRecordModel.swift
//  Owbao
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BackRecordModel: NSObject {

    //回款时间
    var date: String?
    var shouldSum: Double = 0
    var status: Int = 0
    var index: Int = 0 //第几期
    var shouldPrincipal: Int = 0 // 应还本金
    var residualPrincipal: Int = 0 // 剩余本金（0： 最后一期 index期收益+本金：shouldSum ）

    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
