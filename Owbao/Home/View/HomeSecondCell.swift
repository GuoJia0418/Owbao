//
//  HomeSecondCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/8.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class HomeSecondCell: UITableViewCell {
    
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftContentLabel: UILabel!
    
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightContentLabel: UILabel!

    var homeSafetyClick:(()->())!
    var homeHotActivityClick:(()->())!
    
    func setupModel(_ model:HomeMapModel?)
    {
        leftImgView.sd_setImage(with: URL(string: model!.bannerDownPic1), placeholderImage: UIImage(named: "js_safety_icon"), options: SDWebImageOptions.refreshCached)
        leftTitleLabel.text = model?.bannerDownTitle1
        leftContentLabel.text = model?.bannerDownDescribe1

        rightImgView.sd_setImage(with: URL(string: model!.bannerDownPic2), placeholderImage: UIImage(named: "js_hot_icon"), options: SDWebImageOptions.refreshCached)
        rightTitleLabel.text = model?.bannerDownTitle2
        rightContentLabel.text = model?.bannerDownDescribe2
    }
    
    //安全保障
    @IBAction func safetyClick(_ sender: UIButton) {
        self.homeSafetyClick()
    }
    //热门活动
    @IBAction func hotActivityClick(_ sender: UIButton) {
        self.homeHotActivityClick()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
