//
//  ExperienceInvestPopDisplayView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  弹出视图

import UIKit

class ExperienceInvestPopDisplayView: UIView {
    
    @IBOutlet weak var backgroundViewHeightConstrains: NSLayoutConstraint! //背景高度约束
    @IBOutlet weak var conformButton: UIButton!//确认按钮
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var indicatorButton: UIButton!
    
    var conformButtonCallback: (() -> ())? //取消行动
    @IBOutlet weak var experienceAmountLabel: UILabel!
    
    //取消行动
    @IBAction func cancelAction(_ sender: AnyObject) {
        ExperienceInvestPopDisplayView.animateRemoveFromSuperView(self)
    }
    
    //确定按钮
    @IBAction func conformAction(_ sender: AnyObject) {
        if self.conformButtonCallback != nil {
            self.conformButtonCallback!()
        }
    }
    
    //利用剩余体验金金额配置view
    func configureViewWithExperienceAmount(_ amount: Double) -> () {
        let amountString = "\(amount)"
        let attributedString = NSMutableAttributedString(string: "使用体验金支付,共计\(amount)元")
        //灰色字体
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, attributedString.string.length))
        //红色字体
        let string_1 = NSString(string: attributedString.string)
         attributedString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: string_1.range(of: amountString))
        self.experienceAmountLabel.attributedText = attributedString
    }
    
    override func awakeFromNib() {
        self.conformButton.layer.cornerRadius = 3
        self.conformButton.layer.masksToBounds = true
        let constain: CGFloat = 200.0
        self.backgroundViewHeightConstrains.constant = constain
        
        //修改图片的颜色
        self.conformButton.setBackgroundImage(Common.image(with: Global_yellow_deep), for: UIControlState())
        self.conformButton.setBackgroundImage(Common.image(with: UIColorFromRGB(108, green: 108, blue: 108)), for: UIControlState.disabled)
        
        self.backgroundColor = PopView_BackgroundColor
        self.indicatorButton.layer.cornerRadius = 18.0 / 2
        self.indicatorButton.layer.masksToBounds = true
        self.indicatorButton.layer.borderColor = Global_red.cgColor
        self.indicatorButton.layer.borderWidth = 1.0
    }
    
    /**
     * 视图初始化(动画般从下向上推出)
     *
     */
    class func animateWindowsAddSubView() -> (ExperienceInvestPopDisplayView) {
        //创建pushView
        let pushView = Bundle.main.loadNibNamed("ExperienceInvestPopDisplayView", owner: self, options: nil)?.last as? ExperienceInvestPopDisplayView
        let constain: CGFloat = 200.0
        
        pushView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pushView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: constain)
        UIApplication.shared.keyWindow?.addSubview(pushView!)
        
        //动画般显示pushView
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            pushView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - constain, width: SCREEN_WIDTH, height: constain);
        }) { finished -> () in
        }
        return pushView!
    }
    
    /**
     * 视图移除(动画般从上向下移除)
     */
    class func animateRemoveFromSuperView(_ pushView: ExperienceInvestPopDisplayView) -> () {
        let constain: CGFloat = 200.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            pushView.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH,height: constain);
            
        }) { finished ->() in
            
            pushView.removeFromSuperview()
        }
    }
}
