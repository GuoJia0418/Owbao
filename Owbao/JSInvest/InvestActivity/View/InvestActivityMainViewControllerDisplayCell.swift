//
//   .swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/21.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityMainViewControllerDisplayCell: UITableViewCell {

    @IBOutlet weak var giftImageView: UIImageView!    //一个礼物图片
    @IBOutlet weak var IndicatorImageView: UIImageView! //右上角的三角形view
    
    @IBOutlet weak var titleLabel: UILabel!  //标的名字label
    @IBOutlet weak var rateLabel: UILabel!    //年化率label
    @IBOutlet weak var deadLineLabel: UILabel! //标的期限label
    @IBOutlet weak var bottomLabel: UILabel!    //底部红色长条label
    @IBOutlet weak var indicatorLabel: UILabel!  //右上角推荐label
    
    @IBOutlet weak var leftConstains: NSLayoutConstraint! //底部红色按钮左边约束
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.IndicatorImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2 ))
        self.indicatorLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 4 ))
        self.bottomLabel.layer.cornerRadius = 3
        self.bottomLabel.layer.masksToBounds = true
        
        //根据屏幕尺寸调整约束
        self.leftConstains.constant = (SCREEN_WIDTH - (SCREEN_WIDTH - 30 * SCREEN_WIDTH / 320 * 2) / 3 * 3) / 2
        self.rateLabel.font = UIFont.systemFont(ofSize: 50)
        self.titleLabel.font = UIFont.systemFont(ofSize: 20 * SCREEN_WIDTH / 320)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //根据奖品模型配置cell
    func configureCellWithPrizeModel(_ prizeModel: InvestSendPrizeModel) -> () {
        self.titleLabel.text = prizeModel.name //标题
        self.deadLineLabel.text = "期限\(prizeModel.deadLine)天" //截止时期

        //若活动利率不等于0，则加上
        let attributeString = NSMutableAttributedString(string:PD_NumDisplayStandard.numDisplayStandard("\(prizeModel.rate)", decimalPointType: 1, numVerification: false) + "%")
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30 * SCREEN_WIDTH / 320), range: NSMakeRange(attributeString.length - 1,1))
        
        //表示活动标存在
        if prizeModel.activityRate != 0  {
            
            let attributeString_activity = NSMutableAttributedString(string:"+" + PD_NumDisplayStandard.numDisplayStandard("\(prizeModel.activityRate)", decimalPointType: 1, numVerification: false) + "%")
            attributeString_activity.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30 * SCREEN_WIDTH / 320), range: NSMakeRange(attributeString_activity.length - 1,1))
            
            attributeString.append(attributeString_activity) //合并利率
        }
        self.rateLabel.attributedText = attributeString
    }
    
    //获取cell高度
    class func getCellHeight() -> CGFloat {
        return  225
    }
}
