//
//  JSNoviceFooterView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/14.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSNoviceFooterView: UIView {
    
    @IBOutlet weak var continueBtn: UIButton! //续投红包
    var continueClickBlock:(()->())?        //续投领取红包
    var abandonClickBlock:(()->())?         //放弃机会
    
    override func awakeFromNib() {
        super.awakeFromNib()
        continueBtn.layer.cornerRadius = 2.0
        continueBtn.layer.masksToBounds = true
        
    }

    //MARK: - 高度
    class func footerHeight()->CGFloat
    {
        return 345 * SCREEN_SCALE_W
    }
    
    //续投领取现金红包
    @IBAction func continueBtnClick(_ sender: AnyObject) {
        if continueClickBlock != nil
        {
            self.continueClickBlock!()
        }
    }
    
    //放弃机会
    @IBAction func abandonBtnClick(_ sender: AnyObject) {
        if abandonClickBlock != nil
        {
            self.abandonClickBlock!()
        }
    }
}
