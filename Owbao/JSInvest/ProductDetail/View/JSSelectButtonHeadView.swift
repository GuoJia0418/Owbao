//
//  JSSelectButtonHeadView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSelectButtonHeadView: UIView {

    @IBOutlet weak var leftIndicatorView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var centreButton: UIButton!
    @IBOutlet weak var centreIndicatorView: UIView!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightIndicatorView: UIView!
    
    
    var tapCallback: ((_ index: Int) -> ())?
    
    @IBAction func leftButtonAction(_ sender: AnyObject) {
        
        self.leftIndicatorView.backgroundColor = Global_yellow_deep
        self.centreIndicatorView.backgroundColor = UIColor.white
        self.rightIndicatorView.backgroundColor = UIColor.white
        
        self.leftButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        self.centreButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.rightButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        if tapCallback != nil {
            self.tapCallback!(0)
        }
        
    }
    
    @IBAction func centreButtonAction(_ sender: AnyObject) {
        
        self.leftIndicatorView.backgroundColor = UIColor.white
        self.centreIndicatorView.backgroundColor = Global_yellow_deep
        self.rightIndicatorView.backgroundColor = UIColor.white
        
        self.leftButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.centreButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        self.rightButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        if tapCallback != nil {
            self.tapCallback!(1)
        }
    }
    
    @IBAction func rightButtonAction(_ sender: AnyObject) {
        
        self.leftIndicatorView.backgroundColor = UIColor.white
        self.centreIndicatorView.backgroundColor = UIColor.white
        self.rightIndicatorView.backgroundColor = Global_yellow_deep
        
        self.leftButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.centreButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.rightButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        
        if tapCallback != nil {
            self.tapCallback!(2)
        }
        
    }
    
    class func getViewHeight() -> CGFloat {
        return 50.0
    }
    
    func configureView(_ displayNumberString: String?) -> () {
        
        if displayNumberString != nil && displayNumberString != "" {
            
            self.rightButton.setTitle(displayNumberString, for: UIControlState())
        }
        
    }
}
