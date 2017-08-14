//
//  UIImageExtension.swift
//  Owbao
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

extension  UIImage {
    
    /// 创建一个`点`的图像
    ///
    /// - parameter color: 图像颜色
    ///
    /// - returns: 当前分辨率对应的单点图像
    /// 提示：分类函数中，除了便利构造函数，其他都建议使用 前缀_，通常 2~3 小写英文字母
    /// 例如：sdWebImage sd_setImageWithURL:
    /// AFNetworking setImageWithURL:
    /// 便利构造函数，需要调用 self.init() 创建本类对象
    class func dr_singleDotImage(_ color: UIColor) -> UIImage {
        
        // 1. 开启上下文，需要注意 scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, UIScreen.main.scale)
        
        // 2. 画图，填个颜色
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        // 3. 从上下文获取图像
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 5. 返回图像
        return result!
    }
    
    /// 异步绘制图像
    func dr_asyncDrawImage(_ size: CGSize,
                           isCorner: Bool = false,
                           backColor: UIColor? = UIColor.white,
                           finished: @escaping (_ image: UIImage)->()) {
        
        // 异步绘制图像，可以在子线程进行，因为没有更新 UI
        //        DispatchQueue.global(priority: 0).async { () -> Void in
        
        DispatchQueue.global().async {
            // let start = CACurrentMediaTime()
            
            // 如果指定了背景颜色，就不透明
            UIGraphicsBeginImageContextWithOptions(size, backColor != nil, UIScreen.main.scale)
            
            let rect = CGRect(origin: CGPoint.zero, size: size)
            // 设置填充颜色
            backColor?.setFill()
            UIRectFill(rect)
            
            // 设置圆角 - 使用路径裁切，注意：写设置裁切路径，再绘制图像
            if isCorner {
                let path = UIBezierPath(ovalIn: rect)
                
                // 添加裁切路径 - 后续的绘制，都会被此路径裁切掉
                path.addClip()
            }
            
            // 绘制图像
            self.draw(in: rect)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            // print("执行时间 \(CACurrentMediaTime() - start)")
            
            // 主线程更新 UI，提示：有的时候异步也能更新 UI，但是会非常慢！
            DispatchQueue.main.async {
                finished(result!)
            }
        }
    }
    /// 将当前图片缩放到指定宽度
    ///
    /// - parameter width: 指定宽度
    ///
    /// - returns: UIImage，如果本身比指定的宽度小，直接返回
    func dr_scaleImageToWidth(_ width: CGFloat) -> UIImage {
        
        // 提示: 不要使用比例, 如果所有图片都按照指定比例来缩放, 图片太小就看不见了
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        draw(in: CGRect(origin: CGPoint.zero, size: s))
        
        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return result!
    }
    
    func resize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    /// Resizes an image instance to fit inside a constraining size while keeping the aspect ratio.
    ///
    /// - parameter size: The constraining size of the image.
    /// - returns: A new resized image instance.
    
}
