//
//  ExperienceInvestSuccessTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ExperienceInvestSuccessTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!           //头部label
    @IBOutlet weak var foundLabel: UILabel!                 //投资项目
    @IBOutlet weak var dateLabel: UILabel!                  //投资期限
    @IBOutlet weak var rateLabel: UILabel!                  //年化利率
    @IBOutlet weak var earningsLabel: UILabel!              //预期收益
    
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    var leftButtonCallback: (() -> ())?
    var rightButtonCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftBottomButton.layer.cornerRadius = 3
        self.leftBottomButton.layer.masksToBounds = true
        self.leftBottomButton.layer.borderWidth = 1
        self.leftBottomButton.layer.borderColor = UIColor.darkGray.cgColor
        
        self.rightBottomButton.layer.cornerRadius = 3
        self.rightBottomButton.layer.masksToBounds = true
    }
    
    class func cellHeight() -> (CGFloat) {
        return 331.0
    }
    
    //立即赚钱
    @IBAction func rightButtonClickAction(_ sender: AnyObject) {
        if self.rightButtonCallback != nil {
            self.rightButtonCallback!()
        }
    }
    
    //我的投资
    @IBAction func leftButtonClickAction(_ sender: AnyObject) {
        if self.leftButtonCallback != nil {
            self.leftButtonCallback!()
        }
    }
    
    func configureCellWithData(_ experienceMapModel: ExperienceInvestMapModel,investing: ExperienceInvestingMapModel) -> () {
        
        if experienceMapModel.info != nil {
            
            self.dateLabel.text = "\(experienceMapModel.info!.deadline)天" //天数
            
            //如果活动利率存在的话，要显示
            var string = PD_NumDisplayStandard.numDisplayStandard("\((experienceMapModel.info!.rate))", decimalPointType: 1, numVerification: false) + "%" //利率
            if experienceMapModel.info!.activityRate != 0 {
                let activityRateString = "+" + PD_NumDisplayStandard.numDisplayStandard("\(experienceMapModel.info!.activityRate)", decimalPointType: 1, numVerification: false) + "%" //活动利率
                string = string + activityRateString
            }
            self.rateLabel.text = string

            //投资模型
            if experienceMapModel.experienceAmount != nil {
                
                self.foundLabel.text = experienceMapModel.info?.fullName
                
                //收益
                let amount = (experienceMapModel.experienceAmount?.experAmount)!
                let rate = (Double(experienceMapModel.info!.activityRate + experienceMapModel.info!.rate) / 360) / 100
                let deadline = Double((experienceMapModel.info!.deadline))
                
                self.earningsLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(amount * rate * deadline)", decimalPointType: 1, numVerification: false) + "元"
            }
            
//            if investing.realverify == true { //实名认证了
//                self.bottomLabel.hidden = investing.redTotal == 0 ? true : false //红包等于0 隐藏
//                self.bottomLabel.text = "您还有\(investing.redTotal)个红包未使用，激活即可变现哦!"
//                
//            } else { //未实名认证
//                
//                let string = "绑卡即可再领10000元体验金+200元红包!"
//                let attributeString = NSMutableAttributedString(string: string)
//                
//                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(216.0, green: 15, blue: 16), range: NSMakeRange(6,5))
//                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(216.0, green: 15, blue: 16), range: NSMakeRange(16,3))
//                
//                self.bottomLabel.attributedText = attributeString
//            
//            }
        }
        
    }
    
}
