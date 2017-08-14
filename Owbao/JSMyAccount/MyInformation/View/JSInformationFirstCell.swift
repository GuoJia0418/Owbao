//
//  JSInformationFirstCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/31.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInformationFirstCell: UITableViewCell {

    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var indicateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(informationModel: MyInformationModel?) -> () {
        
        if informationModel != nil {
            
            var flag = false
            if informationModel?.map?.isFuiou == 1 {
                flag = true
            }
            self.setCellDisplay(flag: flag)
        }
    }
    
    //flage: true表示存管账户已经开通了，false表示未开通
    private func setCellDisplay(flag: Bool) -> () {
        
        if flag {
            detailTitleLabel.text = "已开通"
        } else {
            detailTitleLabel.text = "立即开通"
            detailTitleLabel.textColor = DEFAULT_REDCOLOR
        }
    }
}
