//
//  MyInformationCell.swift
//  Owbao
//
//  Created by user on 16/6/30.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MyInformationCell: UITableViewCell {

//    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var displayimageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        bankButton.isUserInteractionEnabled = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
