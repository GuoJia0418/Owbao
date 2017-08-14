//
//  JSMyInformationCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel! //标题
    @IBOutlet weak var msgLabel: UILabel!   //信息label
    @IBOutlet weak var arrowImgView: UIImageView!   //箭头
    @IBOutlet weak var bankImgView: UIImageView!    //bankicon
    @IBOutlet weak var line: UIView!

    //MARK: - 赋值数据
    func configModel(_ model:MyInformationModel,row:Int,section:Int)
    {
        if section == 0
        {
            switch row {
            case 0:
                titleLabel.text = "手机号"
                msgLabel.text = model.map?.mobilephone
                arrowImgView.isHidden = true
                bankImgView.isHidden = true
                line.isHidden = false
                break
            case 1:
                titleLabel.text = "姓名"
                bankImgView.isHidden = true
                line.isHidden = false
                if model.map?.realVerify == 1
                {
                    arrowImgView.isHidden = true
                    msgLabel.text = model.map?.realName
                }
                else
                {
                    arrowImgView.isHidden = false
                    msgLabel.text = "未认证"
                }

                break
            case 2:
                titleLabel.text = "身份证号"
                line.isHidden = false
                bankImgView.isHidden = true
                if model.map?.realVerify == 1
                {
                    arrowImgView.isHidden = true
                    msgLabel.text = model.map?.idCards
                }
                else
                {
                    arrowImgView.isHidden = false
                    msgLabel.text = "未认证"
                }
                break
            case 3:
                titleLabel.text = "银行卡"
                line.isHidden = true
                arrowImgView.isHidden = false
                if model.map?.realVerify == 1
                {
                    bankImgView.isHidden = false
                    bankImgView.image = UIImage(named: "\((model.map?.bankId)!)")
                    msgLabel.text = ""
                }
                else
                {
                    bankImgView.isHidden = true
                    msgLabel.text = "未认证"
                }
                break
            default:
                titleLabel.text = ""
                break
            }
        }
        else
        {
            bankImgView.isHidden = true
            arrowImgView.isHidden = false
            msgLabel.text = ""
            
            switch row {
            case 0:
                titleLabel.text = "重置登录密码"
                line.isHidden = false
                break
            case 1:
                titleLabel.text = "重置交易密码"
                line.isHidden = false
                break
            default:
                titleLabel.text = ""
                break
            }

        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellHeight()->CGFloat
    {
        return 52
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
