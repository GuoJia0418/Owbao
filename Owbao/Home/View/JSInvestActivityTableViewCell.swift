//
//  JSInvestActivityTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/11.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSInvestActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! //产品名称
    @IBOutlet weak var displayImageView: UIImageView! //显示图片
    @IBOutlet weak var topTitleLabel: UILabel!        //顶部label
    @IBOutlet weak var rateLabel: UILabel!           //活动利率
    @IBOutlet weak var activityRateLabel: UILabel!  //活动利率
    @IBOutlet weak var deadlineLabel: UILabel!      //期限label
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func cellHeight() -> CGFloat {
          return 152
    }
    
    //*********************** 配置活动标 ***********************//
    class func numberOfRowForActivityCell(_ activityModel: HomeActivityAndNewHandModel?) -> Int {
        
        if activityModel != nil {
            return 1
        }
        
        return 0
    }
    
    class func numberOfRowForModel(_ activityModel: HomeMapModel?) -> Int{
    
        return 0
    }
    
    func configureCellWithActivityModel(_ activityModel: HomeActivityAndNewHandModel?) {
        
        if activityModel != nil {
            
            if activityModel!.fullName?.characters.count > 15 {
                let textStr = (activityModel!.fullName! as NSString).substring(with: NSMakeRange(0, 15))
                titleLabel.text = textStr + "..."
            } else {
                titleLabel.text = activityModel!.fullName
            }
            
            //利率
            let rate = PD_NumDisplayStandard.numDisplayStandard("\((activityModel?.rate)!)", decimalPointType: 1, numVerification: false)
            
            self.setAttributedString(rate! + "%",
                                     subString: "%",
                                     attributeName: NSFontAttributeName,
                                     isSetFont: true,
                                     font: 13 * SCREEN_SCALE_W,
                                     location: (rate?.characters.count)!,
                                     length:"%".characters.count,
                                     label: rateLabel)
            
            //活动利率
            if activityModel!.activityRate != 0 {
                
                let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\((activityModel?.activityRate)!)", decimalPointType: 1, numVerification: false)
                
                self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: activityRateLabel)
            }
            
            //期限
            deadlineLabel.text = "\((activityModel?.deadline)!)天"
            self.setAttributedString(deadlineLabel.text!, subString: "天", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: deadlineLabel.text!.characters.count - "天".characters.count, length: "天".characters.count, label: deadlineLabel)
            
            //顶部label
            self.topTitleLabel.text = activityModel?.iphoneLabel
            
            //需要显示图片
            if activityModel!.iphonePicUrl != "" {
                self.displayImageView.sd_setImage(with: URL(string: (activityModel?.iphonePicUrl)!), placeholderImage: Common.image(with: UIColorFromRGB(230, green: 230, blue: 230)), options: .refreshCached)
            }
            
        }
    }
    
    
    //*********************** 配置投即送标 ***********************//
    class func numberOfRowForInvestGiveCell(_ prizeModel: InvestSendPrizeModel?) -> Int {
        
        if prizeModel != nil {
            return 1
        }
        
        return 0
    }
    
    func configureCellWithInvestGiveModel(_ prizeModel: InvestSendPrizeModel?) {
        
        if prizeModel != nil {
            
            if prizeModel!.name.characters.count > 15 {
                let textStr = (prizeModel!.name as NSString).substring(with: NSMakeRange(0, 15))
                titleLabel.text = textStr + "..."
            } else {
                titleLabel.text = prizeModel!.name
            }
            
            //利率
            let rate = PD_NumDisplayStandard.numDisplayStandard("\((prizeModel?.rate)!)", decimalPointType: 1, numVerification: false)
            
            self.setAttributedString(rate! + "%",
                                     subString: "%",
                                     attributeName: NSFontAttributeName,
                                     isSetFont: true,
                                     font: 13 * SCREEN_SCALE_W,
                                     location: (rate?.characters.count)!,
                                     length:"%".characters.count,
                                     label: rateLabel)
            
            //活动利率
            if prizeModel!.activityRate != 0 {
                
                let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\((prizeModel?.activityRate)!)", decimalPointType: 1, numVerification: false)
                
                self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: activityRateLabel)
            }
            
            //期限
            deadlineLabel.text = "\((prizeModel?.deadLine)!)天"
            self.setAttributedString(deadlineLabel.text!, subString: "天", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: deadlineLabel.text!.characters.count - "天".characters.count, length: "天".characters.count, label: deadlineLabel)
            //顶部label
            self.topTitleLabel.text = prizeModel!.investSendLabel
            
            //需要显示图片
            if prizeModel!.investSendPicUrl != "" {
                self.displayImageView.sd_setImage(with: URL(string: (prizeModel?.investSendPicUrl)!), placeholderImage: Common.image(with: UIColorFromRGB(230, green: 230, blue: 230)), options: .refreshCached)
            }
        }
    }
    
    //设置Attribute
    fileprivate func setAttributedString(_ superString: String,
                             subString: String,
                             attributeName: String,
                             isSetFont: Bool,
                             font: CGFloat,
                             location: Int,
                             length: Int,
                             label: UILabel) {
        
        let attributedString = NSMutableAttributedString(string: superString)
        
        if isSetFont {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        
        label.attributedText = attributedString
    }
}
