//
//  JSInvestGiveTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestGiveTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var topLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ row: Int) -> () {
        
        //1.设置cell显示的信息
        if row == 0 { //活动详情
            
            self.leftLabel.text = "活动详情"
            self.leftImageView.image = UIImage(named: "活动详情.png")
            self.topLineView.isHidden = true
        } else if row == 1 { //礼品详情
            self.leftLabel.text = "礼品详情"
            self.leftImageView.image = UIImage(named: "礼品.png")
            self.topLineView.isHidden = false
        }
    }
    
    //只有投即送类型才会有高度，别的类型无高度
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        if detailModel != nil {
            
            if detailModel?.map?.controllerType == .investGive {
                return 50.0
            }
        }
        return 0
    }
    
    //投即送标存在，需要显示cell，否则不显示
    class func numberRowForInvestGiveSection(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            if detailModel?.map?.controllerType == .investGive { //是iPhone7标
                return 2
            }
        }
        
        return 0
    }
}
