//
//  JSIndicateDepositoryPopView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/20.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  提示是否开通存管的视图

import UIKit

class JSIndicateDepositoryPopView: UIView {
    
    var openCustodyAccountBlock:(()->())?       //立即开通
    var cancleOpenAccountBlock:(()->())?        //暂不开通
    var closeBtnBlock: (()->())?                //关闭按钮
    @IBOutlet weak var popView: UIView!
    
    //MARK: - 立即开通
    @IBAction func openCustodyAccountClick(_ sender: Any) {
        if openCustodyAccountBlock != nil {
            openCustodyAccountBlock!()
        }
    }
    
    //MARK: - 暂不开通
    @IBAction func cancleOpenAccount(_ sender: Any) {
        if cancleOpenAccountBlock != nil {
            cancleOpenAccountBlock!()
        }
    }
    
    //MARK: - 关闭按钮
    @IBAction func closeBtnClick(_ sender: Any) {
        if closeBtnBlock != nil {
            closeBtnBlock!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = PopView_BackgroundColor
        
        self.popView.layer.cornerRadius = 5
        self.popView.layer.masksToBounds = true
    }

}
