//
//  JSExprienceInvestHeadTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSExprienceInvestHeadTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let checkView = AnimationRightCorrect(frame:CGRect(x: (SCREEN_WIDTH - 36) / 2, y: 20 , width: 36, height: 36))
        checkView.beginAnimated()
        self.addSubview(checkView)
    }
    
    @IBOutlet weak var amountLabel: UILabel!
    
    func configureCell(_ experienceMapModel: ExperienceInvestMapModel) -> () {
        
        let amount = (experienceMapModel.experienceAmount?.experAmount)!
        let amountString = "\(amount)元"
        let attributeString = NSMutableAttributedString(string: amountString)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(233, green: 48, blue: 56), range: NSString(string: amountString).range(of: "\(amount)"))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: amountString).range(of: "元"))
        
        self.amountLabel.attributedText = attributeString
    }
    
    class func cellHeight() -> CGFloat {
        return 168.0
    }
}
