//
//  JSServiceCentreTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum ServiceCentreTapCallback: Int {
    case certificationRegistration  = 0                           //认证,注册
    case safeguard = 1                                            //安全保障
    case rechargeWithdrawals = 2                                 //充值提现
    case investWelfare = 3                                     //投资福利
    case productRecommend  = 4                            //产品介绍
    case otherProblem = 5                               //其他问题
}

class JSServiceCentreTableViewCell: UITableViewCell {

    var tapCallback:((_ callbackType: ServiceCentreTapCallback) -> ())?
    var leftButtonCallback:(() -> ())?
    var rightButtonCallback:(() -> ())?
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.leftButton.layer.cornerRadius = 20
        self.leftButton.layer.masksToBounds = true
        self.leftButton.layer.borderColor = UIColor.white.cgColor
        self.leftButton.layer.borderWidth = 1
        
        //右部按钮
        self.rightButton.layer.cornerRadius = 20
        self.rightButton.layer.masksToBounds = true
        self.rightButton.layer.borderColor = UIColor.white.cgColor
        self.rightButton.layer.borderWidth = 1
    }
    
    @IBAction func leftButtonAction(_ sender: AnyObject) {
        if self.leftButtonCallback != nil {
            self.leftButtonCallback!()
        }
    }
    
    @IBAction func rightButtonAction(_ sender: AnyObject) {
        
        if self.rightButtonCallback != nil {
            self.rightButtonCallback!()
        }
    }
    
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        let button = sender as! UIButton
        if button.tag == 0 {
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.certificationRegistration)
            }
            
        } else if button.tag == 1 {
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.safeguard)
            }
            
        } else if button.tag == 2 {
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.rechargeWithdrawals)
            }
            
        } else if button.tag == 3 {
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.investWelfare)
            }
            
        } else if button.tag == 4 { //产品介绍
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.productRecommend)
            }
            
        } else if button.tag == 5 { //其他问题
            
            if self.tapCallback != nil {
                self.tapCallback!(ServiceCentreTapCallback.otherProblem)
            }
        }
    }
    
    //高度
    class func cellHeight() -> CGFloat {
        return SCREEN_WIDTH * 2 / 3 + 200
        
    }
}
