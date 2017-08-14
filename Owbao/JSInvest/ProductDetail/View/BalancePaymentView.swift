//
//  BalancePaymentView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/16.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class BalancePaymentView: UIView {
    
    var contentView: UIView!
    var accountBalanceLabel: UILabel!    //账户余额
    var payButton: UIButton!             //去支付
    var closeButton: UIButton!
    
    let contentViewH = 166 * SCREEN_SCALE_W
    let margin = CGFloat(64)
    let subViewH = 45 * SCREEN_SCALE_W
    
    var tapActionCallback:(() -> ())?  //点击回调
    var controllerType:Int = 0         //用做友盟统计
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent()
    {
        
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = PopView_BackgroundColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BalancePaymentView.dismissView)))
        
        contentView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - contentViewH - margin, width: SCREEN_WIDTH, height: contentViewH))
        contentView.backgroundColor = UIColorFromRGB(230, green: 230, blue: 230)
        self.addSubview(contentView)
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: subViewH))
        subView.backgroundColor = UIColor.white
        contentView.addSubview(subView)
        
        _ = setupLabel(30, y: 0, width: SCREEN_WIDTH - 60, height: subViewH, font: 16 , textColor: UIColor.black, textAlignment: .center, text: "支付方式", ishaveBorder: false, view: subView)
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: SCREEN_WIDTH - 30, y: 5, width: 30, height: 30)
        closeButton.setBackgroundImage(UIImage(named: "js_close_btn"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(BalancePaymentView.dismissView), for: .touchUpInside)
        subView.addSubview(closeButton)
        
        let secView = UIView(frame: CGRect(x: 0, y: subView.y + subView.height + 1, width: SCREEN_WIDTH, height: contentViewH - subViewH))
        secView.backgroundColor = UIColor.white
        contentView.addSubview(secView)
        
        //去支付按钮
        payButton = UIButton(type: .custom)
        payButton.frame = CGRect(x: 15, y: secView.height - 52, width: SCREEN_WIDTH - 30, height: 48)
        payButton.backgroundColor = UIColorFromRGB(222, green: 87, blue: 79)
        payButton.setTitle("余额不足，立即充值", for: UIControlState())
        payButton.layer.cornerRadius = 5.0
        payButton.layer.masksToBounds = true
        payButton.addTarget(self, action: #selector(BalancePaymentView.payClick), for: .touchUpInside)
        secView.addSubview(payButton)
        
        //账户余额支付（账户余额）
        accountBalanceLabel = setupLabel(15, y: 30, width: SCREEN_WIDTH - 30, height: 20, font: 15, textColor: UIColorFromRGB(152, green: 152, blue: 152), textAlignment: .left, text: "账户余额支付(账户余额:0.00)", ishaveBorder: false, view: secView)
    }
    
    //去支付、去充值按钮
    func payClick(_ sender: UIButton) {
        
        //点击回调
        if self.tapActionCallback != nil {
            self.tapActionCallback!()
        }
    }

    //MARK: - 展示从底部向上弹出的UIView（包含遮罩）
    func showView(_ view: UIView) {
        view.addSubview(self)
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: contentViewH)
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: {
            self.alpha = 1.0
            self.contentView.frame = CGRect(x: 0, y: view.frame.height - self.contentViewH, width: SCREEN_WIDTH, height: self.contentViewH)
        }) { (complete:Bool) in
            
        }
    }
    
    //MARK: - 移除从上向底部弹下去的UIView（包含遮罩）
    func dismissView() {
        
        if self.controllerType == 2 {
            MobClick.event("0400045")
        } else if self.controllerType == 3 {
            MobClick.event("0400064")
        }
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: {
            self.contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH,height: self.contentViewH)
        }) {(finished: Bool)->() in
            self.removeFromSuperview()
            self.contentView.removeFromSuperview()
        }
    }

    func setupLabel(_ x: CGFloat,
                    y: CGFloat,
                    width: CGFloat,
                    height: CGFloat,
                    font: CGFloat,
                    textColor: UIColor,
                    textAlignment: NSTextAlignment,
                    text: String,
                    ishaveBorder: Bool,
                    view: UIView) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.text = text
        if ishaveBorder {
            label.layer.cornerRadius = 2.0
            label.layer.masksToBounds = true
            label.layer.borderColor = DEFAULT_ORANGECOLOR.cgColor
            label.layer.borderWidth = 1.0
        }
        view.addSubview(label)
        return label
    }
}
