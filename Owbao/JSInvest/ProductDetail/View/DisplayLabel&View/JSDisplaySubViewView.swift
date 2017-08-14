//
//  JSDisplaySubViewView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/6/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  封装的显示若干JSWillDisplaySubView的视图，要保证所有的JSWillDisplaySubView宽度加起来不能超过self.width不然可能会报错

import UIKit

class JSDisplaySubViewView: UIView {
    
    //用模型创建JSWillDisplaySubView
    func reloadViewWith(modelArray: [TitleModel]) {
        
        self.titleModelArray = modelArray
        
        for view in self.subviews {
            if view.isKind(of: JSWillDisplaySubView.classForCoder()) {
                view.removeFromSuperview()
            }
        }
        
        //如果数组为空则返回
        if modelArray.count == 0 {
            return
        }
        
        //创建3个子view加入self中
        for i in 0...modelArray.count - 1 {
            
            let subView = JSWillDisplaySubView(frame: CGRect(x: 0, y: (self.height - 15) / 2, width: JSWillDisplaySubView.getWidth(model: modelArray[i], labelFont: 12, height: 15), height: 15)) //subView的高度默认写死15像素
            subView.reloadView(model: modelArray[i])
            subView.backgroundColor = UIColor.clear
            self.addSubview(subView)
            self.labelArray.append(subView)
        }
        
        //刷新坐标
        self.layoutIfNeeded()
    }
    
    fileprivate var labelArray = [JSWillDisplaySubView]()
    fileprivate var titleModelArray: [TitleModel]?
    
    //设置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var titleWidth: CGFloat = 0
        
        if self.labelArray.count > 0 { //表示存在需要显示的subView
            
            for i in 0...self.labelArray.count - 1 {
                let view = self.labelArray[i]
                titleWidth += view.width
            }
            
            if titleWidth != 0 { //表示有subview
                
                //通过若干subView算出每个subView之间的间隔
                let margin: CGFloat = (self.width - titleWidth) / CGFloat(self.labelArray.count + 1)
                
                for i in 0...self.labelArray.count - 1 {
                    
                    let view = self.labelArray[i]
                    
                    //设置每一个subView的X、Y坐标，width和高度不用设置，初始化时候给定了
                    if i == 0 {
                        view.x = margin
                    } else {
                        let leftView = self.labelArray[i - 1]
                        view.x = leftView.frame.maxX + margin
                    }
                    view.y = (self.height - 15) / 2
                }
            }
            
        }
    }
}

//被显示的suBView
class JSWillDisplaySubView: UIView {
    
    var labelFont: CGFloat = 12   //label字体大小默认是12
    var labelTextColor: UIColor = UIColor.white //label字体和边框的颜色
    var titleModel: TitleModel?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "js_product_detail_right"))
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.labelFont)
        label.textColor = self.labelTextColor
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    
    //显示title，刷新子view的frame
    func reloadView(model: TitleModel) {
        self.titleModel = model
        
        for view in self.subviews {
            if view.isKind(of: UIImageView.classForCoder()) {
                view.removeFromSuperview()
            }
            if view.isKind(of: UILabel.classForCoder()) {
                view.removeFromSuperview()
            }
        }
        
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.titleLabel.text = model.title
        self.layoutIfNeeded()
    }
    
    //刷新imageView和label的坐标
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.height, height: self.height)
        
        let width = (self.titleModel?.title.getTextRectSize(UIFont.systemFont(ofSize: self.labelFont), size: CGSize(width: 3000, height: self.height)).size.width)!
        self.titleLabel.frame = CGRect(x: self.imageView.frame.maxX + 2, y: 0, width: width, height: self.height)
    }
    
    //类方法，算出应该self具有的宽度
    class func getWidth(model: TitleModel,
                        labelFont: CGFloat,
                        height: CGFloat) -> CGFloat {
        let width = model.title.getTextRectSize(UIFont.systemFont(ofSize: labelFont), size: CGSize(width: 3000, height: height)).size.width
        return width + 2 + height
    }

    //类方法,写死self高度为15
    class func getHeight() -> CGFloat {
        return 15
    }
}
