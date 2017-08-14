//
//  JSMyCouponCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyCouponCell: UITableViewCell {

    @IBOutlet weak var couponImgView: UIImageView!      //优惠券背景色
    @IBOutlet weak var amountLabel: UILabel!    //优惠券金额
    @IBOutlet weak var couponNameLabel: UILabel!    //优惠券类型
    
    @IBOutlet weak var couponSourceLabel: UILabel!  //优惠券来源
    @IBOutlet weak var couponLimitLabel: UILabel!   //优惠券使用条件
    @IBOutlet weak var couponValidPeriodLabel: UILabel!        //优惠券有效期
    
    //MARK: - 数据
    //新增的参数: isQualifiedCoupon,该红包是否合格，，true可用，最低使用额 <= 用户输入金额 false不可用，最低使用额 > 用户输入金额
    func setupModel(_ model:MyCouponsListModel)
    {
        if model.type == 1 //返现券
        {
            couponImgView.image = UIImage(named: "js_cash_coupon")
            
            //金额/比例
            let amountString : NSMutableAttributedString = NSMutableAttributedString.init(string:"¥\((model.amount.thousandPoint()))")
            amountString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(0, 1))
            amountLabel.attributedText = amountString
            
            couponNameLabel.text = "返现红包"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.enableAmount)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "单笔投资满" + limitStr! + "元," + "投资期限≥\(model.productDeadline)天(活动标除外)"
            couponLimitLabel.numberOfLines = 0
            
        }
        else if model.type == 2 //加息券
        {
            couponImgView.image = UIImage(named: "js_add_rate_coupon")
            
            //金额、比例
            amountLabel.textColor = UIColor.white
            let amountStringT : NSMutableAttributedString = NSMutableAttributedString.init(string:"\((model.raisedRates.thousandPoint()))%")
            amountStringT.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringT.length - 1, 1))
            amountLabel.attributedText = amountStringT
            
            couponNameLabel.text = "加息券"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.enableAmount)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "单笔投资满" + limitStr! + "元," + "投资期限≥\(model.productDeadline)天(活动标除外)"
            
        }
        else if model.type == 4 //翻倍券
        {
            couponImgView.image = UIImage(named: "js_double_coupon")
            
            //金额/比例
            let multipleStr = PD_NumDisplayStandard.numDisplayStandard("\(model.multiple)", decimalPointType: 1, numVerification: false)
            let sumMultipleStr = multipleStr! + "倍"
            let amountStringF:NSMutableAttributedString = NSMutableAttributedString(string: sumMultipleStr)
            amountStringF.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringF.length - 1, 1))
            amountLabel.attributedText = amountStringF
            couponNameLabel.text = "翻倍券"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.multiple)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "基础利率翻" + limitStr! + "倍," + "投资期限≥\(model.productDeadline)天(活动标除外)"
        }
        
        //来源
        couponSourceLabel.text = (model.remark)!
        
        //有效期
        couponValidPeriodLabel.text = "有效期至: \(TimeStampToStringTypeFive(model.expireDate))"
        
    }
    
    //MARK: - 失效优惠券
    func invalidCouponModel(_ model:MyCouponsListModel)
    {
        couponImgView.image = UIImage(named: "js_gray_coupon")
        
        if model.type == 1 //返现券
        {
            //金额/比例
            let amountString : NSMutableAttributedString = NSMutableAttributedString.init(string:"¥\(model.amount.thousandPoint())")
            amountString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(0, 1))
            amountLabel.attributedText = amountString
            
            couponNameLabel.text = "返现红包"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.enableAmount)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "单笔投资满" + limitStr! + "元," + "投资期限≥\(model.productDeadline)天(活动标除外)"
            
        }
        else if model.type == 2 //加息券
        {
            //金额、比例
            amountLabel.textColor = UIColor.white
            let amountStringT : NSMutableAttributedString = NSMutableAttributedString.init(string:"\((model.raisedRates.thousandPoint()))%")
            amountStringT.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringT.length - 1, 1))
            amountLabel.attributedText = amountStringT
            
            couponNameLabel.text = "加息券"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.enableAmount)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "单笔投资满" + limitStr! + "元," + "投资期限≥\(model.productDeadline)天(活动标除外)"
            
        }
        else if model.type == 4 //翻倍券
        {
            //金额/比例
            let multipleStr = PD_NumDisplayStandard.numDisplayStandard("\(model.multiple)", decimalPointType: 1, numVerification: false)
            let sumMultipleStr = multipleStr! + "倍"
            let amountStringF:NSMutableAttributedString = NSMutableAttributedString(string: sumMultipleStr)
            amountStringF.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), range: NSMakeRange(amountStringF.length - 1, 1))
            amountLabel.attributedText = amountStringF
            
            couponNameLabel.text = "翻倍券"
            
            //使用条件
            let limitStr = PD_NumDisplayStandard.numDisplayStandard("\(model.multiple)", decimalPointType: 1, numVerification: false)
            couponLimitLabel.text = "基础利率翻" + limitStr! + "倍," + "投资期限≥\(model.productDeadline)天(活动标除外)"
        }
        
        //来源
        couponSourceLabel.text = (model.remark)!
        
        //有效期
        couponValidPeriodLabel.text = "有效期至: \(TimeStampToStringTypeFive(model.expireDate))"
    }
    
    //MARK: - cell 高
    class func cellHeight() ->CGFloat
    {
        return 115
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
