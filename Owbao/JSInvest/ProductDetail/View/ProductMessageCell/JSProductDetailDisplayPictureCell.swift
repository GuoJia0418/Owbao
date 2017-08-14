//
//  JSProductDetailDisplayPictureCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/18.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProductDetailDisplayPictureCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    func configureCell(_ principleH5: String?) {
        
        if principleH5 != nil && principleH5 != "" {
            self.displayImageView.isHidden = false
            self.displayImageView.sd_setImage(with: URL(string: principleH5!), placeholderImage: Common.image(with: UIColorFromRGB(230, green: 230, blue: 230)), options: .refreshCached)
        } else {
            self.displayImageView.isHidden = true
        }
    }
    
    class func cellHeight(_ principleH5: String?) -> CGFloat {
        
        if principleH5 != nil && principleH5 != "" {
            return 38.0 + 540.0 * SCREEN_WIDTH / 694.0 + 10
        }
        return 38.0 + 10
    }
}
