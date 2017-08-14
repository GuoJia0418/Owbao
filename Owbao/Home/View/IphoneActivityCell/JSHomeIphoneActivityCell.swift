//
//  JSHomeIphoneActivityCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/9.
//  Copyright © 2017年 wangyuxi. All rights reserved.
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


class JSHomeIphoneActivityCell: UITableViewCell {

    var iconImageView:UIImageView!      //财 图标
    var titleLabel:UILabel!             //标题
    var limitLabel:UILabel!             //条件限制
    var rateLabel:UILabel!              //基础利率
    var addRateLabel:UILabel!           //增加利率
    var deadlineLabel:UILabel!          //期限
    var pertProgressView:KDCircularProgress!    //募集进度的圆圈
    var pertLabel:UILabel!                      //募集进度
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupChildUI()
    }
    //MARK: 数据
    func configModel(_ model:HomeActivityAndNewHandModel?,newHandString:String)
    {
        if model!.fullName?.characters.count > 15
        {
            let textStr = (model!.fullName! as NSString).substring(with: NSMakeRange(0, 15))
            titleLabel.text = textStr + "..."
            titleLabel.width = newSize(titleLabel)
        }
        else
        {
            titleLabel.text = model!.fullName
            titleLabel.width = newSize(titleLabel)
        }
        
        if newHandString == ""
        {
            limitLabel.isHidden = true
        }
        else
        {
            if model?.fullName?.characters.count > 15
            {
                limitLabel.isHidden = true
            }
            else
            {
                limitLabel.isHidden = false
                limitLabel.x = titleLabel.x + titleLabel.width + 20
                limitLabel.text = newHandString
            }
            
        }
        
        //利率
        let rate = PD_NumDisplayStandard.numDisplayStandard("\((model?.rate)!)", decimalPointType: 1, numVerification: false)
        self.setAttributedString(rate! + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: (rate?.characters.count)!,length:"%".characters.count,label:rateLabel)
        
        //活动利率
        if model!.activityRate != 0 {
            let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\(model!.activityRate)", decimalPointType: 1, numVerification: false)
            self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: addRateLabel)
        }
        else
        {
            addRateLabel.text = ""
        }
        
        //期限
        deadlineLabel.text = "\((model?.deadline)!)天"
        self.setAttributedString(deadlineLabel.text!, subString: "天", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: deadlineLabel.text!.characters.count - "天".characters.count, length: "天".characters.count, label: deadlineLabel)
        
        
        self.pertProgressView.angle = 0
        self.pertProgressView.animateToAngle((Int)(model!.pert * 3.60), duration: 1, completion: nil)
        
        if model!.status != 5
        {
            self.pertLabel.textColor             = TITLE_GRAYCOLOR
            self.pertProgressView.trackColor     = DEFAULT_PROCOLOR
            self.pertProgressView.progressColors = [DEFAULT_PROCOLOR]
            
            if model!.status == 6 {
                self.pertLabel.text = "已抢完"
                var newLabelFrame = self.pertLabel.frame
                newLabelFrame.size.width = 44
                newLabelFrame.origin.x = self.pertProgressView.frame.origin.x + (self.pertProgressView.frame.width - 44) / 2
                self.pertLabel.frame = newLabelFrame
                
            } else if model!.status == 8 {
                self.pertLabel.text = "待还款" //已计息
                var newLabelFrame = self.pertLabel.frame
                newLabelFrame.size.width = 80
                newLabelFrame.origin.x = self.pertProgressView.frame.origin.x + (self.pertProgressView.frame.width - 80) / 2
                self.pertLabel.frame = newLabelFrame
            } else if model!.status == 9 {
                self.pertLabel.text = "已还款"
                var newLabelFrame = self.pertLabel.frame
                newLabelFrame.size.width = 80
                newLabelFrame.origin.x = self.pertProgressView.frame.origin.x + (self.pertProgressView.frame.width - 80) / 2
                self.pertLabel.frame = newLabelFrame
            } else {
                self.pertLabel.text = ""
                var newLabelFrame = self.pertLabel.frame
                newLabelFrame.size.width = 80
                newLabelFrame.origin.x = self.pertProgressView.frame.origin.x + (self.pertProgressView.frame.width - 80) / 2
                self.pertLabel.frame = newLabelFrame
            }
            
        }
        else
        {
            var newLabelFrame = self.pertLabel.frame
            newLabelFrame.size.width = 80
            newLabelFrame.origin.x = self.pertProgressView.frame.origin.x + (self.pertProgressView.frame.width - 80) / 2
            self.pertLabel.frame = newLabelFrame
            self.pertLabel.textColor = JS_REDCOLOR
            
            self.pertProgressView.trackColor = DEFAULT_TRACK//底部圈颜色
            self.pertProgressView.progressColors = [DEFAULT_PROCOLOR]
            
            //            self.pertProgressView.trackColor = UIColor(red:255/255.0, green:228/255.0, blue:214/255.0, alpha:1)//底部圈颜色
            //            self.pertProgressView.progressColors = [DEFAULT_REDCOLOR]
            
            if model!.pert >= 99.00 && model!.pert < 100.00 {
//                self.pertLabel.text = "99%"
                 self.pertLabel.text = "去抢购"
            } else {
                self.pertLabel.text = "去抢购"
            }
            
        }

        
    }

    //创建UI
    func setupChildUI()
    {
        let bgViewH = 48 * SCREEN_SCALE_W
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bgViewH))
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        //图标
        iconImageView = UIImageView(image: UIImage(named: "js_cai_icon"))
        iconImageView.size = (iconImageView.image?.size)!
        iconImageView.origin = CGPoint(x: 15, y: (bgViewH - iconImageView.height) / 2)
        bgView.addSubview(self.iconImageView!)
        
        //标名称
        titleLabel = self.setupLabel(iconImageView.width + iconImageView.x + 8, y: (bgViewH - 15 * SCREEN_SCALE_W) / 2, width: SCREEN_WIDTH / 3, height: 15 * SCREEN_SCALE_W, font: 15, textColor: Default_All3_Color, textAlignment: .left, text: "",ishaveBorder: false,view: bgView)
        
        //限投
        limitLabel = setupLabel(titleLabel.x + titleLabel.width + 15, y: (bgViewH - 20) / 2, width: 75 * SCREEN_SCALE_W, height: 20, font: 10, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "",ishaveBorder: true,view: bgView)
        
        //线条
        let lineLabel = setupLabel(0, y: bgView.height + bgView.y, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel.backgroundColor = DEFAULT_GRAYCOLOR

        //基础利率
        rateLabel = setupLabel(0, y: lineLabel.height + lineLabel.y + 30 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 3, height: 40 * SCREEN_SCALE_W, font: 27 * SCREEN_SCALE_W, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "", ishaveBorder: false,view: self.contentView)
        
        //增加利率
        addRateLabel = setupLabel(SCREEN_WIDTH / 4 - 5, y: rateLabel.y - 12 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 4, height: 17 * SCREEN_SCALE_W, font: 17 * SCREEN_SCALE_W, textColor: DEFAULT_REDCOLOR, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        //期限
        deadlineLabel = setupLabel(SCREEN_WIDTH / 2 + 5 * SCREEN_SCALE_W, y: rateLabel.y , width: SCREEN_WIDTH / 4, height: rateLabel.height, font: 22 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        //圆圈
        pertProgressView = KDCircularProgress(frame: CGRect(x: SCREEN_WIDTH - (70 * SCREEN_SCALE_W), y: 70 * SCREEN_SCALE_W, width: 57 * SCREEN_SCALE_W, height: 57 * SCREEN_SCALE_W))
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = DEFAULT_TRACK
        pertProgressView.progressColors = [DEFAULT_PROCOLOR]
        self.contentView.addSubview(pertProgressView!)
        
        pertLabel = UILabel(frame: pertProgressView.frame)
        pertLabel.textAlignment = NSTextAlignment.center
        pertLabel.font = UIFont.systemFont(ofSize: 11 * SCREEN_WIDTH / 320)
        pertLabel.numberOfLines = 2
        pertLabel.text = "去抢购"
        pertLabel.textColor = JS_REDCOLOR
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
            label.layer.borderColor = DEFAULT_ORANGECOLOR.cgColor
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
