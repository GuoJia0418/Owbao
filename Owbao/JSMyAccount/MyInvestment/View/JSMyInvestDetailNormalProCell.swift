//
//  JSMyInvestDetailNormalProCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInvestDetailNormalProCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!       //标名称
    @IBOutlet weak var productStatusLabel: UILabel!     //标状态
    @IBOutlet weak var bgView: UIView!                  //标志背景
    @IBOutlet weak var productIconImgView: UIImageView! //标的图标 iPhone7:js_invest_detail_prize   投即送：js_invest_detail_present
    @IBOutlet weak var productIconLabel: UILabel!       //iPhone7:抽奖   投即送：豪礼   普通标：无
    @IBOutlet weak var noviceRemarkLabel: UILabel!  //新手标续投标签
    
    func setupModel(_ model:MyInvestRowsModel)
    {
        productNameLabel.text = model.fullName
        
        if model.type == 1 //新手标
        {
            noviceRemarkLabel.isHidden = false
            if model.periodLabel != ""
            {
                noviceRemarkLabel.text = model.periodLabel
                noviceRemarkLabel.width = newSize(noviceRemarkLabel) + CGFloat(15.0)
                
                noviceRemarkLabel.layer.borderColor = Global_red.cgColor
                noviceRemarkLabel.layer.borderWidth = 1.0
                noviceRemarkLabel.layer.cornerRadius = 2.0
                noviceRemarkLabel.layer.masksToBounds = true
            }
            else
            {
                noviceRemarkLabel.text = ""
            }
        }
        else
        {
            noviceRemarkLabel.isHidden = true
        }
        
        
        if model.productType == 1  //投即送
        {
            setupPrize(1)
        }
        else if model.productType == 2 //送iphone7
        {
            setupPrize(2)
        }
        else
        {
            bgView.isHidden = true
        }
        
        productStatusLabel.text = setupProStatus(model.productStatus)
    }
    
    //设置奖品
    func setupPrize(_ productType:Int)
    {
        bgView.layer.cornerRadius = 2.0
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = Global_red.cgColor
        bgView.isHidden = false
        
        productIconImgView.image = productType == 1 ? UIImage(named: "js_invest_detail_present") : UIImage(named: "js_invest_detail_prize")
        
        productIconLabel.text = productType == 1 ? "豪礼" : "抽奖"
    }
    
    //设置状态
    func setupProStatus(_ status:Int)-> String
    {
        productStatusLabel.layer.cornerRadius = 12.0
        productStatusLabel.layer.masksToBounds = true
        productStatusLabel.layer.borderColor = Global_red.cgColor
        productStatusLabel.layer.borderWidth = 1.0
        
        let dict = ["0":"投资中","1":"待还款","2":"投资失败","3":"已还款"]
        return dict["\(status)"]!
    }

    class func cellHeight()->CGFloat
    {
        return 49 * SCREEN_SCALE_W
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - label 自适应宽度
    func newSize(_ label:UILabel) -> CGFloat
    {
        let textSize = NSString(string: label.text!).size(attributes: [NSFontAttributeName : label.font!])
        return textSize.width
    }
    
}
