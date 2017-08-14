//
//  JSOfflineActivityCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOfflineActivityCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - 开放日数据
    func configData(model:JSOfflineActivityMapModel)
    {
        titleLabel.text = model.openDayLabel
        if model.openDayPicUrl != ""
        {
            bannerImageView.sd_setImage(with: URL(string: model.openDayPicUrl), placeholderImage: Common.image(with: UIColorFromRGB(255, green: 255, blue: 255)), options: SDWebImageOptions.refreshCached)
        }

    }
    
    //MARK: - 刷新数据
    func refreshView(model:JSOfflineActivityRowsModel)
    {
        titleLabel.text = model.titleList
        if model.h5ListBanner != ""
        {
            bannerImageView.sd_setImage(with: URL(string: model.h5ListBanner), placeholderImage: Common.image(with: UIColorFromRGB(255, green: 255, blue: 255)), options: SDWebImageOptions.refreshCached)
        }
    }
    
    //MARK: - cell的高度
    class func cellHeight() -> CGFloat {
        return 185
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
