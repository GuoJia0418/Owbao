//
//  InvestNewHandCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class JSInvestNewHandCell: UITableViewCell {

    var iconImageView:UIImageView!              //新 图标
    var titleLabel:UILabel!                     //标题
    var limitLabel:UILabel!                     //条件限制
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
    //MARK: 数据
    func configModel(_ model:HomeActivityAndNewHandModel?,newHandString:String)
    {
        titleLabel.text = model!.fullName
        titleLabel.size = newSize(titleLabel)
        
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
    }
    
    //MARK: - label 自适应高度
    func newSize(_ label:UILabel) -> CGSize
    {
        let textSize = NSString(string: label.text!).size(attributes: [NSFontAttributeName : label.font!])
        return textSize
    }
    
    //创建UI
    func setupChildUI()
    {
        //背景色
        self.contentView.backgroundColor = UIColor.white
        
        let bgViewH = 48 * SCREEN_SCALE_W
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bgViewH))
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        //图标
        iconImageView = UIImageView(image: UIImage(named: "js_newhand_icon"))
        iconImageView.size = (iconImageView.image?.size)!
        iconImageView.origin = CGPoint(x: 15, y: (bgViewH - iconImageView.height) / 2)
        bgView.addSubview(self.iconImageView!)
        
        //标名称
        titleLabel = self.setupLabel(iconImageView.width + iconImageView.x + 8, y: (bgViewH - 15 * SCREEN_SCALE_W) / 2, width: SCREEN_WIDTH / 3, height: 15 * SCREEN_SCALE_W, font: 15, textColor: Default_All3_Color, textAlignment: .left, text: "",ishaveBorder: false,view: bgView)
        
        //限投
        limitLabel = setupLabel(titleLabel.x + titleLabel.width + 20, y: (bgViewH - 20) / 2, width: 50 * SCREEN_SCALE_W, height: 20, font: 10, textColor: DEFAULT_REDCOLOR, textAlignment: .center, text: "",ishaveBorder: true,view: bgView)
        
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
        pertLabel.font = UIFont.systemFont(ofSize: 12 * SCREEN_WIDTH / 320)
        pertLabel.numberOfLines = 2
        pertLabel.text = "去抢购"
        pertLabel.textColor = DEFAULT_TRACK
        self.contentView.addSubview(pertLabel!)
        
//        self.pertProgressView.hidden = true
//        self.pertLabel.hidden = true
        
        //线条
        let lineLabel2 = setupLabel(rateLabel.x, y: rateLabel.y + rateLabel.height + 14 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 2 * rateLabel.x, height: 1 * SCREEN_SCALE_W, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false,view:self.contentView)
        lineLabel2.backgroundColor = DEFAULT_GRAYCOLOR

        //起投金额
        leastAmountLabel = setupLabel(rateLabel.x, y: lineLabel2.y + lineLabel2.height + 10 * SCREEN_SCALE_W, width: SCREEN_WIDTH / 4, height: 12 * SCREEN_SCALE_W, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        //竖线1
        let verticalLine1 = setupLabel(leastAmountLabel.x + leastAmountLabel.width, y: leastAmountLabel.y, width: 1, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        verticalLine1.backgroundColor = VERTICALLINE_BGCOLOR
        
        //计息方式
        investBearingLabel = setupLabel(verticalLine1.x + verticalLine1.width, y: leastAmountLabel.y, width: leastAmountLabel.width, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        //竖线2
        let verticalLine2 = setupLabel(investBearingLabel.x + investBearingLabel.width, y: leastAmountLabel.y, width: 1, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        verticalLine2.backgroundColor = VERTICALLINE_BGCOLOR
        
        //多重保障
        protectionLabel = setupLabel(verticalLine2.x + verticalLine2.width, y: leastAmountLabel.y, width: leastAmountLabel.width, height: leastAmountLabel.height, font: 12 * SCREEN_SCALE_W, textColor: Default_All6_Color, textAlignment: .center, text: "", ishaveBorder: false, view: self.contentView)
        
        let bgView1 = UIView(frame: CGRect(x: 0, y: protectionLabel.y + protectionLabel.height + 10 * SCREEN_SCALE_W, width: SCREEN_WIDTH, height: 10 * SCREEN_SCALE_W))
        bgView1.backgroundColor = DEFAULT_BGCOLOR
        self.contentView.addSubview(bgView1)
        
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
