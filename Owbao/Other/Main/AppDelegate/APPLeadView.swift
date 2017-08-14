//
//  APPLeadView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/17.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  app引导页

import UIKit

class APPLeadView: UIView {
    
    var tapCallback:(() -> ())? //点击回调
    
    //开始创建
    class func displayAPPLeadView(_ superView: UIView) -> APPLeadView {
        let leadView = APPLeadView(frame: superView.frame)
        superView.addSubview(leadView)
        leadView.backgroundColor = UIColor.white
        return leadView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showGuidePage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showGuidePage() {
        
        let guipageSCView = UIScrollView(frame: CGRect(x: 0, y: 0 ,width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        guipageSCView.backgroundColor = UIColor.black
        
        for i in 1...3 {
            
            let imgView = UIImageView(frame: CGRect(x: SCREEN_WIDTH * CGFloat((i - 1)), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            imgView.image = UIImage(named: "引导页_\(i)")
            guipageSCView.addSubview(imgView)
            
            if i == 3 {
                let startButton = UIButton(frame: CGRect(x: SCREEN_WIDTH / 2 - SCREEN_WIDTH / 6  + 3, y: SCREEN_HEIGHT - 115 * SCREEN_WIDTH / 320, width: SCREEN_WIDTH / 3, height: 40))
                startButton.layer.masksToBounds = true
                startButton.layer.cornerRadius = 4
                startButton.layer.borderWidth = 1
                startButton.layer.borderColor = UIColorFromRGB(252, green: 88, blue: 79).cgColor
                startButton.setTitleColor(UIColorFromRGB(252, green: 88, blue: 79), for: UIControlState())
                startButton.setTitle("立即体验", for: UIControlState())
                startButton.addTarget(self, action: #selector(APPLeadView.startAction), for: .touchUpInside)
                imgView.addSubview(startButton)
                imgView.isUserInteractionEnabled = true
                
                //适配下界面
                if IS_IPHONE6_PLUS {
                    startButton.y = SCREEN_HEIGHT - 115 * SCREEN_WIDTH / 320
                } else if IS_IPHONE6 {
                    startButton.y = SCREEN_HEIGHT - 115 * SCREEN_WIDTH / 320 - 7
                } else {
                    startButton.y = SCREEN_HEIGHT - 115 * SCREEN_WIDTH / 320 - 10
                }
            }
        }
        
        guipageSCView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: SCREEN_HEIGHT)
        guipageSCView.isPagingEnabled = true
    
        self.addSubview(guipageSCView)
    }
    
    //点击回调
    func startAction() -> () {
        
        if self.tapCallback != nil {
            self.tapCallback!()
        }
    }
}
