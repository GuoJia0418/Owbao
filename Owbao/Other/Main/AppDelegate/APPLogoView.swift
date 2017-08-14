//
//  APPLogoView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/17.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  程序启动时候，logo视图

import UIKit

class APPLogoView: UIView {
    
    /** 需要显示的imageView */
    let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    /** 初始化程序启动视图 */
    class func configureAPPLogoView(_ superView: UIView) -> APPLogoView {
        //创建视图
        let view = APPLogoView(frame: superView.frame)
        view.addSubview(view.imageView)
        superView.addSubview(view)
        
        if IS_IPHONE5 {
            view.imageView.image = UIImage(named: "iPhone5")
        } else if IS_IPHONE6 {
            view.imageView.image = UIImage(named: "iPhone6")
        } else if (IS_IPHONE6_PLUS) {
            view.imageView.image = UIImage(named: "iPhone6Plus")
        } else {
            view.imageView.image = UIImage(named: "iPhone5")
        }
        return view
     }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.frame
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
