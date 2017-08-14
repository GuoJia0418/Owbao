//
//  UIColorExtension.swift
//  Owbao
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation


extension UIColor {
    
    /// 使用十六进制数值转换成对应颜色
    ///
    /// - parameter hex: 十六进制整数 0xFFC00F =>
    /// 1111 1111 1101 0000 0000 1111
    /// 0000 0000 1111 1111 0000 0000
    /// 0000 0000 0000 0000 1111 1111
    ///
    /// - returns: UIColor
    class func dr_colorWithHex(_ hex: UInt32) -> UIColor {
        
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = (hex & 0x0000FF)
        
        return dr_color(r, g: g, b: b)
    }
    
    /// 使用 r / g / b 的整数生成颜色
    ///
    /// - parameter r: r
    /// - parameter g: g
    /// - parameter b: b
    ///
    /// - returns: UIColor
    class func dr_color(_ r: UInt32, g: UInt32, b: UInt32) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    /// 生成随机颜色
    ///
    /// - returns: UIColor
    class func dr_randomColor() -> UIColor {
        
        
        return dr_color(UInt32(arc4random() % 256), g: UInt32(arc4random() % 256), b: UInt32(arc4random() % 256))
        
        //修改过的
        //return dr_color(UInt32(random() % 256), g: UInt32(random() % 256), b: UInt32(random() % 256))
    }
}
