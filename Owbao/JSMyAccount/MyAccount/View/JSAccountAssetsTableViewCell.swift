//
//  JSAccountAssetsTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSAccountAssetsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.indicatorView != nil {
            self.indicatorView.layer.cornerRadius = 6
            self.indicatorView.layer.masksToBounds = true
        }
    }

    //****************** 第二个xib ******************//
    @IBOutlet weak var topNameLabel: UILabel! //顶部名字label
    @IBOutlet weak var bottomtimeLabel: UILabel! //底部名字label
    @IBOutlet weak var rightMoneyLabel_xib_1: UILabel! //右部显示金额label
    
    class func cellHeight_secondXib() -> CGFloat {
        return 80
    }
    
    func configureCell_xib_1_WithModel(_ rowsModel: JSAccumulatedIncomeRowsModel?) -> () {
        
        if rowsModel != nil {
            self.topNameLabel.text = (rowsModel?.remark)!
            self.bottomtimeLabel.text = "\(TimeStampToString((rowsModel?.addTime)!, isHMS: true))"
            self.rightMoneyLabel_xib_1.text = PD_NumDisplayStandard.numDisplayStandard("\((rowsModel?.amount)!)", decimalPointType: 1, numVerification: false)
        }
    }
    
    //交易明细控制器用到的
    func configureCell_xib_1_WithMyAssetRowsModel(_ rowsModel: MyAssetRowsModel?) -> () {
        
        if rowsModel != nil {
            
            self.bottomtimeLabel.text = "\(TimeStampToString((rowsModel?.addTime)!, isHMS: true))"

            if rowsModel?.type == 0 {
                self.rightMoneyLabel_xib_1.text = "-" + PD_NumDisplayStandard.numDisplayStandard("\((rowsModel?.amount)!)", decimalPointType: 1, numVerification: false)
                self.rightMoneyLabel_xib_1.textColor = UIColor.lightGray
            } else if rowsModel?.type == 1 {
                self.rightMoneyLabel_xib_1.text = "+" + PD_NumDisplayStandard.numDisplayStandard("\((rowsModel?.amount)!)", decimalPointType: 1, numVerification: false)
                self.rightMoneyLabel_xib_1.textColor = Global_red
            }
            
            //1=充值，2=提现，3=投资，4=活动,5=提现手续费，6=回款,,7=体验金
            if rowsModel?.tradeType == 1 {
                self.topNameLabel.text = "充值"
            } else if rowsModel?.tradeType == 2 {
                self.topNameLabel.text = "提现"
            } else if rowsModel?.tradeType == 3 {
                self.topNameLabel.text = "投资"
            } else if rowsModel?.tradeType == 4 {
                self.topNameLabel.text = "活动"
            } else if rowsModel?.tradeType == 5 {
                self.topNameLabel.text = "提现手续费"
            } else if rowsModel?.tradeType == 6 {
                self.topNameLabel.text = "回款"
            } else if rowsModel?.tradeType == 7 {
                self.topNameLabel.text = "体验金"
            } else {
                self.topNameLabel.text = "暂无"
            }
        }
    }
    
    //****************** 第三个xib ******************//
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var rightMoneyLabel_xib_2: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!  //红色标志label
    
    @IBOutlet weak var rightArrowImageView: UIImageView! //箭头
    @IBOutlet weak var indicatorRightLabel: UILabel!     //立即开通
    
    
    @IBOutlet weak var indicatorView_centenConstains: NSLayoutConstraint!
    @IBOutlet weak var rightMoneyLabel_xib_2_centenConstaiins: NSLayoutConstraint!
    @IBOutlet weak var leftNameLabel_centenConstains: NSLayoutConstraint!
    
    class func cellHeight_thirdXib() -> CGFloat {
        return 80.0
    }
    
    /**
     * cellIndex: 0待收本金 1待收收益 2可用余额
     * fundsModel: 总资产模型
     *
     */
    func configureCell_xib_2_WithModel(_ cellIndex: Int,
                                       fundsModel: MyAssetsFundsModel,
                                       isFuiou: Int) -> () {
        
        if cellIndex == 0 {
            
            self.indicatorView.backgroundColor = UIColorFromRGB(251, green: 162, blue: 32)
            self.leftNameLabel.text = "存管账户余额"
            self.rightMoneyLabel_xib_2.text = PD_NumDisplayStandard.numDisplayStandard("\(fundsModel.fuiou_balance)", decimalPointType: 1, numVerification: false)
            
            if isFuiou == 0 {
                self.indicatorRightLabel.isHidden = false
                self.rightArrowImageView.isHidden = false
                self.rightMoneyLabel_xib_2.isHidden = true
            } else {
                self.indicatorRightLabel.isHidden = true
                self.rightArrowImageView.isHidden = true
            }
            
        } else if cellIndex == 1 {
            
            self.indicatorView.backgroundColor = UIColorFromRGB(251, green: 162, blue: 32)
            self.leftNameLabel.text = "平台账户余额"
            self.rightMoneyLabel_xib_2.text = PD_NumDisplayStandard.numDisplayStandard("\(fundsModel.balance)", decimalPointType: 1, numVerification: false)
            
            self.indicatorView_centenConstains.constant = -10
            self.rightMoneyLabel_xib_2_centenConstaiins.constant = -10
            self.leftNameLabel_centenConstains.constant = -10
            self.indicatorLabel.isHidden = false
            
            if IS_PHONE_WIDTH_320 { 
                self.indicatorLabel.text = "*平台账户余额现只可提现。"
            }
            
        } else if cellIndex == 2 {
            
            self.indicatorView.backgroundColor = UIColorFromRGB(238, green: 81, blue: 64)
            self.leftNameLabel.text = "待收本金"
            self.rightMoneyLabel_xib_2.text = PD_NumDisplayStandard.numDisplayStandard("\(fundsModel.wprincipal)", decimalPointType: 1, numVerification: false)
            
        } else if cellIndex == 3 {
            
            self.indicatorView.backgroundColor = UIColorFromRGB(31, green: 159, blue: 126)
            self.leftNameLabel.text = "待收收益"
            self.rightMoneyLabel_xib_2.text = PD_NumDisplayStandard.numDisplayStandard("\(fundsModel.winterest)", decimalPointType: 1, numVerification: false)
        }
    }
}
