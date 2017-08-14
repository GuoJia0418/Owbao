//
//  JSInvitedFirstTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvitedFirstTableViewCell: UITableViewCell {
    
    var invitedModel: JSInvitedModel? //保存
    @IBOutlet weak var displayImageView: UIImageView!
    var tapActionCallback: ((_ URLString: String) -> ())? //点击回调

    @IBOutlet weak var rewardsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    func tapAction() {
        if self.tapActionCallback != nil {
            
            if invitedModel != nil && invitedModel?.map != nil {
                self.tapActionCallback!((invitedModel?.map?.activity?.appPutUrl)!)
            }
        }
    }
    
    class func cellHeight() -> CGFloat {
        return 133.0
    }
    
    func configureCell(_ invitedModel: JSInvitedModel?) {
        
        if invitedModel != nil && invitedModel?.map != nil {
            
            self.invitedModel = invitedModel
            self.rewardsLabel.text = PD_NumDisplayStandard.numDisplayStandard("\((invitedModel?.map!.threePresentRewards)!)", decimalPointType: 1, numVerification: false) + "元"
            
            self.displayImageView.sd_setImage(with: URL(string: (invitedModel?.map?.activity?.appPutImg)!), placeholderImage: Common.image(with: UIColorFromRGB(230, green: 230, blue: 230)), options: .refreshCached)
        }
    }
}
