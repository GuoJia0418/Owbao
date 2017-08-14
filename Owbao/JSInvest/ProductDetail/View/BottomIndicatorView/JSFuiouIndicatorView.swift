//
//  JSFuiouIndicatorView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/6.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSFuiouIndicatorView: UIView {

    class func creatIndicatorView(superView: UIView) -> JSFuiouIndicatorView {
        let indicatorView = Bundle.main.loadNibNamed("JSFuiouIndicatorView", owner: nil, options: nil)!.first as!  JSFuiouIndicatorView
        indicatorView.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
        superView.addSubview(indicatorView)
        return indicatorView
    }
}
