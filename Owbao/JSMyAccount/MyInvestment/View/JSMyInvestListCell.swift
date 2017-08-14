//
//  JSMyInvestListCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInvestListCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!       //产品名称
    @IBOutlet weak var productyStatusLabel: UILabel!    //产品状态
    @IBOutlet weak var incomeLabel: UILabel!        //到期收益
    @IBOutlet weak var rateLabel: UILabel!        //利率
    @IBOutlet weak var addRateLabel: UILabel!       //增加的利率
    @IBOutlet weak var investAmountLabel: UILabel!      //投资金额
    @IBOutlet weak var backCashTimeLabel: UILabel!      //回款日期
    @IBOutlet weak var backCashTitleLabel: UILabel!      //回款日期标题
    @IBOutlet weak var noviceRemarkLabel: UILabel!      //到期续投180天标
    
    var statusArr:[String] = []
    
    //赋值数据
    func configModel(_ model:MyInvestRowsModel)
    {
        productNameLabel.text = model.fullName
        
        //产品状态
        productyStatusLabel.text = setupProStatus(model.productStatus)
        
        incomeLabel.text = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.expireInterest),decimalPointType: 2, numVerification: false)

        let rate = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.rate),decimalPointType: 2, numVerification: false)
        setAttributedString(rate! + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 15, location: (rate?.characters.count)!, length: "%".characters.count, label: rateLabel)
       
        if model.activityRate != 0.00
        {
            let addRate = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.activityRate),decimalPointType: 1, numVerification: false)
            setAttributedString("+" + addRate! + "%", subString: "+", attributeName: NSFontAttributeName, isSetFont: true, font: 10, location: 0, length: "+".characters.count, label: addRateLabel)
            setAttributedString("+" + addRate! + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 10, location: ("+" + addRate!).characters.count, length: "%".characters.count, label: addRateLabel)
        }

        investAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.amount),decimalPointType: 1, numVerification: false)
        
        //回款日期
        if model.expireDate != 0
        {
            //待还款 已还款 有回款日期
            backCashTitleLabel.isHidden = false
            backCashTimeLabel.isHidden = false
            backCashTimeLabel.text = TimeStampToStringTypeNew(model.expireDate)
        }
        else
        {
            backCashTitleLabel.isHidden = true
            backCashTimeLabel.isHidden = true
        }
        
        //新手标特殊处理：
        if model.type == 1
        {
            if model.periodLabel != ""
            {
                noviceRemarkLabel.text = model.periodLabel
                noviceRemarkLabel.width = newSize(noviceRemarkLabel) + CGFloat(15.0)
                
                noviceRemarkLabel.layer.borderColor = Global_red.cgColor
                noviceRemarkLabel.layer.borderWidth = 1.0
                noviceRemarkLabel.layer.cornerRadius = 2.0
                noviceRemarkLabel.layer.masksToBounds = true
            }
        }
        else
        {
            noviceRemarkLabel.text = ""
        }
        
    }
    
    func setupProStatus(_ status:Int)-> String
    {
        productyStatusLabel.layer.cornerRadius = 12.0
        productyStatusLabel.layer.masksToBounds = true
        productyStatusLabel.layer.borderColor = Global_red.cgColor
        productyStatusLabel.layer.borderWidth = 1.0
        
        let dict = ["0":"投资中","1":"待还款","2":"投资失败","3":"已还款"]
        return dict["\(status)"]!
    }
    
    class func cellHeight()-> CGFloat
    {
        return 180
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    //MARK: - label 自适应宽度
    func newSize(_ label:UILabel) -> CGFloat
    {
        let textSize = NSString(string: label.text!).size(attributes: [NSFontAttributeName : label.font!])
        return textSize.width
    }
}
