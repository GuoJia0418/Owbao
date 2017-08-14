//
//  JSProductAcountCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/6.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProductAcountCell: UITableViewCell {
    
    @IBOutlet weak var totalAmountLabel: UILabel!       //项目总额
    @IBOutlet weak var remainAmountLabel: UILabel!      //剩余可投金额
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //配置cell
    func configModel(_ model: ProductDetailsModel?) {
        
        if model != nil {
            totalAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard("\((model?.map?.info?.amount)!)", decimalPointType: 1, numVerification: false)
            
            remainAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard("\((model?.map?.info?.surplusAmount)!)", decimalPointType: 1, numVerification: false)
        }
    }
    
    //新手标没有该cell，需要返回0
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        if detailModel != nil {
            return 68.0
        }
        return 0
    }
    
    //设计图新手标没有项目总额、剩余可投金额返回0，其余标返回1（新版的新手标也有）
    class func numberRowForCell(_ type: InvestDetailControllerType) -> Int {
         return 1
    }
}
