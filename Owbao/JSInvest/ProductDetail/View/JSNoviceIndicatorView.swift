//
//  JSNoviceIndicatorView.swift
//  JSApp
//
//  Created by 一言难尽 on 2017/6/28.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSNoviceIndicatorView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    class func creatIndicatorView(superView: UIView) -> JSNoviceIndicatorView {
        let indicatorView = Bundle.main.loadNibNamed("JSNoviceIndicatorView", owner: nil, options: nil)!.first as!  JSNoviceIndicatorView
        indicatorView.frame = CGRect(x: 0, y: (superView.frame.size.height - 16) / 2, width: superView.frame.size.width, height: 16)
        superView.addSubview(indicatorView)
        return indicatorView
    }
}
