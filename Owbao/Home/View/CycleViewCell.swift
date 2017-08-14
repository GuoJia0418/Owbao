//
//  CycleViewCell.swift
//  hyq2.0
//
//  Created by iOS on 15/6/5.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class CycleViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLB: UILabel!
    
    var article: UrgentNoticeModel? {
        didSet {
            
            titleLB.text = article?.title
            titleLB.font = UIFont.systemFont(ofSize: 13)
        }
    }
    class func nib() -> UINib {
        return UINib(nibName: "CycleViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

