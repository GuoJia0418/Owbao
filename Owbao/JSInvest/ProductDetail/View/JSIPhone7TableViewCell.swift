//
//  JSIPhone7TableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/6.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSIPhone7TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //
    
    
    
    //*****************  第二个xib **************//
    @IBOutlet weak var detailTextLabel_xib_1: UILabel!
    @IBOutlet weak var detailTestLabel_xib_1_rightConstrains: NSLayoutConstraint!
    
    func configureCell_1(_ detailModel: ProductDetailsModel?) {
        
        if detailModel != nil { 
            if detailModel?.map?.info?.isPrize == 1 { // 开奖了
                self.accessoryType = .disclosureIndicator
                self.detailTestLabel_xib_1_rightConstrains.constant = 0
                self.detailTextLabel_xib_1.textColor = UIColor.darkGray
                self.detailTextLabel_xib_1.text = "已开奖"
            } else if detailModel?.map?.info?.isPrize == 2 { //未开奖
                self.accessoryType = .none
                self.detailTestLabel_xib_1_rightConstrains.constant = 15
                self.detailTextLabel_xib_1.textColor = UIColorFromRGB(219, green: 98, blue: 89)
                self.detailTextLabel_xib_1.text = "未开奖"
            }
        }
    }
    
    //判断cell是否可以点击，如果该标开奖了可以点击，反之不能点击
    class func cellIsCanClick(_ detailModel: ProductDetailsModel?) -> Bool {
        
        if detailModel != nil {
            
            if detailModel?.map?.info?.isPrize == 1 { //开奖了,可以点击
                return true
            }
        }
        return false
    }
    
    //iphone7标存在，需要显示cell，否则不显示
    class func numberRowForIPhone7Section(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            if detailModel?.map?.controllerType == .iphone7 { //是iPhone7标
                return 2
            }
        }
        
        return 0
    }
    
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        if detailModel != nil {
            
            if detailModel?.map?.controllerType == .iphone7 {
                return 50.0
            }
        }
        
        return 0
    }
}
