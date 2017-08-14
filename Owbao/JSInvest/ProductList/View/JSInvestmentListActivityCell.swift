//
//  JSInvestmentListActivityCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/17.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestmentListActivityCell: UITableViewCell {
    
    var pertProgressView: KDCircularProgress!    //募集进度的圆圈
    var pertLabel: UILabel!                      //募集进度
    @IBOutlet weak var activityRateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var progressSuperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    func configureUI() {
        //圆圈
        pertProgressView = KDCircularProgress(frame:self.progressSuperView.bounds)
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = DEFAULT_TRACK//底部圈颜色
        pertProgressView.progressColors = [DEFAULT_PROCOLOR]
        self.progressSuperView.addSubview(pertProgressView!)
        
        pertLabel = UILabel(frame: pertProgressView.frame)
        pertLabel.textAlignment = NSTextAlignment.center
        pertLabel.font = UIFont.systemFont(ofSize: 11 * SCREEN_WIDTH / 320)
        pertLabel.numberOfLines = 2
        pertLabel.textColor = JS_REDCOLOR
        self.progressSuperView.addSubview(pertLabel!)
    }
    
    func configureCell(_ activityProduct: InvestmentActivityProductModel?) {
        
        if activityProduct != nil {
            //利率范围
            if (activityProduct?.rate)! != 0.00
            {
                let minRate = PD_NumDisplayStandard.numDisplayStandard("\((activityProduct?.rate)!)", decimalPointType: 1, numVerification: false)
                var maxRate = ""
                if activityProduct?.maxRate != 0 {
                    maxRate = PD_NumDisplayStandard.numDisplayStandard("\((activityProduct?.maxRate)!)", decimalPointType: 1, numVerification: false)
                    rateLabel.text = minRate! + "%" + "~" + maxRate + "%"
                    let attributedString = NSMutableAttributedString(string: rateLabel.text!)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13 * SCREEN_SCALE_W), range: NSMakeRange((minRate?.characters.count)!,"%~".characters.count))
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13 * SCREEN_SCALE_W), range: NSMakeRange(rateLabel.text!.characters.count - "%".characters.count,"%".characters.count))
                    rateLabel.attributedText = attributedString
                    
                }else{
                    
                    rateLabel.text = minRate! + "%"
                    let attributedString = NSMutableAttributedString(string: rateLabel.text!)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13 * SCREEN_SCALE_W), range: NSMakeRange((minRate?.characters.count)!,"%".characters.count))
                    rateLabel.attributedText = attributedString
                }

            }
            else
            {
                let rate = PD_NumDisplayStandard.numDisplayStandard("\((activityProduct?.rate)!)", decimalPointType: 1, numVerification: false)
                
                self.setAttributedString(rate! + "%",
                                         subString: "%",
                                         attributeName: NSFontAttributeName,
                                         isSetFont: true,
                                         font: 13 * SCREEN_SCALE_W,
                                         location: (rate?.characters.count)!,
                                         length:"%".characters.count,
                                         label: rateLabel)
            }
            
            //活动利率
//            if activityProduct!.activityRate != 0 {
//                
//                let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\(activityProduct!.activityRate)", decimalPointType: 1, numVerification: false)
//                
//                self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: activityRateLabel)
//            }
//            else
//            {
//                activityRateLabel.text = ""
//            }
            
            //期限
            deadlineLabel.text = "\((activityProduct?.deadline)!)天起"
            self.setAttributedString(deadlineLabel.text!, subString: "天起", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: deadlineLabel.text!.characters.count - "天起".characters.count, length: "天起".characters.count, label: deadlineLabel)
            
            //活动标个数
            self.pertLabel.text = "\((activityProduct?.count)!)"
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
