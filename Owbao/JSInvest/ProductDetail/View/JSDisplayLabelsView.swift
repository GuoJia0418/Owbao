//
//  JSDisplayLabelsView.swift
//  JSApp
//
//  Created by 一言难尽 on 2017/4/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  封装的展示标签的视图,见投资详情头部视图(label从左向右依次排列的)

import UIKit
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


class TitleModel: NSObject {
    var title = ""
}

class JSDisplayLabelsView: UIView {
    
    var labelFont: CGFloat = 13   //label字体大小默认是13
    var labelTextColor: UIColor = DEFAULT_ORANGECOLOR   //label字体和边框的颜色
    var margin: CGFloat = 20        //每个label之间的间隔
    var margin_title: CGFloat = 5   //label中title距离label左右的间距,默认是5
    
    fileprivate var labelArray = [UILabel]()
    fileprivate var titleModelArray: [TitleModel]?
    
    //开始设置
    func configureView(_ titleArray: [TitleModel]?) {
        
        self.labelArray.removeAll()
        self.removeAllSubViews()
        self.titleModelArray = titleArray
        
        if titleArray != nil && titleArray?.count > 0 {
            
            for i in 0...(titleArray?.count)! - 1 { //便利
                
                let model = titleArray![i]
                
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: self.labelFont)
                label.textColor = self.labelTextColor
                label.textAlignment = .center
                label.text = model.title
                label.layer.cornerRadius = 2.0
                label.layer.masksToBounds = true
                label.layer.borderColor = labelTextColor.cgColor
                label.layer.borderWidth = 1.0
                self.addSubview(label)
                
                //label放进数组里
                labelArray.append(label)
            }
        }
    }
    
    //给定最大的显示宽度，去隐藏一些UILabel
    func layoutSubTitleLabelWithDisplayWidth(_ displayWidth: CGFloat,viewHeight: CGFloat) {
        
        let labelsViewWidth = JSDisplayLabelsView.getWidth(self.titleModelArray, margin: self.margin, labelFont: self.labelFont, viewHeight: viewHeight, margin_title: self.margin_title)
        
        if displayWidth < labelsViewWidth { //表示labelView超过了最大可显示宽度，需要隐藏一些label
            
            var width: CGFloat = 0
            
            if self.titleModelArray != nil && self.titleModelArray?.count > 0 {

                for i in 0...self.titleModelArray!.count - 1 {  //开始遍历数组，算出那些label超过了
                    
                    let model = self.titleModelArray![i] //title模型
                    
                    let titleWidth = model.title.getTextRectSize(UIFont.systemFont(ofSize: self.labelFont), size: CGSize(width: 3000, height: viewHeight)).size.width
                    width += titleWidth + 2 * margin_title + self.margin
                    
                    if width > displayWidth { //后面的label需要隐藏
                        
                        for j in i...self.titleModelArray!.count - 1 {
                            
                            let label = self.labelArray[j]
                            label.isHidden = true
                        }
                        
                        return
                    }
                }
            }
        }
    }
    
    /**
     *  算出JSDisplayLabelsView的宽度
     *
     *  titleArray:    需要显示的TitleModel
     *  margin：       标签之间的间距
     *  labelFont:     label的字体
     *  viewHeight:    JSDisplayLabelsView的高度
     *  margin_title:  label中title距离label左右的间距,默认是5
     *  @return        JSDisplayLabelsView的宽度
     */
    
    class func getWidth(_ titleArray: [TitleModel]?,margin: CGFloat,labelFont: CGFloat,viewHeight: CGFloat,margin_title: CGFloat) -> CGFloat {
        
        if titleArray != nil && titleArray?.count > 0 {
            
            var width: CGFloat = CGFloat((titleArray?.count)! - 1) * margin
            
            for i in 0...titleArray!.count - 1 {
                
                let model = titleArray![i]
                
                let titleWidth = model.title.getTextRectSize(UIFont.systemFont(ofSize: labelFont), size: CGSize(width: 3000, height: viewHeight)).size.width
                width += titleWidth + 2 * margin_title
            }
            return width
        }
        
        return 0
    }
    
    
    //设置子label的坐标，label从左向右依次排列的
    override func layoutSubviews() {
        
        for i in 0...self.labelArray.count - 1 {
            
            let label = self.labelArray[i]
            let model = self.titleModelArray![i]

            let titleWidth = model.title.getTextRectSize(UIFont.systemFont(ofSize: self.labelFont), size: CGSize(width: 3000, height: self.height)).size.width
            
            if i == 0 {
                
                label.frame = CGRect(x: 0, y: 0, width: titleWidth + 2 * self.margin_title, height: self.height) //+10文字左右各有5像素间距
                
            }  else { //取出左边的label方便进行设置坐标
              
                let label_left = self.labelArray[i-1]
                label.frame = CGRect(x: label_left.frame.maxX + margin, y: 0, width: titleWidth + 2 * self.margin_title, height: self.height)
            }
            
        }
    }
}
