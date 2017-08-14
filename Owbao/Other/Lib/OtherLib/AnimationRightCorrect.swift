//
//  AnimationRightCorrect.swift
//  AnimationRight
//
//  Created by user on 16/6/29.
//  Copyright © 2016年 wyx. All rights reserved.
//

import UIKit

class AnimationRightCorrect: UIView {
    
    
    var progressLayer:CAShapeLayer?
    var pointLayer:CAShapeLayer?
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
        
    }
    func creatUI() {
         //绘制圆圈
        let path = UIBezierPath.init(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2), radius: self.frame.size.width / 2, startAngle: CGFloat(M_PI*270/180), endAngle: CGFloat(M_PI * -90 / 180), clockwise: false)
        progressLayer = CAShapeLayer()
        progressLayer?.frame = self.bounds
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.strokeColor = UIColorFromRGB(40, green: 192, blue: 129).cgColor
        progressLayer?.lineCap = kCALineCapRound
        progressLayer?.lineWidth = 2
        progressLayer?.path = path.cgPath
        
        //绘制对勾
        let linePath = UIBezierPath.init()
        linePath.move( to: CGPoint(x: 6, y: 18))
        
        linePath.addLine(to: CGPoint(x: 23 * 3 / 5, y: 45 * 3 / 5))
        linePath.addLine(to: CGPoint(x: 50 * 3 / 5, y: 20 * 3 / 5))
        pointLayer = CAShapeLayer()
        pointLayer?.frame = (progressLayer?.frame)!
        pointLayer?.fillColor = UIColor.clear.cgColor
        pointLayer?.strokeColor = UIColorFromRGB(40, green: 192, blue: 129).cgColor
        pointLayer?.lineCap = kCALineCapRound
        pointLayer?.lineWidth = 2
        pointLayer?.path = linePath.cgPath
        
        self.layer.addSublayer(progressLayer!)
        progressLayer?.addSublayer(pointLayer!)

    }

    func beginAnimated() {
        pointLayer!.isHidden = true;
        //添加自定义动画
        var strokeEndAnimation:CAKeyframeAnimation?
        strokeEndAnimation = CAKeyframeAnimation.init(keyPath: "strokeEnd")
        strokeEndAnimation!.duration = 1
    
        let values = [0,1]
        strokeEndAnimation!.values = values
        strokeEndAnimation!.autoreverses = false
        strokeEndAnimation!.repeatCount = 1
        strokeEndAnimation!.fillMode = kCAFillModeBoth
        
        //修改过的
        //strokeEndAnimation!.delegate = self
        
        strokeEndAnimation!.delegate = self as? CAAnimationDelegate
        strokeEndAnimation!.isRemovedOnCompletion = false
        progressLayer?.add(strokeEndAnimation!, forKey: "strokeEndAnimation")
        
        pointLayer?.isHidden = false
//        var strokeEndAnimation:CAKeyframeAnimation
//        strokeEndAnimation = CAKeyframeAnimation.init(keyPath: "strokeEnd")
//        strokeEndAnimation.duration = 1
//        let values = [0,1]
//        strokeEndAnimation.values = values
//        strokeEndAnimation.autoreverses = false
//        strokeEndAnimation.repeatCount = 1
//        strokeEndAnimation.fillMode = kCAFillModeBoth
//        strokeEndAnimation.delegate = self
//        strokeEndAnimation.removedOnCompletion = false
//        progressLayer?.addAnimation(strokeEndAnimation, forKey: "strokeEndAnimation")
        
        
        
        
    }
    func beginAnimated2() {
        pointLayer!.isHidden = false
        //添加自定义动画
        var strokeEndAnimation2:CAKeyframeAnimation?
        strokeEndAnimation2 = CAKeyframeAnimation.init(keyPath: "strokeEnd")
        strokeEndAnimation2!.duration = 0.4
        
        let values2 = [0,1]
        strokeEndAnimation2!.values = values2;
        strokeEndAnimation2!.autoreverses = false;
        strokeEndAnimation2!.repeatCount = 1;
        strokeEndAnimation2!.fillMode = kCAFillModeBoth;
        strokeEndAnimation2!.delegate = self as? CAAnimationDelegate;
        strokeEndAnimation2!.isRemovedOnCompletion = false;
        pointLayer!.add(strokeEndAnimation2!, forKey: "pointStrokeEndAnimation")
        
//        pointLayer?.hidden = false
//        
//        var strokeEndAnimation:CAKeyframeAnimation
//        strokeEndAnimation = CAKeyframeAnimation.init(keyPath: "strokeEnd")
//        strokeEndAnimation.duration = 0.4
//        let values = [0,1]
//        strokeEndAnimation.values = values
//        strokeEndAnimation.autoreverses = false
//        strokeEndAnimation.repeatCount = 1
//        strokeEndAnimation.fillMode = kCAFillModeBoth
//        strokeEndAnimation.delegate = self
//        strokeEndAnimation.removedOnCompletion = false
//        progressLayer?.addAnimation(strokeEndAnimation, forKey: "pointStrokeEndAnimation")
        
    }
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        
//    }
    
    
    //修改过的
    /*
     
     override func animationDidStop(anim: CAAnimation, finished flag: Bool)
     {
     if anim == progressLayer?.animationForKey("strokeEndAnimation"){
     self.beginAnimated2()
     }else if anim == pointLayer?.animationForKey("pointStrokeEndAnimation") {
     //self.performSelector(#selector(self.beginAnimated), withObject: nil, afterDelay: 0.5)
     }
     }
     
     
     */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
            if anim == progressLayer?.animation(forKey: "strokeEndAnimation"){
                self.beginAnimated2()
            }else if anim == pointLayer?.animation(forKey: "pointStrokeEndAnimation") {
                //self.performSelector(#selector(self.beginAnimated), withObject: nil, afterDelay: 0.5)
            }
        }
}
