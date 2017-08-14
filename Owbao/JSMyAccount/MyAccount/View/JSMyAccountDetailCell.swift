//
//  JSMyAccountDetailCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/22.
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


class JSMyAccountDetailCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!    //图标
    @IBOutlet weak var titleLabel: UILabel!     //标题
    @IBOutlet weak var detailLabel: UILabel!    //细节label
    @IBOutlet weak var inviteImgView: UIImageView!      //邀请获得的福利
    
    func setupModel(_ model: MyAccountModel,row: Int) {
        switch row {
        case 2:
            detailLabel.text = ""
            break
        case 3://优惠券
            detailLabel.text = "\(model.map!.unUseFavourable)个未用"
            break
        case 4://体验金
            
            if model.map?.availableExperience > 0 { //体验金大于0才显示
                detailLabel.text = PD_NumDisplayStandard.numDisplayStandard("\((model.map?.availableExperience)!)", decimalPointType: 1, numVerification: false) + "元"
            }

            break
        case 5:
            if model.map?.unclaimed != 0
            {
                inviteImgView.image = UIImage(named: "js_mine_invite_profit")
            }
            else
            {
                inviteImgView.image = UIImage(named: "")
            }
            detailLabel.text = ""
            break
        case 6: //安全中心
//            if model.map!.realVerify == 1
//            {
//               detailLabel.text = ""
//            }
//            else
//            {
////               detailLabel.text = model.map?.unTiedCardTitle
//                detailLabel.text = ""
//            }
            if model.map?.isFuiou == 0 { //未开通
                detailLabel.text = "开通存管账户"
                detailLabel.textColor = DEFAULT_REDCOLOR
            } else {
                detailLabel.text = ""
            }
            
            break
        default:
            break
        }
    }
    
    func setupView(_ image:String,title:String)
    {
        iconImgView.image = UIImage(named:image)
        titleLabel.text = title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
