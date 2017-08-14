//
//  JSInvestSuccessMessageCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestSuccessMessageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!        //信息标题
    @IBOutlet weak var contentLabel: UILabel!       //信息内容
    @IBOutlet weak var arrowImgView: UIImageView!   //箭头图标
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //iphone7标存在，需要显示cell，否则不显示
    class func numberRowForCell(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            if detailModel?.map?.controllerType == .iphone7 { //是iPhone7标
                return 1
            }
        }
        return 0
    }
    
    //用模型配置cell
    func configureCellWithDetailModel(_ detailModel: ProductDetailsModel?,indexPath: IndexPath?) -> () {
        
        
        if detailModel != nil && indexPath != nil {
           
            if indexPath!.section == 1 {
                
                self.titleLabel.text = "抽奖信息"
                self.contentLabel.text = "iPhone7"
                self.arrowImgView.isHidden = false
                
            } else if indexPath!.section == 2 {
                
                self.titleLabel.text = "投资项目"
                self.contentLabel.text = detailModel?.map?.info?.fullName
                self.arrowImgView.isHidden = true
                
            } else if indexPath!.section == 3 {
                
                self.titleLabel.text = "投资期限"
                self.contentLabel.text = "\((detailModel?.map?.info?.deadline)!)天"
                self.arrowImgView.isHidden = true
                
            } else if indexPath!.section == 4 {
                
                self.titleLabel.text = "回款日期"
                self.contentLabel.text = "\(TimeStampToString((detailModel?.map?.info?.expireDate)!, isHMS: false))"
                self.arrowImgView.isHidden = true
                
            } else if indexPath!.section == 5 {
                
                self.titleLabel.text = "到期本息"
                self.contentLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(self.getMoney(detailModel!))", decimalPointType: 1, numVerification: false) + "元"
                self.arrowImgView.isHidden = true
            }
        }
    }
    
    //算出本金加利息
    func getMoney(_ detailModel: ProductDetailsModel) -> Double {
        
            //detailModel是必选的,selectCouponModel是可选的
            var profitValue_1 = 0.00
            var profitValue_2 = 0.00
        
            let rate = (detailModel.map?.info?.rate)! + (detailModel.map?.info?.activityRate)!
            let amount = Double((detailModel.map?.inputAmount)!)
        
            //算出收益
            profitValue_1 =  amount * (rate / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
            
            if detailModel.map?.selectCouponModel != nil { //表示选择了红包
                
                let type: Int = (detailModel.map?.selectCouponModel!.type)!
                
                switch type {
                    
                case 1:  //返现券,不加上
//                     profitValue_2 = (detailModel.map?.selectCouponModel?.amount)!
                    break
                    
                case 2:  //加息券
                     profitValue_2 = amount * ((detailModel.map?.selectCouponModel!.raisedRates)! / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
                    break
                    
                case 3:   //体验金暂时没有
                    break
                    
                case 4:   //翻倍全
                     profitValue_2 = amount * (((detailModel.map?.selectCouponModel!.multiple)! - 1) * (detailModel.map?.info?.rate)! / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
                    break
                default:
                    break
                }
            }
        
        return profitValue_1 + profitValue_2 + (detailModel.map?.inputAmount)!
    }
    
}
