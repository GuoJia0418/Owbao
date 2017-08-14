//
//  String+Encrypt.swift
//  hyq2.0
//
//  Created by feng on 15/12/2.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension String {
    func getTextRectSize(_ font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    
    mutating func numDisplayStandard(_ decimalPointType:NSInteger,isVerification:Bool){
        let numberFormatter = NumberFormatter()
        if decimalPointType == 0 {
            numberFormatter.maximum = 0
        } else if decimalPointType == 1 {
            numberFormatter.maximum = 2
            numberFormatter.minimum = 0
        } else {
            numberFormatter.minimum = 2
            numberFormatter.maximum = 2
        }
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.default
        var num = numberFormatter.number(from: self)
        if isVerification && num != nil{
            if num?.int32Value < 1 && num?.floatValue > 0.00 {
                num = NSNumber(value: 1 as Int32)
            }
            if num?.int32Value == 99 {
                num = NSNumber(value: 99 as Int32)
            }
        }
        self = numberFormatter.string(from: num!)!
    }
}
