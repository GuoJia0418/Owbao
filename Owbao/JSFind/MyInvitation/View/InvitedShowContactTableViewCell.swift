//
//  InvitedShowContactTableViewCell.swift
//  Owbao
//
//  Created by GuoJia on 16/11/24.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedShowContactTableViewCell: UITableViewCell {

    @IBOutlet weak var showPhoneNumberLabel: UILabel!//显示联系人按钮
    @IBOutlet weak var showTimeLabel: UILabel!//显示时间按钮
    @IBOutlet weak var showContactLabel: UILabel!//显示联系人按钮
    @IBOutlet weak var showFlagLabel: UILabel!//显示是、否的label
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //设置视图,模型
    func configureCell(_ rowModel:InvitedRowsModel) -> () {
        self.showPhoneNumberLabel.text = rowModel.mobilePhone
        self.showTimeLabel.text = rowModel.regTime
        self.showContactLabel.text = rowModel.realName
        self.showFlagLabel.text = rowModel.isInvest
    }
}
