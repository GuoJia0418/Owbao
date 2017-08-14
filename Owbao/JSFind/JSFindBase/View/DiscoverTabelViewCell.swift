//
//  DiscoverTabelViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum DiscoverTapCallback: Int {
    case invite  = 0                      //邀请好友
    case activityCenter = 1               //已经领过了,也去分享
    case openDay = 2                      //线下活动
    case serviceCenter = 3                //客服中心
    case safeguard = 4                    //安全保障
    case aboutJS = 5                      //关于嗷呜
}

class DiscoverTabelViewCell: UITableViewCell {

    var tapCallback:((_ callbackType: DiscoverTapCallback) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonClickAction(_ sender: AnyObject) {

        let button = sender as! UIButton
        if button.tag == 0 { //邀请好友
            
            if self.tapCallback != nil {
                self.tapCallback!(.invite)
            }
            
        } else if button.tag == 1 { //活动中心
            
            if self.tapCallback != nil {
                self.tapCallback!(.activityCenter)
            }
            
        } else if button.tag == 2 {
            
            if self.tapCallback != nil {
                self.tapCallback!(.openDay)
            }

        } else if button.tag == 3 { //客服中心
            
            if self.tapCallback != nil {
                self.tapCallback!(.serviceCenter)
            }
            
        } else if button.tag == 4 { //安全保障
            
            if self.tapCallback != nil {
                self.tapCallback!(.safeguard)
            }
        } else if button.tag == 5 { //关于嗷呜
            
            if self.tapCallback != nil {
                self.tapCallback!(.aboutJS)
            }
        }
    }
    
    
    //根据cell的index获取cell的高度
     class func cellHeightWithIndex(_ cellIndex: Int) -> CGFloat {
        
        if cellIndex == 0 { //第0个section里面的cell
         return SCREEN_WIDTH * 2 / 3
        } else { //第1个section里面的cell
            return 60
        }
    }
    
    /******************** 第1个xib ******************/
    @IBOutlet weak var titleLabel_cellIndex_1: UILabel!
    @IBOutlet weak var detailTitleLabel_cellIndex_1: UILabel!
    
    
    
    /******************** 第2个xib ******************/
    @IBOutlet weak var titleLabel_cellIndex_2: UILabel!
    @IBOutlet weak var detailTitleLabel_cellIndex_2: UILabel!
    
}
