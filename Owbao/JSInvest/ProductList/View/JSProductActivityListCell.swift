//
//  JSProductActivityListCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/17.
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


class JSProductActivityListCell: UITableViewCell {

    var iconImageView:UIImageView!              //新 图标
    var titleLabel:UILabel!                     //标题
    var limitLabel:UILabel!                     //条件限制
    var limitsLabel:UILabel!
    var doubleLimitLabel:UILabel!               //翻倍券
    var rateTitleLabel:UILabel!                 //历史年化收益率
    var rateLabel:UILabel!                      //基础利率
    var addRateLabel:UILabel!                   //增加利率
    var deadlineTitleLabel:UILabel!             //期限
    var deadlineLabel:UILabel!                  //期限
    var pertProgressView:KDCircularProgress!    //募集进度的圆圈
    var pertLabel:UILabel!                      //募集进度
    var leastAmountLabel:UILabel!               //起投金额
    var investBearingLabel:UILabel!             //计息方式
    var protectionLabel:UILabel!                //多重保障
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupChildUI()
    }
    
    //MARK: - 设置model
    func refreshView(_ model:InvestmentRowModel?){
        
        //标的标题 红包 加息券 翻倍券
        self.setCouponsLabel(model)
        
        
        
        
        if model?.atid != 0
        {
            iconImageView.image = UIImage(named: "js_cai_icon")
        }
        else
        {
            iconImageView.image = UIImage(named: "js_you_icon")
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
        
        //起投金额
        leastAmountLabel.text = "起投\(Int((model?.leastaAmount)!))元"
        investBearingLabel.text = "次日计息"
        protectionLabel.text = "多重保障"
        
        //        print("输出\(model?.isCash)==\(model?.isInterest)==\(model?.isDouble)==\(model!.id)")
        
        
        self.pertProgressView.angle = 0
        self.pertProgressView.animateToAngle((Int)(model!.pert * 3.60), duration: 1, completion: nil)
        
        if model!.status != 5
        {
            self.pertLabel.textColor             = TITLE_GRAYCOLOR
            self.pertProgressView.trackColor     = DEFAULT_PROCOLOR
            self.pertProgressView.progressColors = [DEFAULT_PROCOLOR]
            
            titleLabel.textColor = Default_All6_Color
            
            limitLabel.textColor = Default_Rate_Color
            limitLabel.layer.borderColor = Default_Rate_Color.cgColor
            limitsLabel.textColor = Default_Rate_Color
            limitsLabel.layer.borderColor = Default_Rate_Color.cgColor
            doubleLimitLabel.textColor = Default_Rate_Color
            doubleLimitLabel.layer.borderColor = Default_Rate_Color.cgColor
            
            rateLabel.textColor = DEFAULT_REDCOLOR
            addRateLabel.textColor = DEFAULT_REDCOLOR
            deadlineLabel.textColor = Default_Deadline_Color
            
            leastAmountLabel.textColor = Default_All9_Color
            investBearingLabel.textColor = Default_All9_Color
            protectionLabel.textColor = Default_All9_Color
            
            if model!.status == 6 {
                self.pertLabel.text = "抢完了"
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
            
            titleLabel.textColor = Default_All3_Color
            
            limitLabel.textColor = DEFAULT_REDCOLOR
            limitLabel.layer.borderColor = DEFAULT_REDCOLOR.cgColor
            limitsLabel.textColor = DEFAULT_REDCOLOR
            limitsLabel.layer.borderColor = DEFAULT_REDCOLOR.cgColor
            doubleLimitLabel.textColor = DEFAULT_REDCOLOR
            doubleLimitLabel.layer.borderColor = DEFAULT_REDCOLOR.cgColor
            
            rateLabel.textColor = DEFAULT_REDCOLOR
            addRateLabel.textColor = DEFAULT_REDCOLOR
            deadlineLabel.textColor = Default_All6_Color
            
            leastAmountLabel.textColor = Default_All6_Color
            investBearingLabel.textColor = Default_All6_Color
            protectionLabel.textColor = Default_All6_Color
            
            
            if model!.pert >= 99.00 && model!.pert < 100.00 {
                //                self.pertLabel.text = "99%"
                self.pertLabel.text = "去抢购"
            } else {
                self.pertLabel.text = "去抢购"
            }
            
        }
        
    }
    
    //MARK: - 标题、红包、加息券、翻倍券
    func setCouponsLabel(_ model:InvestmentRowModel?)
    {
        //标的标题
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
        
        //投即送 、 iphone7标签
        if model?.investSendLabel != nil && model?.investSendLabel != ""
        {
            limitsLabel.isHidden = true
            doubleLimitLabel.isHidden = true
            limitLabel.x = titleLabel.width + titleLabel.x + 20
            
            if model?.atid != 0
            {//财胜标
                if model?.fullName?.characters.count > 15
                {
                    limitLabel.isHidden = true
                    limitsLabel.isHidden = true
                    doubleLimitLabel.isHidden = true
                }
                else
                {
                    limitLabel.width = 75 * SCREEN_SCALE_W
                    limitLabel.text = model?.investSendLabel
                }
                
            }
            else
            {//投即送
                if model?.fullName?.characters.count > 15
                {
                    limitLabel.isHidden = true
                    limitsLabel.isHidden = true
                    doubleLimitLabel.isHidden = true
                }
                else
                {
                    limitLabel.width = 35 * SCREEN_SCALE_W
                    limitLabel.text = model?.investSendLabel
                }
            }
        }
        else
        {
            if model?.fullName?.characters.count > 15
            {
                limitLabel.isHidden = true
                limitsLabel.isHidden = true
                doubleLimitLabel.isHidden = true
            }
            else
            {
                limitsLabel.isHidden = false
                doubleLimitLabel.isHidden = false
                limitLabel.width = 35 * SCREEN_SCALE_W
                limitsLabel.width = limitLabel.width
                doubleLimitLabel.width = limitLabel.width
                
                limitLabel.text = "红包"
                limitLabel.x = titleLabel.width + titleLabel.x + 20
                limitsLabel.x = limitLabel.x + limitLabel.width + 10
                doubleLimitLabel.x = limitsLabel.x + limitsLabel.width + 10
                
                //红包 加息券 翻倍券
                let w = 35 * SCREEN_SCALE_W
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
            
            
            //红包、加息券、翻倍券是否超出屏幕宽度
            limitLabel.isHidden =  self.couponLabelHidden(limitLabel)
            limitsLabel.isHidden = self.couponLabelHidden(limitsLabel)
            doubleLimitLabel.isHidden = self.couponLabelHidden(doubleLimitLabel)
            
        }
        
    }
    
    //MARK: 红包、加息券、翻倍券是否超出屏幕宽度 是否隐藏
    func couponLabelHidden(_ label:UILabel)->Bool
    {
        
        return label.x + label.width > SCREEN_WIDTH ? true : false
    }
    
    //MARK: 创建UI
    func setupChildUI()
    {
        //背景色
        self.contentView.backgroundColor = UIColor.white
        
        let bgViewH = 48 * SCREEN_SCALE_W
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bgViewH))
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        //图标
        iconImageView = UIImageView(image: UIImage(named: "js_you_icon"))
        iconImageView.size = (iconImageView.image?.size)!
        iconImageView.origin = CGPoint(x: 15, y: (bgViewH - iconImageView.height) / 2)
        bgView.addSubview(self.iconImageView!)
        
        //标名称
        titleLabel = self.setupLabel(iconImageView.width + iconImageView.x + 8 , y: (bgViewH - 15 * SCREEN_SCALE_W) / 2, width: SCREEN_WIDTH / 3, height: 15 * SCREEN_SCALE_W, font: 15, textColor: Default_All3_Color, textAlignment: .left, text: "",ishaveBorder: false,view: bgView)
        
        //限投
        limitLabel = setupLabel(titleLabel.x + titleLabel.width + 20, y: (bgViewH - 20) / 2, width: 38, height: 20, font: 10, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "红包",ishaveBorder: true,view: bgView)
        
        limitsLabel = setupLabel(limitLabel.x + limitLabel.width + 10, y: limitLabel.y, width: 38, height: limitLabel.height, font: 10, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "加息券", ishaveBorder: true, view:bgView)
        
        doubleLimitLabel = setupLabel(limitsLabel.x + limitsLabel.width + 10, y: limitsLabel.y, width: 38, height: limitLabel.height, font: 10, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "翻倍券", ishaveBorder: true, view: bgView)
        
        //线条
        let lineLabel = setupLabel(0, y: bgView.height + bgView.y, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel.backgroundColor = DEFAULT_GRAYCOLOR
        
        //基础利率
        rateTitleLabel = setupLabel(0, y: lineLabel.y + lineLabel.height + 14 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 3, height: 12 * SCREEN_SCALE_W, font: 12 * SCREEN_SCALE_W, textColor: Default_All9_Color, textAlignment: .center, text: "历史年化收益率", ishaveBorder: false, view: self.contentView)
        
        //基础利率
        rateLabel = setupLabel(rateTitleLabel.x , y: rateTitleLabel.height + rateTitleLabel.y + 20 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 3, height: 40 * SCREEN_SCALE_W, font: 28 * SCREEN_SCALE_W, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "", ishaveBorder: false,view: self.contentView)
        
        //增加利率
        addRateLabel = setupLabel(SCREEN_WIDTH / 4 - 5, y: rateLabel.y - 12 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 4, height: 17 * SCREEN_SCALE_W, font: 15 * SCREEN_SCALE_W, textColor: DEFAULT_REDCOLOR, textAlignment: .left, text: "", ishaveBorder: false,view: self.contentView)
        
        //期限
        deadlineTitleLabel = setupLabel(SCREEN_WIDTH / 3 + 10 * SCREEN_SCALE_W, y: rateTitleLabel.y, width: SCREEN_WIDTH / 3, height: 12 * SCREEN_SCALE_W, font: 12 * SCREEN_SCALE_W, textColor: Default_All9_Color, textAlignment: .center, text: "期限", ishaveBorder: false, view: self.contentView)
        
        //期限
        deadlineLabel = setupLabel(SCREEN_WIDTH / 3 + 10 * SCREEN_SCALE_W, y: rateLabel.y, width: SCREEN_WIDTH / 3, height: rateLabel.height, font: 22 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false,view: self.contentView)
        
        //圆圈
        pertProgressView = KDCircularProgress(frame: CGRect(x: SCREEN_WIDTH - (70 * SCREEN_SCALE_W), y: 70 * SCREEN_SCALE_W, width: 60 * SCREEN_SCALE_W, height: 60 * SCREEN_SCALE_W))
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = DEFAULT_TRACK//底部圈颜色
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
        
        //线条
        let lineLabel2 = setupLabel(rateLabel.x, y: rateLabel.y + rateLabel.height + 14 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 2 * rateLabel.x, height: 1 * SCREEN_SCALE_W, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel2.backgroundColor = DEFAULT_GRAYCOLOR
        
        //起投金额
        leastAmountLabel = setupLabel(rateLabel.x, y: lineLabel2.y + lineLabel2.height + 10 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 4, height: 12 * SCREEN_SCALE_W, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        //竖线1
        let verticalLine1 = setupLabel(leastAmountLabel.x + leastAmountLabel.width, y: leastAmountLabel.y, width: 1, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        verticalLine1.backgroundColor = VERTICALLINE_BGCOLOR
        
        //计息方式
        investBearingLabel = setupLabel(verticalLine1.x + verticalLine1.width, y: leastAmountLabel.y, width: leastAmountLabel.width, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        //竖线2
        let verticalLine2 = setupLabel(investBearingLabel.x + investBearingLabel.width, y: leastAmountLabel.y, width: 1, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        verticalLine2.backgroundColor = VERTICALLINE_BGCOLOR
        
        //多重保障
        protectionLabel = setupLabel(verticalLine2.x + verticalLine2.width, y: leastAmountLabel.y, width: leastAmountLabel.width, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        let bgView1 = UIView(frame: CGRect(x: 0, y: protectionLabel.y + protectionLabel.height + 10 * SCREEN_SCALE_W, width: SCREEN_WIDTH, height: 10 * SCREEN_SCALE_W))
        bgView1.backgroundColor = DEFAULT_BGCOLOR
        self.contentView.addSubview(bgView1)
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
