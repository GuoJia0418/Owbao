//
//  JSInvitedNoDataView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  显示没数据的imageView、label会居中，上下顶格

import UIKit

open class JSNoDataView: UIView {
    
    open var imageWHScale: Double = 1.0 // 默认是正方形
    open var imageViewRelativeScale: Double = 4.0 //默认是1/4倍
    
    open var displayImageView: UIImageView = { //显示的view
        let imageView = UIImageView()
        imageView.image = UIImage(named: "暂无内容.png")
        return imageView
    }()
    
    open var displayLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无内容"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    //创建视图
    open class func getNoDataView(_ frame: CGRect) -> JSNoDataView{
        let view = JSNoDataView(frame: frame)
        view.addSubview(view.displayImageView)
        view.addSubview(view.displayLabel)
        return view
    }
    
    //imageWHScale：图片的宽:高 imageViewRelativeScale:显示图片的view的宽度相对于父视图宽度比例 width:父视图的宽
    open class func getSuitHeight(_ imageWHScale: Double,imageViewRelativeScale: Double,width: CGFloat) -> CGFloat {
         let w  =  Double(width) / imageViewRelativeScale
       return CGFloat(w / imageWHScale + 30)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 20.0
        let Width =  self.frame.size.width
        
        let imageViewW  = Width / CGFloat(self.imageViewRelativeScale)
        let imageViewH  = imageViewW / CGFloat(self.imageWHScale) //默认是正方形
        
        self.displayImageView.frame = CGRect(x: Width / 2.0 - imageViewW / 2.0,y: 0.0,width: imageViewW,height: imageViewH)
        //高度默认是20
        self.displayLabel.frame = CGRect(x: 0,y: self.displayImageView.frame.maxY + CGFloat(margin) / 2.0 , width: Width, height: 20)
    }
}
