//
//  ProductDetailFirstCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ProductDetailFirstCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!      //利率
    @IBOutlet weak var addRateLabel: UILabel!   //增加的利率
    @IBOutlet weak var couponBgView: UIView!    //优惠券背景
    @IBOutlet weak var progressView: UIProgressView!
    

//    @IBOutlet weak var deadlineLabel: UILabel!          //期限
//    @IBOutlet weak var rateMethodLabel: UILabel!        //次日计息
//    @IBOutlet weak var repaymentMethodLabel: UILabel!   //还款方式
    
    @IBOutlet weak var investGiveIPhone7LabelWidthConstains: NSLayoutConstraint! //投资送iPhone7label宽度约束
    @IBOutlet weak var investGiveIPhone7Label: UILabel!   //投资送iPhone7label
    @IBOutlet weak var giveIPhone7BackgroundView: UIView! //投资送iPhone7label的背景图
    @IBOutlet weak var displaySubViewView: JSDisplaySubViewView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        investGiveIPhone7Label.layer.borderColor = UIColor.white.cgColor
        investGiveIPhone7Label.layer.borderWidth = 1.0
        investGiveIPhone7Label.layer.cornerRadius = 15
        investGiveIPhone7Label.layer.masksToBounds = true
    }
    
    //赋值数据
    func configModel(_ model: ProductDetailsModel?) {
        
        if model != nil && model?.map != nil {
            
            //利率
            let rate = PD_NumDisplayStandard.numDisplayStandard("\((model?.map?.info?.rate)!)", decimalPointType: 1, numVerification: false)
            self.setAttributedString(rate! + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 25 * SCREEN_SCALE_W, location: (rate?.characters.count)!,length:"%".characters.count,label:rateLabel)
            
            //活动利率
            //(model?.map?.specialRate)! + (model?.map?.info?.activityRate)! 没加specialRate
            if model?.map?.info?.activityRate != 0 {
                let addRate = "+" + PD_NumDisplayStandard.numDisplayStandard("\((model?.map?.info?.activityRate)!)", decimalPointType: 1, numVerification: false)
                self.setAttributedString(addRate + "%", subString: "%", attributeName: NSFontAttributeName, isSetFont: true, font: 15 * SCREEN_SCALE_W, location: addRate.characters.count, length: "%".characters.count, label: addRateLabel)
            } else {
                addRateLabel.text = ""
            }
            
            //*************************** 刷新带图片的标签view ********************//
            var array_display = [TitleModel]()
            
            let model_1 = TitleModel()
            model_1.title = "\((model?.map?.info?.deadline)!)天" //期限
            array_display.append(model_1)
            
            let model_2 = TitleModel()
            model_2.title = model?.map?.controllerType == .novice ? "满标后T+1计息" : "次日计息"
            array_display.append(model_2)
            
            //还款方式 1,到期付息还本，2每月付息到期还本
            let model_3 = TitleModel()
            model_3.title = (model?.map?.info?.repayType)! == 1 ? "到期付息还本" : "每月付息到期还本"
            array_display.append(model_3)
            
            self.displaySubViewView.reloadViewWith(modelArray: array_display)
            //*************************** 刷新带图片的标签view ********************//
            
            progressView.progress = 0
            progressView.setProgress(Float((model?.map?.info?.pert)!)/100.0, animated: true)

            //配置iPhone7标（与普通标界面不同）
            self.configureActivity(model)
            
            //配置优惠券
            var array = [TitleModel]()
            
            if (model?.map?.info?.isCash)! == 1 {
                let model = TitleModel()
                model.title = "红包"
                array.append(model)
            }
            
            if (model?.map?.info?.isInterest)! == 1 {
                let model = TitleModel()
                model.title = "加息券"
                array.append(model)
            }
            
            if (model?.map?.info?.isDouble)! == 1 {
                let model = TitleModel()
                model.title = "翻倍券"
                array.append(model)
            }
            
            if array.count > 0 && model?.map?.controllerType != .novice {
                self.configureDisplayLabelsView(array)
            }
        }
    }
    
    //配置iPhone7的标、投即送标的显示
    func configureActivity(_ model: ProductDetailsModel?) -> () {
        
        if model != nil {
            
            if model?.map?.controllerType == .iphone7 {    //iPhone7标没有加息、返现、双倍等标签
                
                self.giveIPhone7BackgroundView.isHidden = false
                self.couponBgView.isHidden = true
                
                //根据获取的文字宽度去设置label的cornerRadius达到设计图效果
                let textWidth = "投资白送iPhone7".getTextRectSize(UIFont.systemFont(ofSize: 15), size: CGSize(width: 3000, height: 20)).size.width
                self.investGiveIPhone7LabelWidthConstains.constant = textWidth + 20
                self.layoutIfNeeded()
                
            } else if model?.map?.controllerType == .investGive { //投即送标
                
                self.giveIPhone7BackgroundView.isHidden = false
                self.couponBgView.isHidden = true
                //显示
                self.investGiveIPhone7Label.text = model?.map?.prize?.name
    
                
                //根据获取的文字宽度去设置label的宽度
                let textWidth = model?.map?.prize?.name.getTextRectSize(UIFont.systemFont(ofSize: 15), size: CGSize(width: 3000, height: 20)).size.width
                self.investGiveIPhone7LabelWidthConstains.constant = textWidth! + 40
                self.layoutIfNeeded()
                
            } else { //普通标、新手标
                self.giveIPhone7BackgroundView.isHidden = true
                self.couponBgView.isHidden = false
            }
        }
    }
    
    func configureDisplayLabelsView(_ array: [TitleModel]) {
        
        let view = JSDisplayLabelsView()
        view.labelFont = 14
        view.labelTextColor = UIColor.white
        view.configureView(array)
        couponBgView.addSubview(view)
        
        let width = JSDisplayLabelsView.getWidth(array,
                                                 margin: 20,
                                                 labelFont: 14,
                                                 viewHeight: 25,
                                                 margin_title: 5)
        view.frame = CGRect(x: (SCREEN_WIDTH - 80.0 - width) / 2.0 ,y: 5, width: width, height: 25)
    }

    ///返回cell的高度
    class func cellHeight() -> CGFloat {
        
        return 185
    }
    
    //设置Attribute
    func setAttributedString(_ superString: String,
                             subString: String,
                             attributeName: String,
                             isSetFont: Bool,
                             font: CGFloat,
                             location: Int,
                             length: Int,
                             label: UILabel)
    {
        let attributedString = NSMutableAttributedString(string: superString)
        if isSetFont
        {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        label.attributedText = attributedString
    }
}
