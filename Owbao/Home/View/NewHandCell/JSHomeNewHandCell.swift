//
//  JSHomeNewHandCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/8.
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


class JSHomeNewHandCell: UITableViewCell {

    var iconImageView:UIImageView!      //新 图标
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
    
    class func cellHeight() -> CGFloat {
        return 152
    }
    
    class func numberOfRowForNewHandCell(_ newhandModel: HomeMapModel?) -> Int {
        if newhandModel?.fuiouNewHandInvested == 0  && newhandModel?.fuiouNewHand != nil{
            return 1
        }
        return 0
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
            limitLabel.isHidden = false
            limitLabel.x = titleLabel.x + titleLabel.width + 20
            limitLabel.text = newHandString
        }
        //利率
        let rate = PD_NumDisplayStandard.numDisplayStandard("\((model?.rate)!)", decimalPointType: 1, numVerification: false)
        self.setAttributedString(rate! + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 13 * SCREEN_SCALE_W, location: (rate?.characters.count)!,length:"%".characters.count,label:rateLabel)
        
        //活动利率
        if model!.activityRate != 0 {
            let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\(model!.activityRate)", decimalPointType: 1, numVerification: false)
            self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 15 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: addRateLabel)
        }
        else
        {
            addRateLabel.text = ""
        }

        //期限
        deadlineLabel.text = "\((model?.deadline)!)天"
        self.setAttributedString(deadlineLabel.text!, subString: "天", attributeName: NSFontAttributeName, isSetFont: true, font: 13, location: deadlineLabel.text!.characters.count - "天".characters.count, length: "天".characters.count, label: deadlineLabel)
        
    }
    
    //创建UI
    func setupChildUI()
    {
        let bgViewH = CGFloat(48)
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bgViewH))
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        //图标
        iconImageView = UIImageView(image: UIImage(named: "js_newhand_icon"))
        iconImageView.size = (iconImageView.image?.size)!
        iconImageView.origin = CGPoint(x: 20, y: (bgViewH - iconImageView.height) / 2)
        
        bgView.addSubview(self.iconImageView!)
        
        //标名称
        titleLabel = self.setupLabel(iconImageView.width + iconImageView.x + 8, y: (bgViewH - 15) / 2, width: SCREEN_WIDTH / 3, height: 15 , font: 15, textColor: Default_All3_Color, textAlignment: .left, text: "",ishaveBorder: false,view: bgView)
        
        //限投
        limitLabel = setupLabel(titleLabel.x + titleLabel.width + 15, y: (bgViewH - 20) / 2, width: 80, height: 20, font: 10, textColor: Global_red, textAlignment: .center, text: "",ishaveBorder: true,view: bgView)
        
        //线条
        let lineLabel = setupLabel(0, y: bgView.height + bgView.y, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel.backgroundColor = DEFAULT_GRAYCOLOR

        //基础利率
        rateLabel = setupLabel(0, y: lineLabel.height + lineLabel.y + 30, width: SCREEN_WIDTH / 3, height: 40, font: 35, textColor: Global_red, textAlignment: .center, text: "", ishaveBorder: false,view: self.contentView)
        
        //增加利率
        addRateLabel = setupLabel(SCREEN_WIDTH / 4 - 8, y: rateLabel.y - 2, width: SCREEN_WIDTH / 4, height: 17, font: 15 * SCREEN_SCALE_W, textColor: Global_red, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        
        //期限
        deadlineLabel = setupLabel(SCREEN_WIDTH / 2 + 5, y: rateLabel.y , width: SCREEN_WIDTH / 4, height: rateLabel.height, font: 35, textColor: Default_All6_Color, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
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
    
    //MARK: - label 自适应宽度
    func newSize(_ label:UILabel) -> CGFloat
    {
        let textSize = NSString(string: label.text!).size(attributes: [NSFontAttributeName : label.font!])
        return textSize.width
    }
    
    //MARK: - 设置Attribute
    func setAttributedString(_ superString:String,subString:String,attributeName:String,isSetFont:Bool,font:CGFloat,location:Int,length:Int,label:UILabel)
    {
        let attributedString = NSMutableAttributedString(string: superString)
        if isSetFont
        {
          attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        label.attributedText = attributedString
    }
    
    //MARK: - 设置label
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
