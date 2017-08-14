//
//  AlertPopView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/20.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

enum AlerPopViewType: Int {
    case third = 0  //共有3个title类型的view，第4个UILabel隐藏
    case forth = 1  //共有4个title类型的view
    case second = 2 //共有2个title类型的view
}

enum AlerPopViewBottomButtonType: Int {
    case first = 0  //共有1个底部button，button文字是红色
    case second = 1 //默认，共有2个底部button，左边button文字是灰色，右面文字是红色
}

class AlertPopView: UIView, CAAnimationDelegate {
    
    var isBegin: Bool = true
    var conformCallback: (() -> ())?
    var leftCallback: (() -> ())?
    
    //默认是2个button
    var bottomButtonType: AlerPopViewBottomButtonType = .second {
        didSet {
            self.setBottomButtonNumber(bottomNumber: bottomButtonType.rawValue)
        }
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var bottomSeparateView: UIView!
    @IBOutlet weak var bottomSeparateView_contenConstrains: NSLayoutConstraint! //底部分割线centenX约束
    
    @IBOutlet weak var titleLabel_first: UILabel!
    @IBOutlet weak var titleLabel_second: UILabel!
    @IBOutlet weak var titleLabel_third: UILabel!
    @IBOutlet weak var titleLabel_forth: UILabel!

    @IBOutlet weak var titleLabel_sencod_TopConstains: NSLayoutConstraint!
    @IBOutlet weak var titleLabel_third_topConstrains: NSLayoutConstraint!
    @IBOutlet weak var titleLabel_forh_topConstrains: NSLayoutConstraint!
    
    //配置
    class func configureView(_ superView: UIView,viewTpye: AlerPopViewType) -> AlertPopView {
        
        let backgroundView = UIView(frame: superView.frame)
        backgroundView.backgroundColor = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 0.5)
        
        let popView = Bundle.main.loadNibNamed("AlertPopView", owner: self, options: nil)?.last as? AlertPopView
        backgroundView.addSubview(popView!)
        superView.addSubview(backgroundView)
        
        popView?.isBegin = true
        popView?.setAlertPopViewType(viewTpye: viewTpye)
        
        //设置底部按钮个
        popView?.setBottomButtonNumber(bottomNumber: (popView?.bottomButtonType.rawValue)!)
        
        //确定
        popView?.animateDisplayView(0.75 as AnyObject,toValue: 1.0 as AnyObject)
        return popView!
    }
    
    func animateDisplayView(_ fromValue: AnyObject,toValue: AnyObject) -> () {
        let animate: CABasicAnimation = CABasicAnimation()
        animate.keyPath = "transform.scale"
        animate.fromValue = fromValue
        animate.toValue = toValue
        animate.duration = 0.3
        animate.delegate = self
        animate.isRemovedOnCompletion = true
        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.layer.add(animate,  forKey: "scaleAnimation")
    }
    
    func setAlertPopViewType(viewTpye: AlerPopViewType) {
        
        if viewTpye == .third {
            self.titleLabel_forth.isHidden = true
            self.titleLabel_sencod_TopConstains.constant = 30
            
            self.titleLabel_third_topConstrains.constant = 63
            self.titleLabel_forh_topConstrains.constant = 90
            self.frame = CGRect(x: 20, y: (SCREEN_HEIGHT - 198) / 2, width: SCREEN_WIDTH - 40, height: 198)
        } else if viewTpye == .forth {
            self.frame = CGRect(x: 20, y: (SCREEN_HEIGHT - 215) / 2, width: SCREEN_WIDTH - 40, height: 215)
        } else if viewTpye == .second {
            
            self.titleLabel_forth.isHidden = true
            self.titleLabel_third.isHidden = true
            self.titleLabel_sencod_TopConstains.constant = 25
            self.frame = CGRect(x: 20, y: (SCREEN_HEIGHT - 170) / 2, width: SCREEN_WIDTH - 40, height: 170)
        }
        
        self.layoutIfNeeded()
    }
    
    func animateRemovedView() -> () {
        self.isHidden = true
        self.superview?.removeFromSuperview()        
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.isBegin = false
        self.animateRemovedView()
        
        if self.leftCallback != nil {
            self.leftCallback!()
        }
    }
    
    @IBAction func conformAction(_ sender: AnyObject) {
        self.animateRemovedView()
        self.isBegin = false
        if self.conformCallback != nil {
            self.conformCallback!()
        }
    }
    
    //动画代理
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.isBegin {
            self.isHidden = false
        } else {
            self.isHidden = true
            self.superview?.removeFromSuperview()
        }
    }
    
    func setBottomButtonNumber(bottomNumber: Int) {
        if bottomNumber == 1 {  //底部2个按钮
            
            self.bottomSeparateView.isHidden = false
            self.leftButton.isHidden = false
            self.bottomSeparateView_contenConstrains.constant = 0
            
        } else if bottomNumber == 0 { //底部1个按钮
            self.bottomSeparateView.isHidden = true
            self.leftButton.isHidden = true
            self.bottomSeparateView_contenConstrains.constant = -(SCREEN_WIDTH / 2 - 1)
        }
    }

}
