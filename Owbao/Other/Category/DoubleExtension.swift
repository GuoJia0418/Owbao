//
//  DoubleExtension.swift
//  Owbao
//
//  Created by mac on 16/3/5.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

extension Double {

    // trim .00
    func trimPointZeroZero() -> String {
//        let s = "1000.0"
//        s.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0"))
        return String(format: "%.2f", self).replacingOccurrences(of: ".00", with: "")
    }
    // 
    func thousandPoint() -> String {
        let nsf = NumberFormatter()
        nsf.numberStyle = .decimal
        
        return nsf.string(from: NSNumber(value: self))!
    }
}
