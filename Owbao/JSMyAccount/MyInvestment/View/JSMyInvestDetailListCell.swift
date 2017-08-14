//
//  JSMyInvestDetailListCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInvestDetailListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var messageLabel: UILabel!
    
    var titleArr:[String] = []
    
    //MARK: - section == 0
    func setupModel(_ model:MyInvestRowsModel,section:Int)
    {
        if section == 0
        {
            titleLabel.text = model.productType == 1 ? "礼品信息" : "抽奖信息"
            messageLabel.text = model.prizeName
            messageLabel.textAlignment = .right
        }
        else
        {
            titleLabel.text = "产品详情"
            messageLabel.text = ""
        }
    }
    
    //MARK: - section == 1
    func configModel(_ model:MyInvestRowsModel,row:Int)
    {
       titleLabel.text = titleArr[row]
        
        switch row {
        case 0:
            
            let rate = (PD_NumDisplayStandard.numDisplayStandard("\(model.rate)", decimalPointType: 1, numVerification: false))! + "%"
            if model.activityRate != 0
            {
                let addRate = model.activityRate
                let addRateStr = "+" + (PD_NumDisplayStandard.numDisplayStandard("\(addRate)", decimalPointType: 1, numVerification: false))! + "%"
                messageLabel.text = rate + addRateStr
            }
            else
            {
                messageLabel.text = rate
            }
            break
        case 1://期限
            messageLabel.text = "\(model.deadline)天"
            break
        case 2: //还款方式
            messageLabel.text = model.repayType == 1 ? "到期还本付息" : "按月付息到期还本"
            break
        case 3: //投资金额
            messageLabel.text = (PD_NumDisplayStandard.numDisplayStandard("\(model.amount)",decimalPointType: 1, numVerification: false))! + "元"
            break
        case 4: //应收本金
            messageLabel.text = (PD_NumDisplayStandard.numDisplayStandard("\((model.factAmount))",decimalPointType: 1, numVerification: false))! + "元"
            break
        case 5: //应收利息
            messageLabel.text = (PD_NumDisplayStandard.numDisplayStandard("\(model.factInterest)",decimalPointType: 1, numVerification: false))! + "元"
            break
        case 6: //投资日期
            messageLabel.text = "\(TimeStampToStringTypeNew(model.investTime))"
            break
        case 7: //计息日期
            messageLabel.text = "\(TimeStampToStringTypeNew(model.interestTime))"
            break
        case 8: //回款日期
            messageLabel.text = "\(TimeStampToStringTypeNew(model.expireDate))"
            break
        case 9:
            switch model.couponType as Int!{
            case 1:
                messageLabel.text = "返现" + (PD_NumDisplayStandard.numDisplayStandard("\(model.couponAmount)", decimalPointType: 0, numVerification: false))! + "元"
                break
            case 2:
                messageLabel.text = "加息" + (PD_NumDisplayStandard.numDisplayStandard("\(model.couponRate)", decimalPointType: 1, numVerification: false))! + "％"
                break
            case 3:
                messageLabel.text = "体验金" + (PD_NumDisplayStandard.numDisplayStandard("\(model.couponAmount)", decimalPointType: 0, numVerification: false))! + "元"
                break
            case 4:
                let multipleStr = PD_NumDisplayStandard.numDisplayStandard("\(model.multiple)", decimalPointType: 1, numVerification: false)
                messageLabel.text = "\((multipleStr)!)倍翻倍券"
                break
            default:
                return
               }
            break
        default:
           return
        }
    }
    
    
    class func cellHeight()->CGFloat
    {
        return 49 * SCREEN_SCALE_W
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleArr = ["历史年化收益率","投资期限","还款方式","投资金额","应收本金","应收利息","投资日期","计息日期","回款日期","优惠券"]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
