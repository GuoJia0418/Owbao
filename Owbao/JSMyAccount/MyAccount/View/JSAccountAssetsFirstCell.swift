//
//  JSAccountAssetsFirstCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSAccountAssetsFirstCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //****************** 第一个xib ******************//
    @IBOutlet weak var profitHeadLabel: UILabel!     //累计收益上面标题label
    @IBOutlet weak var profitLabel: UILabel!         //累计收益label
    @IBOutlet weak var bottomLeftLabel: UILabel!     //左下角的label
    @IBOutlet weak var waveAnimationView: JSWaveAnimateView!
    
    class func cellHeight_firstXib() -> CGFloat {
        return 213.0
    }
    
    /**
     * segmentIndex: 0表示是总资产里面的cell，1表示是累计资产界面的cell
     * fundsModel: 总资产模型，当segmentIndex为0会用到
     * accumulatedIncomeMapModel: ；累计收益模型,当segmentIndex为1会用到
     */
    func configureCell_xib_0_WithModel(_ segmentIndex: Int,fundsModel: MyAssetsFundsModel?,accumulatedIncomeMapModel: JSAccumulatedIncomeMapModel?) -> () {
        if segmentIndex == 0 {
            
            self.profitHeadLabel.text = "我的资产(元)"
            self.bottomLeftLabel.text = "资金明细"
            
            if fundsModel != nil {
                let money = fundsModel!.freeze +
                    fundsModel!.wprincipal +
                    fundsModel!.balance +
                    fundsModel!.fuiou_balance +
                    fundsModel!.fuiou_freeze//待收本金 + 冻结资金 + 平台余额 + 存管账户余额
                self.profitLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(money)", decimalPointType: 1, numVerification: false)
            }
            
        } else {
            self.profitHeadLabel.text = "累计收益(元)"
            self.bottomLeftLabel.text = "类型/日期"
            
            if accumulatedIncomeMapModel != nil {
                self.profitLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(accumulatedIncomeMapModel!.AccumulatedIncome)", decimalPointType: 1, numVerification: false)
            }
        }
    }
    
}
