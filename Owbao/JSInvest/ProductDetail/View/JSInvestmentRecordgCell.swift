//
//  JSInvestmentRecordgCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestmentRecordgCell: UITableViewCell {

    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var lineBottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //配置cell
    func configureCell(_ model: DetailsListInvestListModle?) -> () {
        
        if model != nil {
            
            amountLabel.text =  PD_NumDisplayStandard.numDisplayStandard("\(model!.amount)", decimalPointType: 0, numVerification: false) //金额
            timeLabel.text = TimeStampToStringTypeTwo((model!.investTime))    //时间
            
            if model?.mobilephone?.length == 11 {
                phoneNumberLabel.text = model!.mobilephone!.phoneNoAddAsterisk() //电话号码
            } else {
                phoneNumberLabel.text = model!.mobilephone //电话号码
            }
            
            if model?.joinType == 0 { //电脑
                leftImageView.image = UIImage(named: "js_pro_detail_pc")
            } else { //手机用户
               leftImageView.image = UIImage(named: "js_pro_detail_mobile")
            }
        }
    }
    
}
