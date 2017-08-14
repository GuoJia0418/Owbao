//
//  JSActivityCentreTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum JSActivityCentreCellType: Int {
    case on  = 0    //正在进行中
    case end = 1    //已经结束
}

class JSActivityCentreTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.endBackgroundView.backgroundColor = UIColor(red: 1 / 255, green: 1/255, blue: 1/255, alpha: 0.5)
    }
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView! //将要显示的图片
    @IBOutlet weak var endBackgroundView: UIView!
    @IBOutlet weak var endBackgroundImageView: UIImageView!
    
    //配置模型
    func configureCell(_ activityModel: GetActivityFriendAllRowsModel) -> () {
        
        if activityModel.status == 2 { //已结束
            endBackgroundView.isHidden = false
            endBackgroundImageView.isHidden = false
        } else { //进行中
            endBackgroundView.isHidden = true
            endBackgroundImageView.isHidden = true
        }
        
        if activityModel.appPic != nil && activityModel.appPic != "" {
            displayImageView.sd_setImage(with: URL(string: activityModel.appPic!), placeholderImage: UIImage(named: "makeMoney_bg2"), options: SDWebImageOptions.refreshCached)
        }
        
        leftLabel.text = activityModel.title
        rightLabel.text = activityModel.activityDate    
    }
    
    //获取cell的高度
    class func cellHeight() -> CGFloat {
        return 15 + 35 + 160 * SCREEN_WIDTH / 320 // 160 * SCREEN_WIDTH / 320 按照首页的
    }
}
