//
//  JSOperationalDataCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/6/17.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOperationalDataCell: UITableViewCell {
    @IBOutlet weak var cumulativeTradeAmountLabel: UILabel!     //累计交易额
    @IBOutlet weak var profitsLabel: UILabel!     //赚取的收入
    @IBOutlet weak var cumulativeRegisterPersonLabel: UILabel!     //累计注册的人数
    
    class func cellHeight() -> CGFloat {
        return 110 * SCREEN_SCALE_W
    }
    
    //数据model 
    func setupModel(model:JSHomeOperateDataModel)
    {
//        累计交易额
        let investCumulativeValueStr = PD_NumDisplayStandard.setNum(model.investCumulative / 100000000)
        let investCumulativeValue = (investCumulativeValueStr! as NSString).substring(with: NSMakeRange(1, (investCumulativeValueStr?.characters.count)! - 1))
        cumulativeTradeAmountLabel.text = investCumulativeValue + "亿"
        self.setAttributedString(cumulativeTradeAmountLabel.text!, subString: "亿", attributeName: NSForegroundColorAttributeName, isSetFont: false, font: 12, location: (cumulativeTradeAmountLabel.text?.characters.count)! - "亿".characters.count, length: "亿".characters.count, label: cumulativeTradeAmountLabel)
        self.setAttributedString(cumulativeTradeAmountLabel.text!, subString: "亿", attributeName: NSFontAttributeName, isSetFont: true, font: 12, location: (cumulativeTradeAmountLabel.text?.characters.count)! - "亿".characters.count, length: "亿".characters.count, label: cumulativeTradeAmountLabel)
        
        //利润
        let profitCumulativeValueStr = PD_NumDisplayStandard.configNumStandard(model.profitCumulative / 10000)
        let profitCumulativeValue = PD_NumDisplayStandard.numDisplayStandard(profitCumulativeValueStr, decimalPointType: 0, numVerification: false)
        profitsLabel.text = profitCumulativeValue! + "万"
        self.setAttributedString(profitsLabel.text!, subString: "万", attributeName: NSForegroundColorAttributeName, isSetFont: false, font: 12, location: (profitsLabel.text?.characters.count)! - "万".characters.count, length: "亿".characters.count, label: profitsLabel)
        self.setAttributedString(profitsLabel.text!, subString: "万", attributeName: NSFontAttributeName, isSetFont: true, font: 12, location: (profitsLabel.text?.characters.count)! - "万".characters.count, length: "万".characters.count, label: profitsLabel)
        
        //人数
        let regCountValueStr = PD_NumDisplayStandard.configNumStandard(model.regCount / 10000)
        let regCountValue = PD_NumDisplayStandard.numDisplayStandard(regCountValueStr, decimalPointType: 0, numVerification: false)
        cumulativeRegisterPersonLabel.text = regCountValue! + "万"
        self.setAttributedString(cumulativeRegisterPersonLabel.text!, subString: "万", attributeName: NSForegroundColorAttributeName, isSetFont: false, font: 12, location: (cumulativeRegisterPersonLabel.text?.characters.count)! - "万".characters.count, length: "万".characters.count, label: cumulativeRegisterPersonLabel)
        self.setAttributedString(cumulativeRegisterPersonLabel.text!, subString: "万", attributeName: NSFontAttributeName, isSetFont: true, font: 12, location: (cumulativeRegisterPersonLabel.text?.characters.count)! - "万".characters.count, length: "万".characters.count, label: cumulativeRegisterPersonLabel)
        
    }

    //设置Attribute
    fileprivate func setAttributedString(_ superString: String,
                                         subString: String,
                                         attributeName: String,
                                         isSetFont: Bool,
                                         font: CGFloat,
                                         location: Int,
                                         length: Int,
                                         label: UILabel) {
        
        let attributedString = NSMutableAttributedString(string: superString)
        
        if isSetFont {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        } else{
        
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(151, green: 151, blue: 151), range: NSMakeRange(location, length))
        }
        
        label.attributedText = attributedString
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
