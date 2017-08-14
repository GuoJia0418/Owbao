//
//  JSImageTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSImageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight(index: Int) -> CGFloat {
        if index == 0 {
            return 25 + 20 + 20 + 20 + (SCREEN_WIDTH - 40.0) / 642.0 * 964.0 //图片比例为: 642.0:964.0
        } else {
            return 25 + 20 + 20 + 20 + (SCREEN_WIDTH - 40.0) / 642.0 * 433.0 //图片比例为: 642.0:433.0
        }
    }
}
