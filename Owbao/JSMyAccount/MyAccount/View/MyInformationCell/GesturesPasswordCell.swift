//
//  GesturesPasswordCell.swift
//  Owbao
//
//  Created by user on 16/7/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class GesturesPasswordCell: UITableViewCell {
    
    var gestureOpen:((_ isOn:Bool) -> ())?

    @IBOutlet weak var OpenGesturesSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserModel.shareInstance.isSetGestureUnlock != 0 {
            self.OpenGesturesSwitch.isOn = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func isOpen(_ sender: AnyObject) {
        //gestureOpen()
        self.gestureOpen!(sender.isOn)
    }
}
