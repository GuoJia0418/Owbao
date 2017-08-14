//
//  InvestmentRowModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestmentPageModel: NSObject {
    var total:Int = 0
    var totalPage:Int = 0
    var rows = [InvestmentRowModel]()
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        self.setModelWithDictionary(dict)
    }
    
    //需要重新写个方法,吧上一级的字段移到下一级
    func setModelWithDictionary(_ dict: [String: AnyObject]) -> () {
        total = (dict["total"] as? Int)!
        totalPage = dict["totalPage"] as! Int
        
        if let arr = dict["rows"] as? [[String: AnyObject]] {
            // 然后开始遍历
            for dictionary in arr {
                let invest = InvestmentRowModel(dict: dictionary)
                invest.pageSize = dict["pageSize"] as! Int
                invest.pageOn = dict["pageOn"] as! Int
                rows.append(invest)
            }
        }
    }
    
//    override func setValue(value: AnyObject?, forKey key: String) {
//        if key == "rows" {
//            // 判断 value 是否是一个有效的数组
//            if let arr = value as? [[String: AnyObject]] {
//                // 然后开始遍历
//                for dict in arr {
//                    let invest = InvestmentRowModel(dict: dict)
//                    rows.append(invest)
//                }
//            }
//            return
//        }
//        super.setValue(value, forKey: key)
//    }
    
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
//        
//    }
}
