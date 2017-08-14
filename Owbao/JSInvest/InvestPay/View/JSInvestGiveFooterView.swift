//
//  JSInvestGiveFooterView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/8.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestGiveFooterView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.comformButton != nil {
            self.comformButton.layer.cornerRadius = 5
            self.comformButton.layer.masksToBounds = true
        }
        
        //自动设置约束
        let contrains = (SCREEN_WIDTH - 135 * 2) / 6
        
        if self.rightButton != nil {
            self.rightButton.layer.cornerRadius = 4
            self.rightButton.layer.masksToBounds = true
            
            self.rightButtonLeftConstains.constant = contrains
        }
        
        if self.leftButton != nil {
            self.leftButton.layer.cornerRadius = 4
            self.leftButton.layer.masksToBounds = true
            self.leftButton.layer.borderColor = UIColor.darkGray.cgColor
            self.leftButton.layer.borderWidth = 1.0
            
            self.leftButtonTraillingConstrains.constant = contrains
        }
    }
    
    //**************************** 第一个xib *********************//
    @IBOutlet weak var comformButton: UIButton! //确定按钮
    var conformClickCallback: (() -> ())?
    
    @IBAction func conformButtonClickAction(_ sender: AnyObject) {
        if self.conformClickCallback != nil {
            self.conformClickCallback!()
        }
    }
    
    func configureFooterViewStatus(_ isOpen: Bool) -> () {
        
        if isOpen == true { //打开的
            self.comformButton.backgroundColor = UIColorFromRGB(233, green: 48, blue: 56)
            self.comformButton.isEnabled = true
        } else {
            self.comformButton.backgroundColor = UIColorFromRGB(181, green: 181, blue: 181)
            self.comformButton.isEnabled = false
        }
    }
    

    
    class func footerViewHeight_xib_0() -> CGFloat {
        return 125.0
    }
    
    //**************************** 第二个xib *********************//
    @IBOutlet weak var rightButtonLeftConstains: NSLayoutConstraint!
    @IBOutlet weak var leftButtonTraillingConstrains: NSLayoutConstraint!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    var leftButtonCallback:(() -> ())?
    var rightButtonCallback:(() -> ())?
    
    
    //左边按钮点击
    @IBAction func leftButtonClickAction(_ sender: AnyObject) {
        if self.leftButtonCallback != nil {
            self.leftButtonCallback!()
        }
    }
    
    //右边按钮点击
    @IBAction func rightButtonClickAction(_ sender: AnyObject) {
        if self.rightButtonCallback != nil {
            self.rightButtonCallback!()
        }
    }
    
    class func footerViewHeight_xib_1() -> CGFloat {
        return 150.0
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
