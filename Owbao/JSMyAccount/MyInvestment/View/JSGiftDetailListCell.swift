//
//  JSGiftDetailListCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGiftDetailListCell: UITableViewCell {

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - 设置iphone7奖品详情
    func setupPrizeModel(_ model:JSPrizeDetailMapModel,row:Int)
    {
        if row == 1
        {
            titleLabel.text = "中奖者信息"
            msgLabel.text = model.prizeStatus == 0 ? "未开奖" : "已开奖"
            msgLabel.textAlignment = .right
            msgLabel.height = 20
            self.accessoryType = model.prizeStatus == 0 ? .none : .disclosureIndicator
        }
        else if row == 2
        {
            titleLabel.text = "我的幸运码"
            msgLabel.numberOfLines = 0
            
            if model.luckCodes != ""
            {
                msgLabel.height = JSGiftDetailListCell.setupNewSize(model.luckCodes!, font: 14, width: 185)
            }
            msgLabel.text = model.luckCodes
        }
    }
    
    //MARK: - 财胜标的cell高度
    class func cellHeight(_ model:JSPrizeDetailMapModel,row:Int)->CGFloat
    {
        if row == 1
        {
           return 55 * SCREEN_SCALE_W
        }
        else if row == 2
        {
            if model.luckCodes != ""
            {
                let newHeight = JSGiftDetailListCell.setupNewSize(model.luckCodes!, font: CGFloat(14), width: 185)
                return 55 * SCREEN_SCALE_W + newHeight
            }
            else
            {
                return 55 * SCREEN_SCALE_W
            }
        }
        
        return 55 * SCREEN_SCALE_W
    }
    
    //MARK: - 返回新的size
    class func setupNewSize(_ textStr:String,font:CGFloat,width:CGFloat)->CGFloat
    {
        let newSize = textStr.getTextRectSize(UIFont.systemFont(ofSize: font), size: CGSize(width: width, height: 5000))
        return newSize.height
    }
    
    
    /***********************  下面是投即送    ****************************************/
    //MARK: - 投即送的cell高度
    class func giftCellHeight(_ model:JSGiftDetailMapModel,row:Int)->CGFloat
    {
        if row == 3 && model.prizeType == 0
        {
            let newHeight = JSGiftDetailListCell.setupNewSize(model.collectaddress!, font: CGFloat(14), width: 190)
            return 55 * SCREEN_SCALE_W + newHeight
        }
        else
        {
            return 55 * SCREEN_SCALE_W
        }
    }
    
    //MARK: - 设置投即送详情
    func setupGiftModel(_ model:JSGiftDetailMapModel,row:Int)
    {
        if model.prizeType == 1
        {
            titleLabel.text = "充值手机号"
            msgLabel.text = model.collectPhone
        }
        else
        {
            switch row {
            case 1:
                titleLabel.text = "收货人"
                msgLabel.text = model.collectName
                break
            case 2:
                titleLabel.text = "联系电话"
                msgLabel.text = model.collectPhone
                break
            case 3:
                titleLabel.text = "收货地址"
                msgLabel.numberOfLines = 0
                
                if model.collectaddress != ""
                {
                    msgLabel.height = JSGiftDetailListCell.setupNewSize(model.collectaddress!, font: 14, width: 190)
                }
                msgLabel.text = model.collectaddress
                break
            default:
                break
            }
        }
    }

    
    //MARK: - 公用的cellHeight
    class func normalCellHeight()->CGFloat
    {
        return 55 * SCREEN_SCALE_W
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
