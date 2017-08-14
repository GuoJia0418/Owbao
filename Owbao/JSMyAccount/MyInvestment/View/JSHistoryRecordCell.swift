//
//  JSHistoryRecordCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSHistoryRecordCell: UITableViewCell {

    @IBOutlet weak var historyIncomeLabel: UILabel!     //历史累计投资收益
    
    //赋值数据
    func configModel(_ model:MyInvestMapModel)
    {
        historyIncomeLabel.text = PD_NumDisplayStandard.numDisplayStandard(String(format: "%.2f", model.accumulatedIncome),decimalPointType: 1, numVerification: false)
    }

    class func cellHeight()-> CGFloat
    {
        return 85 * SCREEN_SCALE_W
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
