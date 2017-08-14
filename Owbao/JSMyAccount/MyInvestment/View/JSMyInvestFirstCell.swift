//
//  JSMyInvestFirstCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInvestFirstCell: UITableViewCell {
    @IBOutlet weak var beReceivedLabel: UILabel! //待收本金
    @IBOutlet weak var totalInterestLabel: UILabel! //待收总利息
    //赋值数据
    func configModel(_ model:MyInvestMapModel)
    {
        beReceivedLabel.text = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.principal),decimalPointType: 2, numVerification: false)
        
        totalInterestLabel.text = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.interest),decimalPointType: 2, numVerification: false)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellHeight()-> CGFloat
    {
        return 90
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
