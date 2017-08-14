//
//  JSInvitedSubDisplayInfoCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvitedSubDisplayInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var nameLabel: UILabel! //名字label
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    func configureCell(_ listModel: JSInvestListModel?) {
        
        if listModel != nil {
            
            self.nameLabel.text = listModel!.realname
            self.secondLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(listModel!.investAmount)", decimalPointType: 1, numVerification: false)
            self.thirdLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(listModel!.rebateAmount)", decimalPointType: 1, numVerification: false)
        }
    }
    
    //**************** 第二个xib **************//
    
    @IBOutlet weak var nameLabel_xib1: UILabel!
    @IBOutlet weak var secondLabel_xib1: UILabel!
    @IBOutlet weak var thirdLabel_xib1: UILabel!
    @IBOutlet weak var forthLabel_xib1: UILabel!
    
    func configureCell_xib1(_ listModel: JSRepeatInvestListModel?) {
        
        if listModel != nil {
            
            self.nameLabel_xib1.text = listModel!.realname
            self.thirdLabel_xib1.text = PD_NumDisplayStandard.numDisplayStandard("\(listModel!.investAmount)", decimalPointType: 1, numVerification: false)
            self.forthLabel_xib1.text = PD_NumDisplayStandard.numDisplayStandard("\(listModel!.rebateAmount)", decimalPointType: 1, numVerification: false)
            self.secondLabel_xib1.text = "\((listModel!.investOrder))"//投资次数
        }
    }
}
