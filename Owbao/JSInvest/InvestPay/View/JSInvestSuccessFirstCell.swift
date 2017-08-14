//
//  JSInvestSuccessFirstCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestSuccessFirstCell: UITableViewCell {

    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var investAmountLabel: UILabel!  //投资成功金额
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ inputAmount: Double) -> () {
        
        let string = "恭喜您成功投资\(inputAmount)元"
        
        let attriString = NSMutableAttributedString(string: string)
        
        attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(227, green: 58, blue: 63), range: NSString(string: string).range(of: "\(inputAmount)"))
        self.investAmountLabel.attributedText = attriString
    }
    
    class func cellHeight() -> CGFloat {
        return 120 * SCREEN_SCALE_W
    }
}
