//
//  JSGiftDetailHeaderCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGiftDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var giftImgView: UIImageView!
    @IBOutlet weak var giftTitleLabel: UILabel!   //奖品名称
    @IBOutlet weak var giftMsgLabel: UILabel!    //奖品第一行介绍
    @IBOutlet weak var prizeMsgLabel: UILabel!  //奖品信息（颜色可选）
    @IBOutlet weak var giftPriceLabel: UILabel! //原价
    @IBOutlet weak var giftZeroLabel: UILabel!  //0元享
    
    //IPhone7
    func setupPrizeModel()
    {
        giftImgView.image = UIImage(named: "js_invest_present_detail")
        giftTitleLabel.text = "iPhone7"
        giftMsgLabel.text = "128G"
        prizeMsgLabel.text = "颜色可自选"
    }
    
    // 投即送
    func setupGiftModel(_ model:JSGiftDetailMapModel?)
    {
        //MARK: - 待切图
        //下载图片
        self.giftImgView.sd_setImage(with: URL.init(string: model!.h5ImgUrlH!), placeholderImage: Common.image(with: UIColorFromRGB(235.0, green: 235.0, blue: 235.0)), options: SDWebImageOptions.refreshCached)
        
        giftTitleLabel.text = model!.name
        giftMsgLabel.text = model!.simpleName
        
        let string = "¥\(model!.price)"
        let string_oc = NSString(string: "原价" + string)
        let attributedString = NSMutableAttributedString(string: string_oc as String)
        attributedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: 0 as Int), range: NSMakeRange(0, "原价".characters.count))
        attributedString.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(value: 1 as Int), range:NSMakeRange("原价".characters.count, string.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(50, green: 50, blue: 50), range: NSMakeRange(0, "原价".characters.count))
        giftPriceLabel.attributedText = attributedString
        
        setZeroLabel()
    }
    
    //设置0元享
    func setZeroLabel()
    {
        let attributedString = NSMutableAttributedString(string: "0元享")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: DEFAULT_REDCOLOR, range: NSMakeRange(0, "0".characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSMakeRange(0, "0".characters.count))
        giftZeroLabel.attributedText = attributedString
    }
    
    class func cellHeight()->CGFloat
    {
        return 120 * SCREEN_SCALE_W
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
