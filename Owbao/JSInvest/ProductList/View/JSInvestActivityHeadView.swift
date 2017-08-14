//
//  JSInvestActivityHeadView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/11.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestActivityHeadView: UIView {

    //点击回调
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        
        if self.tapCallback != nil {
            self.tapCallback!(self.index)
        }
    }
    
    //js_you_icon  优图标
    //js_cai_icon  财
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    fileprivate var index: Int = 0
    var tapCallback: ((_ index: Int) -> ())?
    
    class func viewHeight() -> CGFloat {
        return 71.0
    }
    
    //index为0 表示第一个section 1表示第二个section 见设计图
    func configureHeaderView(_ index: Int) {
        
        if index == 0 {
            self.displayImageView.image = UIImage(named: "js_you_icon")
            self.titleLabel.text = "优选理财"
            
        } else if index == 1 {
            self.titleLabel.text = "活动专享"
            self.displayImageView.image = UIImage(named: "js_cai_icon")
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
