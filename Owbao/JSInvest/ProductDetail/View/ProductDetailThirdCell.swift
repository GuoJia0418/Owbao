//
//  ProductDetailThirdCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ProductDetailThirdCell: UITableViewCell {

    @IBOutlet weak var couponCountLabel: UILabel!   //优惠券可用个数
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIImageView!
    
    //只有普通标且可以投才会返回高度，反之0
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        if detailModel != nil  {
            if detailModel?.map?.info?.status == 5 && detailModel?.map?.controllerType  == .normal {
                return 50 
            }
        }
        return 0
    }
    
    //只有普通标且可以投才会返回1，反之0
    class func numberRowForCell(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            
            if detailModel?.map?.controllerType  == .normal && detailModel?.map?.info?.status == 5 {
                return 1
            }
        }
        return 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //selectCouponModel：选中的红包,  maxCoupon：可用红包个数
    func configureCell(_ detailModel: ProductDetailsModel?,maxCoupon: Int) -> () {
        
        if maxCoupon == 0 { //如果是0 显示灰色
            self.couponCountLabel.text = "无可用优惠券"
        } else {
            self.couponCountLabel.text = "请选择优惠券"
        }
        
        if detailModel != nil   {
            
            if detailModel?.map?.info?.status != 5 { //表示标不可投资,全部控件隐藏
                self.leftTitleLabel.isHidden = true
                self.couponCountLabel.isHidden = true
                self.leftImageView.isHidden = true
                self.indicatorView.isHidden = true
            } else {
                self.leftTitleLabel.isHidden = false
                self.couponCountLabel.isHidden = false
                self.leftImageView.isHidden = false
                self.indicatorView.isHidden = false
            }
            
            if detailModel?.map?.selectCouponModel != nil { //判断红包逻辑
                
                //如果选中的红包存在,couponCountLabel不显示文字
                self.couponCountLabel.text = ""
                let type = (detailModel?.map?.selectCouponModel!.type)!
                
                switch type {
                case 1:  //返现券
                    self.leftTitleLabel.text = "使用\(self.valueTransformatStandardString((detailModel?.map?.selectCouponModel?.amount)!))元返现红包"
                    break
                case 2:  //加息券
                    self.leftTitleLabel.text = "使用\((detailModel?.map?.selectCouponModel?.raisedRates)!)%加息券"
                    break
                case 3:   //体验金暂时没有
                    break
                case 4:  //翻倍全
                    self.leftTitleLabel.text = "使用\((detailModel?.map?.selectCouponModel?.multiple)!)倍翻倍券"
                    break
                default:
                    break
                }
                
            }
        }
    }
    
    //转换成标准的字符串
    fileprivate func valueTransformatStandardString(_ value: Double) -> String {
        return PD_NumDisplayStandard.standardString("\(value)", decimalPointType: 0, numVerification: false)
    }
}
