//
//  JSNoviceTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/6.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSNoviceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel_xib_1: UILabel!
    
    @IBOutlet weak var bottomLabel_xib_2: UILabel! //第3个xib底部文案，需要数字需要增加红色
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) { //画图
        super.draw(rect)
        
        if self.titleLabel_xib_1 != nil { //表示xib
            self.drawCircleLine() //画出 o--o--o
        }
        
        //数字设置成红色
        if self.bottomLabel_xib_2 != nil {
            
            let rootString = self.bottomLabel_xib_2!.text
            let array = rootString?.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
            let array_oc = NSMutableArray(array: array!)
            array_oc.remove("")
            
            let attriString = NSMutableAttributedString(string: rootString!)
            
            for i in 0...array_oc.count - 1 {
                let string = array_oc[i] as! String
                let rangeString = NSString(string: string)
                let rangeString_root = NSString(string: rootString!)
                
                attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: rangeString_root.range(of: rangeString as String))
            }
            //小数没有查出来，需要进行特殊处理
            attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: NSRange(location: 2, length: 1))
            self.bottomLabel_xib_2.attributedText = attriString
        }
    }
    
    func drawCircleLine() -> () {
        
        //以下坐标根据设计图算出
        let context: CGContext = UIGraphicsGetCurrentContext()! //获取上下文
        context.setLineCap(.round)
        context.setLineWidth(1.0)               //设置线条宽度
        context.setStrokeColor(Global_red.cgColor) //设置颜色
        
//****** http://stackoverflow.com/questions/24110769/how-to-correctly-initialize-an-unsafepointer-in-swift
        var transform: UnsafePointer<CGAffineTransform>? = nil
        
        let myFont = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
        let myGlyph = CTFontGetGlyphWithName(myFont, "a" as CFString)
        var myTransform = CGAffineTransform.identity
        
        _ = withUnsafePointer(to: &myTransform) { (pointer: UnsafePointer<CGAffineTransform>) -> (CGPath) in
            transform = pointer
            return CTFontCreatePathForGlyph(myFont, myGlyph, pointer)!
        }
//************************************************************************************************//
        
        let path_1 = CGMutablePath()
      
//        path_1.addArc(center: CGPoint(x: 30, y: 65), radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true, transform: transform)
        path_1.addArc(center: CGPoint(x: 30, y: 65), radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true )
        path_1.move(to: CGPoint(x: 30, y: 70))
        path_1.addLine(to: CGPoint(x: 30, y: 132))
//        path_1.move(to: CGPoint(x: 30, y: 70), transform: transform)
//        path_1.addLine(to: CGPoint(x: 30, y: 132), transform: transform)
        
//        CGPathAddArc(path_1, transform!, 30, 65, 5, 0, CGFloat(2 * M_PI), true) //画第1个圆
//        CGPathMoveToPoint(path_1, transform!, 30, 70)
//        CGPathAddLineToPoint(path_1, transform!, 30, 132)        //画第1条红色线
        context.addPath(path_1)
        
        let path_2 = CGMutablePath()
        path_2.addArc(center: CGPoint(x: 30, y: 137), radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        path_2.move(to: CGPoint(x: 30, y: 142))
        path_2.addLine(to: CGPoint(x: 30, y: 203))
        
//        path_2.addArc(center: CGPoint(x: 30, y: 137), radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true, transform: transform)
//        path_2.move(to: CGPoint(x: 30, y: 142), transform: transform)
//        path_2.addLine(to: CGPoint(x: 30, y: 203), transform: transform)
        
        
        
        
//        CGPathAddArc(path_2, transform!, 30, 137, 5, 0, CGFloat(2 * M_PI), true) //画第2个圆
//        CGPathMoveToPoint(path_2, transform!, 30, 142)
//        CGPathAddLineToPoint(path_2, transform!, 30, 203)             //画第2条红色线
        context.addPath(path_2)
        
        let path_3 = CGMutablePath() //第3个画圆
        path_3.addArc(center: CGPoint(x: 30, y: 207), radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
//        path_2.addArc(center: CGPoint(x: 30, y: 207), radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true, transform: transform)
        
//        CGPathAddArc(path_3, transform!, 30, 207, 5, 0, CGFloat(2 * M_PI), true)
        context.addPath(path_3)
        
        context.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    class func cellHeight(_ section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 247.0
            
        } else if section == 1 {
            
            return 317.0
//            return 260.0
            
        } else if section == 2 {
            //407:194为图片比例
            return 362
            
        } else if section == 3 {
            
            return 247.0
        }
        
        return 0.0
    }
}
