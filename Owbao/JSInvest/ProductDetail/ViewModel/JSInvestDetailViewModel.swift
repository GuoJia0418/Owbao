//
//  JSInvestDetailViewModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/6/28.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestDetailViewModel: JSBaseViewModel {

    var detailModel: ProductDetailsModel? //保存的数据模型
    
//    //转换成标准的字符串
//    func valueTransformatStandardString(_ value: Double) -> String {
//        return PD_NumDisplayStandard.standardString("\(value)", decimalPointType: 1, numVerification: false)
//    }
//    
//    //计算收益，selectCouponModel为选中的红包，detailModel从控制器传过来的模型（并记忆用户输入金额、选中的红包）
//     func calculatedProfit(_ detailModel: ProductDetailsModel,
//                                      selectCouponModel: MyCouponsListModel?) -> NSMutableAttributedString {
//        
//        if detailModel.map?.inputAmount > 0 { //这里表示输入金额>0才能进行显示
//            
//            //detailModel是必选的,selectCouponModel是可选的
//            var profitValue_1 = 0.00
//            let rate = ((detailModel.map?.info?.rate)! + (detailModel.map?.info?.activityRate)!)
//            let amount = (amountTextField.text! as NSString).doubleValue
//            
//            //算出收益
//            profitValue_1 =  amount * (rate / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
//            
//            if selectCouponModel != nil { //表示选择了红包
//                
//                switch selectCouponModel!.type {
//                case 1:  //返现券
//                    
//                    let profitValue_2 = (selectCouponModel?.amount)!
//                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(返现红包)")
//                    
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(227, green: 58, blue: 63), range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
//                    
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(返现红包)"))
//                    
////                    self.profitLabel.attributedText = attriString
//                    
//                    return attriString
//                    break
//                    
//                case 2:  //加息券
//                    
//                    let profitValue_2 = (amountTextField.text! as NSString).doubleValue * (selectCouponModel!.raisedRates / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
//                    
//                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(加息收益)")
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(227, green: 58, blue: 63), range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(加息收益)"))
//                    
////                    self.profitLabel.attributedText = attriString
//                    
//                    return attriString
//                    
//                    break
//                case 3:   //体验金暂时没有
//                    break
//                case 4:  //翻倍券(只翻倍基础利率)
//                    
//                    let profitValue_2 = (amountTextField.text! as NSString).doubleValue * ((selectCouponModel!.multiple - 1) * (detailModel.map?.info?.rate)! / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
//                    
//                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(翻倍收益)")
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(227, green: 58, blue: 63), range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
//                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(翻倍收益)"))
////                    self.profitLabel.attributedText = attriString
//                    
//                    return attriString
//                    
//                    break
//                default:
//                    break
//                }
//                
//            } else { //没有选择红包
//                
//                self.profitLabel.text = "\(self.valueTransformatStandardString(profitValue_1))"
//            }
//            
//        } else { //如果没进行输入收益置为0
//            
//            self.profitLabel.text = "0.0"
//            
//            var profitString = NSMutableAttributedString
//        }
//    }
    
}
