//
//  JSWaveAnimateView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/13.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  波浪形动画，利用正弦函数实现

import UIKit

class JSWaveAnimateView: UIView {
    
    var waveHeight: CGFloat = 10  //波浪的高度，不同的数值会有不同的效果
    var speed: CGFloat = 2       //波浪的晃动的速度
    var offset: CGFloat = 0
    
    //刷新
    var displayLink: CADisplayLink?
    
    //里层的layer
    lazy var waveSinLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 0.3).cgColor
        return layer
    }()
    
    //最外层的layer
    lazy var waveSinLayerCover: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 0.4).cgColor
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.creatView()
    }

    func updateWave() {
        self.offset += self.speed
        self.waveSinLayer.path = self.createWavePathSin(index: 0).cgPath
        self.waveSinLayerCover.path = self.createWavePathSin(index: 1).cgPath
    }
    
    func creatView() {
        self.waveSinLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.addSublayer(self.waveSinLayer)
        
        self.waveSinLayerCover.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.addSublayer(self.waveSinLayerCover)
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func stopAnimation() {
        self.displayLink?.invalidate()
        
        self.waveSinLayer.removeAllAnimations()
        self.waveSinLayer.path = nil
        
        self.waveSinLayerCover.removeAllAnimations()
        self.waveSinLayerCover.path = nil
        
        self.displayLink = nil
    }
    
    //创建正弦函数贝塞尔曲线 
    //index: 0第一条sin函数（里面） 1第二条sin函数（外面）
    func createWavePathSin(index: Int) -> UIBezierPath {
        
        let wavePath = UIBezierPath()
        let widht = Int(self.frame.width)
        
        if index == 0 {
            
            wavePath.move(to: CGPoint(x: 0, y: Double(Float(self.waveHeight) * sinf(Float(self.offset) * .pi / Float(self.frame.width)))))
            
            //开始创建正弦函数
            for x in 0 ..< widht + 1 { //2.5表示在self.waveHeight之内有2.5个周期
                var y: Float = 0.0
                y = 1.1 * Float(self.waveHeight) * sinf(2.5 * .pi * Float(x) / Float(self.frame.width) + Float(self.self.offset) * .pi / Float(self.frame.width)) + 12   //12、1.1 这些参数可以调，调后会有不同的效果
                
                wavePath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            
            wavePath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            wavePath.addLine(to: CGPoint(x: 0, y: self.frame.height))
            
        } else {
            
            wavePath.move(to: CGPoint(x: 0, y: Double(Float(self.waveHeight) * sinf(Float(self.offset) * .pi / Float(self.frame.width) + .pi / 4))))
            
            //开始创建正弦函数
            for x in 0 ..< widht + 1 {  //2.5表示在self.waveHeight之内有2.5个周期
                var y: Float = 0.0
                y = Float(self.waveHeight) * sinf(2.5 * .pi * Float(x) / Float(self.frame.width) + 3 * Float(self.offset) * .pi / Float(self.frame.width) + .pi / 4.0) + 12 //12、3这些参数可以调，调后会有不同的效果
                
                wavePath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            
            wavePath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            wavePath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        }
        return wavePath
    }
    
}
