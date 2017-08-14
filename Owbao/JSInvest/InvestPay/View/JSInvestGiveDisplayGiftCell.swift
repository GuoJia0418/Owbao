//
//  JSInvestGiveDisplayGiftCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/8.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  显示礼物tableViewCell,通用的

import UIKit

class JSInvestGiveDisplayGiftCell: UITableViewCell {

    @IBOutlet weak var displayImageView: UIImageView! //显示图片view
    @IBOutlet weak var mainTitleLabel: UILabel! //主标题label
    @IBOutlet weak var detailTitleLabel: UILabel! //副标题label
    @IBOutlet weak var priceLabel: UILabel! //价格label
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellHeight() -> CGFloat {
        return 101.0
    }
    
    //配置cell
    func configureCell(_ prizeModel: ProductDetailsMapPrizeModel?) -> () {
        
        if prizeModel != nil {
            //显示图片
            self.displayImageView.sd_setImage(with: URL(string: (prizeModel?.h5ImgUrlH)!), placeholderImage: Common.image(with: UIColorFromRGB(237, green: 237, blue: 237)), options: SDWebImageOptions.refreshCached)
            //显示标题
            self.mainTitleLabel.text = prizeModel!.name
            self.detailTitleLabel.text = prizeModel?.simpleName
            //显示原价
            let string = "￥\((prizeModel!.price))"
            let aString = NSMutableAttributedString(string: string)
            aString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: 0 as Int), range: NSMakeRange(0, "￥".characters.count))
            aString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1 as Int), range: NSMakeRange(0, string.length))
            
            self.priceLabel.attributedText = aString
        }
    }
}
