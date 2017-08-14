//
//  InvestActivityFooterView.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/22.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityFooterView: UIView {

    @IBOutlet weak var conformButton: UIButton! //确定按钮
    @IBOutlet weak var protoctButton: UIButton! //查看协议按钮
    
    var protectTapCallback: (() -> ())? //点击查看协议按钮
    var conformTapCallback:((_ isSelect: Bool) -> ())? //确认按钮
    
    //点击协议
    @IBAction func protectClickAction(_ sender: AnyObject) {
        
        if self.protectTapCallback != nil {
            self.protectTapCallback!()
        }
    }
    
    @IBOutlet weak var profitLabel: UILabel!
    override func awakeFromNib() {
        self.conformButton?.setImage(UIImage(named: "icon_check"), for: .selected)
        self.conformButton?.setImage(UIImage(named: "icon_selectbox"), for: UIControlState())
    }
    
    //点击确认按钮
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        let button =  sender as! UIButton
        
        if button.isSelected == false {
            button.isSelected = true
            
            if self.conformTapCallback != nil {
                self.conformTapCallback!(true)
            }
        } else {
            
            button.isSelected = false
            if self.conformTapCallback != nil {
                self.conformTapCallback!(false)
            }
        }
    }
    
    //显示收益率
    func displayProfitLabel(_ profitValue: Double) -> () {
        let numsStr = PD_NumDisplayStandard.numDisplayStandard("\(profitValue)", decimalPointType: 2, numVerification: false)
        self.profitLabel?.text = "预估收益\(numsStr)元"
        self.profitLabel?.setTextColor(DEFAULT_ORANGECOLOR, range: NSRange(location: 4, length: (numsStr?.lengthOfBytes(using: String.Encoding.utf8))!))
    }
}
