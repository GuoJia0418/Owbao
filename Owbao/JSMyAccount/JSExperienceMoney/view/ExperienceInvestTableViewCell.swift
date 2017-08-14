//
//  ExperienceInvestTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ExperienceInvestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.indicatorLabel != nil {
            self.indicatorLabel.layer.cornerRadius = 9.0
            self.indicatorLabel.layer.masksToBounds = true
            self.indicatorLabel.layer.borderColor = UIColorFromRGB(249, green: 0, blue: 37).cgColor
            self.indicatorLabel.layer.borderWidth = 1.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //************** 第一个xib **************//
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!//预约年化率label
    @IBOutlet weak var investLimitDateLabel: UILabel! //投资期限
    @IBOutlet weak var investNumberLabel: UILabel! //多少人赚到钱了
    
    func configureCellWithData(_ experienceMapModel: ExperienceInvestMapModel) -> () {
        
        if experienceMapModel.info != nil {
            
            self.productNameLabel.text = experienceMapModel.info?.fullName //名字
            
            //普通利率
            let attributeString = NSMutableAttributedString(string:PD_NumDisplayStandard.numDisplayStandard("\(experienceMapModel.info!.rate)", decimalPointType: 1, numVerification: false) + "%")
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(attributeString.length - 1,1))
            
            if experienceMapModel.info!.activityRate != 0 {
                //活动利率
                let attributeString_activity = NSMutableAttributedString(string:"+" + PD_NumDisplayStandard.numDisplayStandard("\(experienceMapModel.info!.activityRate)", decimalPointType: 1, numVerification: false) + "%")
                attributeString_activity.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(attributeString_activity.length - 1,1))
                
                attributeString.append(attributeString_activity) //合并利率
            }
            
            self.rateLabel.attributedText = attributeString

            //天数
            let attributeString_second = NSMutableAttributedString(string:PD_NumDisplayStandard.numDisplayStandard("\(experienceMapModel.info!.deadline)", decimalPointType: 0, numVerification: false) + "天")
            attributeString_second.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(attributeString_second.length - 1,1))
            self.investLimitDateLabel.attributedText = attributeString_second
            
            //多少人投资了
            self.investNumberLabel.text = "已经有\(experienceMapModel.investCount)人赚到了钱"
        }
    }
    
    class func cellHeight_firstXib() -> CGFloat {
        return 293.0
    }
    
    //************** 第二个xib **************//
    var model: ExperienceDictionaryModel?
    let titleLabel_X: CGFloat = 17.0
    let Margin: CGFloat = 15.0
    
    @IBOutlet weak var indicatorLabel: UILabel!
    
    var titlelabel_first: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    var titlelabel_second: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    var titlelabel_third: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    var titlelabel_forth: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    var titlelabel_fifth: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    class func cellHeight_secondXib(_ dictionaryModel: ExperienceDictionaryModel) -> CGFloat {
        
        let heigth_1 = ExperienceInvestTableViewCell.getHeigth(dictionaryModel.title_fist, contentWidth: SCREEN_WIDTH - 17 - 15)
        let height_2 = ExperienceInvestTableViewCell.getHeigth(dictionaryModel.title_second, contentWidth: SCREEN_WIDTH - 17 - 15)
        let height_3 = ExperienceInvestTableViewCell.getHeigth(dictionaryModel.title_third, contentWidth: SCREEN_WIDTH - 17 - 15)
        let height_4 = ExperienceInvestTableViewCell.getHeigth(dictionaryModel.title_forth, contentWidth: SCREEN_WIDTH - 17 - 15)
        let heigth_5 = ExperienceInvestTableViewCell.getHeigth(dictionaryModel.title_fifth, contentWidth: SCREEN_WIDTH - 17 - 15)
        
        return 180.0 + 6 * 15 + heigth_1 + height_2 + height_3 + height_4 + heigth_5
    }
    
    func configureCellWithModel(_ dictionaryModel: ExperienceDictionaryModel) -> () {
        
        self.model = dictionaryModel
        
        self.contentView.addSubview(self.titlelabel_first)
        self.contentView.addSubview(self.titlelabel_second)
        self.contentView.addSubview(self.titlelabel_third)
        self.contentView.addSubview(self.titlelabel_forth)
        self.contentView.addSubview(self.titlelabel_fifth)
        
        self.titlelabel_first.text = dictionaryModel.title_fist
        self.titlelabel_second.text = dictionaryModel.title_second
        self.titlelabel_third.text = dictionaryModel.title_third
        self.titlelabel_forth.text = dictionaryModel.title_forth
        self.titlelabel_fifth.text = dictionaryModel.title_fifth
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        if model != nil {
            self.titlelabel_first.frame = CGRect(x: titleLabel_X, y: 175,width: SCREEN_WIDTH - titleLabel_X - Margin, height: ExperienceInvestTableViewCell.getHeigth(self.model!.title_fist, contentWidth: SCREEN_WIDTH - titleLabel_X - Margin))
            
            self.titlelabel_second.frame = CGRect(x: titleLabel_X, y: self.titlelabel_first.frame.maxY + Margin, width: SCREEN_WIDTH - titleLabel_X - Margin,height: ExperienceInvestTableViewCell.getHeigth(self.model!.title_second, contentWidth: SCREEN_WIDTH - titleLabel_X - Margin))
            
            self.titlelabel_third.frame = CGRect(x: titleLabel_X, y: self.titlelabel_second.frame.maxY + Margin,  width: SCREEN_WIDTH - titleLabel_X - Margin, height: ExperienceInvestTableViewCell.getHeigth(self.model!.title_third, contentWidth: SCREEN_WIDTH - titleLabel_X - Margin))
            
            self.titlelabel_forth.frame = CGRect(x: titleLabel_X, y: self.titlelabel_third.frame.maxY + Margin,  width: SCREEN_WIDTH - titleLabel_X - Margin, height: ExperienceInvestTableViewCell.getHeigth(self.model!.title_forth, contentWidth: SCREEN_WIDTH - titleLabel_X - Margin))
            
            self.titlelabel_fifth.frame = CGRect(x: titleLabel_X, y: self.titlelabel_forth.frame.maxY + Margin,  width: SCREEN_WIDTH - titleLabel_X - Margin, height: ExperienceInvestTableViewCell.getHeigth(self.model!.title_fifth, contentWidth: SCREEN_WIDTH - titleLabel_X - Margin))
        }
        
    }
    
    class func getHeigth(_ content: String,contentWidth: CGFloat) -> CGFloat {
        if content == "" {
            return 0.0
        } else {
            let height = content.getTextRectSize(UIFont.systemFont(ofSize: 15.0),size:CGSize(width: contentWidth, height: 3000.0)).size.height
            return height
        }
    }
}
