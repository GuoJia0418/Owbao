//
//  InvestActivityDetailFooterView.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityDetailFooterView: UIView {
    var buttonClickCallback: (() -> ())?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func buttonClickAction(_ sender: AnyObject) {
        
        if self.buttonClickCallback != nil {
            self.buttonClickCallback!()
        }
    }
}
