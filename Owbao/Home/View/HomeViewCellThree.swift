//
//  HomeViewCellThree.swift
//  Owbao
//
//  Created by xiefei on 16/3/21.
//  Copyright © 2016年 xiefei. All rights reserved.
//

import UIKit

class HomeViewCellThree: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func nib() -> UINib {
        return UINib(nibName: "HomeViewCellThree", bundle: nil)
    }
}
