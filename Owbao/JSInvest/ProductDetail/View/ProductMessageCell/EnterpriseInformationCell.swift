//
//  EnterpriseInformationCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class EnterpriseInformationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!     //标题
    @IBOutlet weak var bgView: UIView!          //放label的view
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var contentBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //赋值model
    func setupModel(_ content: String?) {
        
        if content != nil && content != "" {
            self.contentLabel!.text = content
            self.contentBackgroundView.isHidden = false
        } else {
            self.contentBackgroundView.isHidden = true
        }
    }
    
    class func cellHeight(_ content: String?) -> CGFloat {
        if content != nil && content != "" {
            return 38.0 + EnterpriseInformationCell.getHeight(content!) + 30
        } else {
            return 37.0 + 5.0
        }
    }
    
   fileprivate class func getHeight(_ content: String) -> CGFloat {
        if content == "" {
            return 0.0
        } else {
            let height = content.getTextRectSize(UIFont.systemFont(ofSize: 15.0),size:CGSize(width: SCREEN_WIDTH - 40.0, height: 3000.0)).size.height
            return height
        }
    }
}
