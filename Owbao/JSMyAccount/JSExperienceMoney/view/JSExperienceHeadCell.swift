//
//  JSExperienceHeadCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSExperienceHeadCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    var checkButtonCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //配置模型
    func configureCell(_ mapModel: MyCouponsMapModel) -> () {
        self.amountLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(mapModel.amountSum)", decimalPointType: 1, numVerification: false)
    }
    
    class func cellHeight() -> CGFloat  {
        return 180
    }
    
    @IBAction func checkButtonClickAction(_ sender: AnyObject) {
        if self.checkButtonCallback != nil {
            self.checkButtonCallback!()
        }
    }
}
