//
//  JSServiceCentreDisplayTitleTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSServiceCentreDisplayTitleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var displayTitle: UILabel!
    
    class func getHeigth(_ content: String?) -> CGFloat {
        if content == "" || content == nil {
            return 0.0
        } else {
            let height = content!.getTextRectSize(UIFont.systemFont(ofSize: 15.0),size:CGSize(width: SCREEN_WIDTH - 30.0, height: 3000.0)).size.height
            return height + 30
        }
    }
}
