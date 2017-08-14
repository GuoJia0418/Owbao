//
//  UILabelExtension.swift
//  Owbao
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

extension UILabel {
    
    /// 创建 UILabel
    ///
    /// - parameter text:      text
    /// - parameter fontSize:  fontSize，默认 14
    /// - parameter color:     color，默认 darkGrayColor
    /// - parameter alignment: alignment，默认左对齐
    ///
    /// - returns: UILabel
    convenience init(dr_text text: String,
                fontSize: CGFloat = 14,
                color: UIColor = UIColor.darkGray,
                alignment: NSTextAlignment = .left) {
        
        self.init()
        
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textAlignment = alignment
        
        self.numberOfLines = 0
        
        // 自动调整大小
        sizeToFit()
    }
    
//    class func boundingRectWithInitSize(size: CGSize) -> CGRect {
//        self.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        let rect: CGRect = self.text.
//        
//    }
//    
    
}
