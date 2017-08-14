//
//  SelectCouponCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/16.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class SelectCouponCell: UITableViewCell {
    
    var cardImageView: UIImageView!               //红包背景图
    var amountLabel: UILabel!                     //券的金额或比率
    var couponTypeLabel: UILabel!                 //券的类型
    var couponSourceLabel: UILabel!               //券的来源
    var conditionsLabel: UILabel!                 //使用条件
    var lineView: UIImageView!                    //灰色的线条
    var expireDateLabel: UILabel!                 //有效日期

    var maxProfitImgView: UIImageView!           //最大收益标志
    var maxProfitLabel: UILabel!                 //最大收益label
    var selectedButton: UIButton!                //选中button
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = DEFAULT_CELLCOLOR
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化UI
    func createUI() {
        
        self.selectionStyle = .none
        
        let cardWidth = SCREEN_WIDTH - 10
        let cardHeight = 105 * SCREEN_SCALE_W
        let cardX = CGFloat(5)
        
        //背景图
        cardImageView = UIImageView(frame:CGRect(x:cardX,y: 0,width: cardWidth,height: cardHeight))
        cardImageView.image = UIImage(named: "js_gray_coupon")
        self.contentView.addSubview(cardImageView)

        //最大收益
        maxProfitImgView = UIImageView(image: UIImage(named: "js_coupon_angle_icon"))
        maxProfitImgView.size = (maxProfitImgView.image?.size)!
        maxProfitImgView.origin = CGPoint(x: cardWidth - maxProfitImgView.width - 1, y: 1)
        cardImageView.addSubview(maxProfitImgView)
        
        //最大收益label
        maxProfitLabel = setupLabel(5, y: 12, width: maxProfitImgView.width, height: 10 * SCREEN_SCALE_W, font: 10, textColor: UIColor.white, textAlignment: .center, text: "最大收益", ishaveBorder: false, view: maxProfitImgView)
        maxProfitLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        
        let labelW = (SCREEN_WIDTH - 10) / 3
        let labelH = (cardHeight - 40) / 3
        
        //金额
        amountLabel = setupLabel(0, y: 10, width: labelW, height: labelH * 2, font: 35, textColor: UIColor.white, textAlignment: .center, text: "￥100", ishaveBorder: false, view: cardImageView)
        
        //券的类型
        couponTypeLabel = setupLabel(0, y: amountLabel.y + amountLabel.height, width: amountLabel.width, height: labelH, font: 15, textColor: UIColor.white, textAlignment: .center, text: "返现红包", ishaveBorder: false, view: cardImageView)
        
        //券的来源
        let labelHeight = 12 * SCREEN_SCALE_W
        let labelMargin = CGFloat(10)
        let labelX = labelW + 10
        let labelWidth = (SCREEN_WIDTH - 38) / 3 * 2
        
        couponSourceLabel = setupLabel(labelX, y: labelMargin, width: labelWidth, height: labelHeight, font: 13, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .left, text: "", ishaveBorder: false, view: cardImageView)
        
        //使用条件
        conditionsLabel = setupLabel(couponSourceLabel.x, y: couponSourceLabel.y + couponSourceLabel.height + labelMargin, width: couponSourceLabel.width, height: couponSourceLabel.height * 3, font: 12, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .left, text: "", ishaveBorder: false, view: cardImageView)
        conditionsLabel.numberOfLines = 0
        
        //线条
        lineView = UIImageView(frame: CGRect(x: couponSourceLabel.x, y: conditionsLabel.height + conditionsLabel.y + 5, width: couponSourceLabel.width, height: 1))
        lineView.image = UIImage(named: "coupon_line")
        cardImageView.addSubview(lineView)
        
        //有效期至
        expireDateLabel = setupLabel(couponSourceLabel.x, y: lineView.y + lineView.height + labelMargin, width: couponSourceLabel.width / 3 * 2, height: couponSourceLabel.height, font: 11, textColor: UIColorFromRGB(126, green: 126, blue: 126), textAlignment: .left, text: "有效期至：", ishaveBorder: false, view: cardImageView)
        
        //选中按钮
        selectedButton = UIButton(type: .custom)
        selectedButton.setBackgroundImage(UIImage(named: "js_coupon_selected_icon"), for: UIControlState())
        selectedButton.size = CGSize(width: 25, height: 25)
        selectedButton.origin = CGPoint(x: cardImageView.width - selectedButton.size.width - 5, y: expireDateLabel.y - 5)
        selectedButton.isHidden = true
        cardImageView.addSubview(selectedButton)
    }

    func setupLabel(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,font:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,text:String,ishaveBorder:Bool,view:UIView) -> UILabel {
        
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
    
    //设置Attribute
    func setAttributedString(_ superString:String,subString:String,attributeName:String,isSetFont:Bool,font:CGFloat,location:Int,length:Int,label:UILabel) {
        
        let attributedString = NSMutableAttributedString(string: superString)
        if isSetFont {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        label.attributedText = attributedString
    }
    
    //根据模型配置数据 ,selectListModel: 选中的模型，用来确认是否被选中
    func configureCellWithCouponModel(_ listModel: MyCouponsListModel?,selectListModel: MyCouponsListModel?) -> () {
        
        if listModel != nil  {
            self.setViewBackgroundColorAmountLabelTextWithType(listModel!)
            self.couponSourceLabel.text = listModel?.name
            self.expireDateLabel.text = "有效期至：\(TimeStampToString((listModel?.expireDate)!, isHMS: false))"
            
            if selectListModel != nil {
                
                if selectListModel?.id == listModel?.id {
                    selectedButton.isHidden = false
                } else {
                    selectedButton.isHidden = true
                }
            }
        }
    }
    
    //这里只设置不同的
    func setViewBackgroundColorAmountLabelTextWithType(_ listModel: MyCouponsListModel) -> () {
        
        switch listModel.type {
        case 1:  //返现券
            cardImageView.image = UIImage(named: "js_cash_coupon")
            couponTypeLabel.text = "返现券"
            
            //设置返现券金额
            let amountString : NSMutableAttributedString = NSMutableAttributedString.init(string:"¥\((listModel.amount.thousandPoint()))")
            amountString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(0, 1))
            amountLabel.attributedText = amountString
            
            //使用条件
            conditionsLabel.text = "单笔投资满\(listModel.enableAmount)元,投资期限≥\(listModel.productDeadline)天(活动标除外)"
            
            break
        case 2:  //加息券
            cardImageView.image = UIImage(named: "js_add_rate_coupon")
            couponTypeLabel.text = "加息券"
            
            //设置加息券比例
            let amountStringT : NSMutableAttributedString = NSMutableAttributedString.init(string:"+\((listModel.raisedRates.thousandPoint()))%")
            amountStringT.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringT.length - 1, 1))
            amountLabel.attributedText = amountStringT
            
            //使用条件
            conditionsLabel.text = "单笔投资满\(listModel.enableAmount)元,投资期限≥\(listModel.productDeadline)天(活动标除外)"
            
            break
        case 3:   //体验金暂时没有
            break
        case 4:  //翻倍全
            cardImageView.image = UIImage(named: "js_double_coupon")
            couponTypeLabel.text = "翻倍券"
            //设置翻倍券
            let string = "\(PD_NumDisplayStandard.numDisplayStandard("\(listModel.multiple)", decimalPointType: 1, numVerification: false)!)倍"
            
            let amountStringF : NSMutableAttributedString = NSMutableAttributedString(string: string)
            amountStringF.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringF.length - 1, 1))
            amountLabel.attributedText = amountStringF
            
            //使用条件
            conditionsLabel.text = "基础利率\(listModel.multiple)倍,投资期限≥\(listModel.productDeadline)天(活动标除外)"
            break
        default:
            break
        }
        
        if listModel.status == 3 { //因这里不会查询出来已使用和已失效的券，所以只有两种，0未使用，3不可使
            cardImageView.image = UIImage(named: "js_gray_coupon")
        }
    }
    
}
