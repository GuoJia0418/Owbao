//
//  JSHomeInvestCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/9.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class JSHomeInvestCell: UITableViewCell {

    var iconImageView:UIImageView!      //财 图标
    var titleLabel:UILabel!             //标题
    var limitLabel:UILabel!             //条件限制
    var limitsLabel:UILabel!
    var doubleLimitLabel:UILabel!       //翻倍券
    
    var rateLabel:UILabel!              //基础利率
    var deadlineLabel:UILabel!          //期限
    var pertProgressView:KDCircularProgress!    //募集进度的圆圈
    var pertLabel:UILabel!                      //募集进度
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupChildUI()
    }
    
    class func cellHeight() -> CGFloat {
        return 152
    }
    
    //MARK: 数据
    func configModel(_ model:JSHomePreferredInvestModel?)
    {
        if model!.preferredName!.characters.count > 15
        {
            let textStr = (model!.preferredName! as NSString).substring(with: NSMakeRange(0, 15))
            titleLabel.text = textStr + "..."
            titleLabel.width = newSize(titleLabel)
        }
        else
        {
            titleLabel.text = model!.preferredName
            titleLabel.width = newSize(titleLabel)
        }
        
        limitLabel.x = titleLabel.width + titleLabel.x + 20
        limitsLabel.x = limitLabel.x + limitLabel.width + 10
        doubleLimitLabel.x = limitsLabel.x + limitsLabel.width + 10
        
        //利率
        let minRate = PD_NumDisplayStandard.numDisplayStandard("\((model?.minRate)!)", decimalPointType: 1, numVerification: false)
        let maxRate = PD_NumDisplayStandard.numDisplayStandard("\((model?.maxRate)!)", decimalPointType: 1, numVerification: false)
        rateLabel.text = minRate! + "%" + "~" + maxRate! + "%"
        let attributedString = NSMutableAttributedString(string: rateLabel.text!)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13 * SCREEN_SCALE_W), range: NSMakeRange((minRate?.characters.count)!,"%~".characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13 * SCREEN_SCALE_W), range: NSMakeRange(rateLabel.text!.characters.count - "%".characters.count,"%".characters.count))
        rateLabel.attributedText = attributedString

        //期限
        deadlineLabel.text = "\((model?.minDeadline)!)天起"
        self.setAttributedString(deadlineLabel.text!, subString: "天起", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: deadlineLabel.text!.characters.count - "天起".characters.count, length: "天起".characters.count, label: deadlineLabel)
        
        //红包 加息券 翻倍券
        let w = CGFloat(38)
        if model?.isCash == 1
        {
            limitLabel.width = w
            if model?.isInterest == 1
            {
                limitsLabel.width = w
                if model?.isDouble == 0
                {
                    doubleLimitLabel.width = 0
                }
                else
                {
                    doubleLimitLabel.width = w
                }
            }
            else
            {
                limitsLabel.width = 0
                if model?.isDouble == 0
                {
                    doubleLimitLabel.width = 0
                }
                else
                {
                    doubleLimitLabel.width = w
                }
                
            }
        }
        else
        {
            limitLabel.width = 0
            if model?.isInterest == 1
            {
                limitsLabel.width = w
                if model?.isDouble == 0
                {
                    doubleLimitLabel.width = 0
                }
                else
                {
                    doubleLimitLabel.width = w
                }
                
            }
            else
            {
                limitsLabel.width = 0
                if model?.isDouble == 0
                {
                    doubleLimitLabel.width = 0
                }
                else
                {
                    doubleLimitLabel.width = w
                }
                
            }
        }
        
        
        
    }

    
    //创建UI
    func setupChildUI()
    {
        let bgViewH = CGFloat(48)
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bgViewH))
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        //图标
        iconImageView = UIImageView(image: UIImage(named: "js_you_icon"))
        iconImageView.size = (iconImageView.image?.size)!
        iconImageView.origin = CGPoint(x: 20, y: (bgViewH - iconImageView.height) / 2)
        bgView.addSubview(self.iconImageView!)
        
        //标名称
        titleLabel = self.setupLabel(iconImageView.width + iconImageView.x + 8 , y: (bgViewH - 15) / 2, width: SCREEN_WIDTH / 3, height: 15, font: 15, textColor: UIColor.black, textAlignment: .left, text: "",ishaveBorder: false,view: bgView)
        
        //限投
        limitLabel = setupLabel(titleLabel.x + titleLabel.width + 15, y: (bgViewH - 20) / 2, width: 38, height: 20, font: 10, textColor: Global_red, textAlignment: .center, text: "红包",ishaveBorder: true,view: bgView)
        
        limitsLabel = setupLabel(limitLabel.x + limitLabel.width + 10, y: limitLabel.y, width: 38, height: limitLabel.height, font: 10, textColor: Global_red, textAlignment: .center, text: "加息券", ishaveBorder: true, view:bgView)
        
        doubleLimitLabel = setupLabel(limitsLabel.x + limitsLabel.width + 10, y: limitsLabel.y, width: 38, height: limitLabel.height, font: 10, textColor: Global_red, textAlignment: .center, text: "翻倍券", ishaveBorder: true, view: bgView)

        //线条
        let lineLabel = setupLabel(0, y: bgView.height + bgView.y, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel.backgroundColor = DEFAULT_GRAYCOLOR
    
        //基础利率
        rateLabel = setupLabel(20, y: lineLabel.height + lineLabel.y + 30, width: SCREEN_WIDTH / 2 - 10, height: 40, font: 35, textColor: Global_red, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        //期限
        deadlineLabel = setupLabel(SCREEN_WIDTH / 2, y: rateLabel.y , width: SCREEN_WIDTH / 4, height: rateLabel.height, font: 25, textColor: Default_All6_Color, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        
        //圆圈
        pertProgressView = KDCircularProgress(frame: CGRect(x: SCREEN_WIDTH - (70), y: 70, width: 57, height: 57))
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = Global_yellow_light
        pertProgressView.progressColors = [Global_yellow_light,Global_yellow_deep]
        self.contentView.addSubview(pertProgressView!)
        
        pertLabel = UILabel(frame: pertProgressView.frame)
        pertLabel.textAlignment = NSTextAlignment.center
        pertLabel.font = UIFont.systemFont(ofSize: 11)
        pertLabel.numberOfLines = 2
        pertLabel.text = "去抢购"
        pertLabel.textColor = Global_yellow_deep
        self.contentView.addSubview(pertLabel!)
        
        //        self.pertProgressView.hidden = true
        //        self.pertLabel.hidden = true
        
    }
    //MARK: - label 自适应高度
    func newSize(_ label:UILabel) -> CGFloat
    {
        let textSize = NSString(string: label.text!).size(attributes: [NSFontAttributeName : label.font!])
        return textSize.width
    }
    
    //设置Attribute
    func setAttributedString(_ superString:String,subString:String,attributeName:String,isSetFont:Bool,font:CGFloat,location:Int,length:Int,label:UILabel)
    {
        let attributedString = NSMutableAttributedString(string: superString)
        if isSetFont
        {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        label.attributedText = attributedString
    }
    
    func setupLabel(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,font:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,text:String,ishaveBorder:Bool,view:UIView) -> UILabel
    {
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.text = text
        if ishaveBorder {
            label.layer.cornerRadius = 2.0
            label.layer.masksToBounds = true
            label.layer.borderColor = Global_red.cgColor
            label.layer.borderWidth = 1.0
        }
        view.addSubview(label)
        return label
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
