//
//  JSOpenAccountFooterView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOpenAccountFooterView: UIView {
    
    @IBOutlet weak var bottomLabel: UILabel!
    var bottomTapCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(botomTapAction)))
    }
    
    func botomTapAction() {
    
        if self.bottomTapCallback != nil {
            self.bottomTapCallback!()
        }
    }
}
