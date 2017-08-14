//
//  InvestActivityDetailTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!//礼品主标题
    @IBOutlet weak var titleDetailLabel: UILabel!//礼品副标题
    @IBOutlet weak var giftPriceLabel: UILabel!//礼品价格
    @IBOutlet weak var backgroudImageView: UIImageView!
    
    @IBOutlet weak var zeroShareView: UIView!
    @IBOutlet weak var checkGiftDetailLabel: UILabel!//查看礼品详情label
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkGiftDetailLabel.layer.cornerRadius = 4
        self.checkGiftDetailLabel.layer.masksToBounds = true
        self.checkGiftDetailLabel.layer.borderWidth = 1.0
        self.checkGiftDetailLabel.layer.borderColor = UIColor.red.cgColor
        
        self.zeroShareView.layer.cornerRadius = 25
        self.zeroShareView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //1104 : 574  设计图比例
    class func getCellHeight() -> CGFloat {
        return 187.0 * SCREEN_WIDTH / 320
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
        
        //下载图片
        self.backgroudImageView.sd_setImage(with: URL.init(string: prizeModel.h5ImgUrlH), placeholderImage: Common.image(with: UIColorFromRGB(235.0, green: 235.0, blue: 235.0)), options: SDWebImageOptions.refreshCached)
    }
}
