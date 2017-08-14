//
//  JSIndicateDespositoryInvestPopView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/9.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSIndicateDespositoryInvestPopView: UIView {

    var openCustodyAccountBlock:(()->())?       //立即开通
    var closeBtnBlock: (()->())?
    
    @IBOutlet weak var popView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = PopView_BackgroundColor
        self.popView.layer.cornerRadius = 5
        self.popView.layer.masksToBounds = true
    }
    
    @IBAction func bottomButtonClickAction(_ sender: Any) {
        if openCustodyAccountBlock != nil {
            openCustodyAccountBlock!()
        }
    }
    
    //MARK: - 关闭按钮
    @IBAction func closeBtnClick(_ sender: Any) {
        if closeBtnBlock != nil {
            closeBtnBlock!()
        }
    }
}
