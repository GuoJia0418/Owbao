//
//  JSMediaTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ detailModel: PublickDetailModel?) {
        
        if detailModel != nil {
           self.titleLabel.text = detailModel!.title
           self.displayImageView.sd_setImage(with: URL(string: (detailModel?.litpic)!), placeholderImage: UIImage(named: "logo_default_icon"), options: .refreshCached)
           self.timeLabel.text = TimeStampToString((detailModel?.createTime)!, isHMS: true)
        }
    }
    
    class func cellHeight() -> CGFloat {
        return 92
    }
}
