//
//  JSInvitedLastTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class JSInvitedLastTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var rankTitleLabel: UILabel! //您的当前排名label
    @IBOutlet weak var rankBackgroundView: UIView! //排名的背景视图
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellHeight() -> CGFloat {
        return 345
    }
    
    //配置模型
    func configureCell(_ invitedModel: JSInvitedModel?) {
        
        if invitedModel != nil && invitedModel?.map != nil {
            
            if invitedModel?.map?.nowRanking > 10 {
                
                self.bottomLabel.text = "赶紧用洪荒之力召唤您的好友~"
                self.indicatorLabel.isHidden = false
                
                self.rankTitleLabel.isHidden = true
                self.rankBackgroundView.isHidden = true
                
                self.displayImageView.image = UIImage(named: "no_mingci")
                
            } else if invitedModel?.map?.nowRanking <= 10 && invitedModel?.map?.nowRanking != 0 {
                
                self.bottomLabel.text = "保持住，马上就可以领取大奖了!"
                self.rankLabel.text = "\((invitedModel?.map?.nowRanking)!)"
                self.rankTitleLabel.isHidden = false
                self.rankBackgroundView.isHidden = false
                self.indicatorLabel.isHidden = true
                
                self.displayImageView.image = UIImage(named: "has_mingci")
                
            } else { //等于
                
                self.bottomLabel.text = "赶紧用洪荒之力召唤您的好友~"
                self.indicatorLabel.isHidden = false
                
                self.rankTitleLabel.isHidden = true
                self.rankBackgroundView.isHidden = true
                
                self.displayImageView.image = UIImage(named: "no_mingci")
            }
        }
    }
}
