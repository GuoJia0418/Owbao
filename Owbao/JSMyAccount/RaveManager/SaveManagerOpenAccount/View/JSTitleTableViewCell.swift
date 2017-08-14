//
//  JSTitleTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    
    @IBOutlet weak var middLabel: UILabel!
    var isOpen: Bool = false
    
    var tapCallback: ((_ isOpen: Bool) -> ())?
    
    @IBOutlet weak var leftConstrainsMargin: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.leftConstrainsMargin.constant = (170.0/414.0) * UIScreen.main.bounds.size.width
    }
    
    @IBAction func buttonClickAction(_ sender: Any) {
        
        if self.tapCallback != nil {
            self.tapCallback!(self.isOpen)
        }
    }
    
    func configureCell(isOpen: Bool) {
        self.isOpen = !isOpen //置为相反
        if isOpen == true {
            self.arrowImageView.image = UIImage(named: "icon_arrows_down")
        } else {
            
            self.arrowImageView.image = UIImage(named: "icon_arrows_right")
        }
    }
}
