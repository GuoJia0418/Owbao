//
//  UpdateAlertView.swift
//  Owbao
//
//  Created by Panda on 16/6/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

protocol UpdateAlertViewDelegate:NSObjectProtocol{
    //回调方法
    func updateButtonAction(_ buttonIndex:Int,alertView:UpdateAlertView)
}
class UpdateAlertView: UIView {

 
    var textView:UILabel?                //显示更新内容
    var bgView:UIView?                      //圆角背景
    var delegate:UpdateAlertViewDelegate!   //委托代理
    var isClickShutdown:Bool? = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
        
        //        self.createView()
        
    }
    convenience init(frame:CGRect, buttonTitles:[String], text:String){
        self.init(frame: frame)
        
        let showText = text.replacingOccurrences(of: "^", with: "\n")
        
        self.backgroundColor = PopView_BackgroundColor
        let bgWidth = 250 * SCREEN_WIDTH / 320
        
        
        let newSize = showText.getTextRectSize(UIFont.systemFont(ofSize: 12), size: CGSize(width: bgWidth - 10, height: 5555))
        var textLabelHidth = 80 * SCREEN_WIDTH / 320
        if newSize.height > 280 * SCREEN_WIDTH / 320 {
            textLabelHidth = 280 * SCREEN_WIDTH / 320
        } else if newSize.height > textLabelHidth {
            textLabelHidth = newSize.height
        }  else if newSize.height < 40 {
            textLabelHidth = 40
        } else {
            textLabelHidth = newSize.height
        }
        var bgHeight = textLabelHidth + 35 * SCREEN_WIDTH / 320 + 35
        if textLabelHidth < 80 * SCREEN_WIDTH / 320 {
            bgHeight = 80 * SCREEN_WIDTH / 320 + 35 * SCREEN_WIDTH / 320 + 35
        }
        self.bgView = UIView(frame: CGRect(x: (frame.size.width - bgWidth) / 2, y: (frame.size.height - bgHeight) / 2, width: bgWidth, height: bgHeight))
        self.bgView?.layer.masksToBounds = true
        self.bgView?.backgroundColor = UIColor.white
        self.bgView?.layer.cornerRadius = 8
        self.addSubview(self.bgView!)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: bgWidth, height: 20))
        titleLabel.text = "版本更新"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        self.bgView?.addSubview(titleLabel)
        
        let scView = UIScrollView(frame: CGRect(x: 5, y: (bgHeight - 35 - 35 * SCREEN_WIDTH / 320 - textLabelHidth) / 2 + 30, width: bgWidth - 10, height: textLabelHidth))
        
        self.textView = UILabel(frame: CGRect(x: 0, y: 0, width: bgWidth - 10, height: textLabelHidth))
        self.textView?.font = UIFont.systemFont(ofSize: 12)
        self.textView?.numberOfLines = 0
//        self.textView?.editable = false
        self.textView?.text = showText
        scView.addSubview(self.textView!)
        self.bgView?.addSubview(scView)
        
        if scView.frame.size.height < newSize.height {
            scView.contentSize = CGSize(width: 0, height: newSize.height)
            var newLabelFrame = self.textView?.frame
            newLabelFrame?.size.height = newSize.height
            self.textView?.frame = newLabelFrame!
        }
        if newSize.height <= 20 {
            self.textView?.textAlignment = NSTextAlignment.center
        } else {
            self.textView?.textAlignment = NSTextAlignment.left
        }
        
        
        if buttonTitles.count == 1 {
            let btn = UIButton(frame: CGRect(x: 5, y: bgHeight - 35 , width: bgWidth - 10, height: 32 ))
            btn.backgroundColor = DEFAULT_ORANGECOLOR
            self.bgView?.addSubview(btn)
          
            btn.addTarget(self, action: #selector(UpdateAlertView.btnAction(_:)), for: UIControlEvents.touchUpInside)
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitle(buttonTitles[0], for: UIControlState())
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 5
        } else {
            let leftBtn = UIButton(frame: CGRect(x: 0, y: bgHeight - 35, width: bgWidth / 2, height: 35 ))
            self.bgView?.addSubview(leftBtn)
            leftBtn.addTarget(self, action: #selector(UpdateAlertView.btnAction(_:)), for: UIControlEvents.touchUpInside)
            leftBtn.setTitle(buttonTitles[0], for: UIControlState())
            leftBtn.backgroundColor = DEFAULT_GRAYCOLOR
            leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            leftBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
            leftBtn.tag = 1
            
            let rightBtn = UIButton(frame: CGRect(x: bgWidth / 2, y: bgHeight - 35, width: bgWidth / 2, height: 35 ))
            self.bgView?.addSubview(rightBtn)
            rightBtn.addTarget(self, action: #selector(UpdateAlertView.btnAction(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.setTitle(buttonTitles[1], for: UIControlState())
            rightBtn.backgroundColor = DEFAULT_ORANGECOLOR
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            rightBtn.tag = 2
            
            let lineView = UIView(frame: CGRect(x: 0, y: bgHeight - 35, width: bgWidth, height: 1))
            lineView.backgroundColor = BORDER_GRAYCOLOR
            self.bgView?.addSubview(lineView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnAction(_ sender:UIButton){
        self.delegate.updateButtonAction(sender.tag, alertView: self)
    }
}
