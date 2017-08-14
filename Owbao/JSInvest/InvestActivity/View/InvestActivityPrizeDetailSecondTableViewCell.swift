//
//  InvestActivityPrizeDetailSecondTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityPrizeDetailSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var titleDetailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var giftPriceLabel: UILabel!
    @IBOutlet weak var titleLabel_width_constrains: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //设置cell 根据模型
    func configureCellWithPrizeModel(_ prizeModel: ProductDetailsMapPrizeModel) -> () {
        self.titleLabel.text = prizeModel.name //全称
        self.titleDetailLabel.text = prizeModel.simpleName //简称
        
        let string = "￥\(prizeModel.price)"
        let string_oc = NSString(string: string)
        
        let attributedString = NSMutableAttributedString(string: string_oc as String)
        attributedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: 0 as Int), range: NSMakeRange(0, "￥".characters.count))
        attributedString.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(value: 1 as Int), range: string_oc.range(of: string_oc as String))
        
        self.giftPriceLabel.attributedText = attributedString //设置价格
        
        self.titleLabel_width_constrains.constant = prizeModel.name.getTextRectSize(UIFont.systemFont(ofSize: 17), size: CGSize(width: 3000, height: 21)).width
    }
}
