//
//  HomeActivityEntranceCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/1/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class HomeActivityEntranceCell: UITableViewCell {

    var videoFirstBlock:(()->())?
    var videoSecondBlock:(()->())?
    
    @IBOutlet weak var videoFirstBtn: UIButton!
    @IBOutlet weak var videoSecondBtn: UIButton!
    
    @IBAction func videoBtnClick(_ sender: UIButton) {
       self.videoFirstBlock!()
    }
    @IBAction func videoSecondClick(_ sender: UIButton) {
        self.videoSecondBlock!()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
