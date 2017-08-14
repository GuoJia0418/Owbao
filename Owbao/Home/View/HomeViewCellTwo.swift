//
//  HomeViewCellTwo.swift
//  Owbao
//
//  Created by xiefei on 16/2/29.
//  Copyright © 2016年 xiefei. All rights reserved.
//

import UIKit

class HomeViewCellTwo: UITableViewCell {

    
    @IBOutlet weak var peopleNum: UILabel!
    
    @IBOutlet weak var tolAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "HomeViewCellTwo", bundle: nil)
    }
    
}
