//
//  JSTradePasswordView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSTradePasswordView: UIView {
    var contentView: UIView!                       //整个view
    var closeButton: UIButton!                     //关闭按钮
    var investAmountLabel: UILabel!                     //投资金额（元）
    var tradePwdView: UIView!                      //交易密码框
    var errorLabel: UILabel!                       //错误信息提示
    var forgetTradePasswordButton: UIButton!       //忘记交易密码
    var keyView: UIView!                           //键盘按钮的view
    
    fileprivate var blackDotArray = [UILabel]()       //"●"数组
    fileprivate var passWord:String! = ""             //密码记录
    var completeBlock : (((String) -> Void)?)     //密码输入完成的回调
    var forgetPassword : (()->())!                //忘记密码回调方法
    var controllerType: Int = 0                   //控制器的类型（判断要做统计）
    
    let contentY = 100 * SCREEN_SCALE_W + 64        //y值
    
    let process_color = UIColorFromRGB(226, green: 115, blue: 96)

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = PopView_BackgroundColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JSTradePasswordView.dismissAction)))
        setupContent()
    }
    
    func setupContent() {
        
        contentView = UIView(frame: CGRect(x: 0, y: contentY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - contentY))
        contentView.backgroundColor = UIColorFromRGB(255, green: 255, blue: 255)
        self.addSubview(contentView)
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: SCREEN_WIDTH - 30, y: 5, width: 30, height: 30)
        closeButton.setImage(UIImage(named: "js_close_btn"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(JSTradePasswordView.dismissAction), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        let investMessageLabel = setupLabel(35, y: 10, width: SCREEN_WIDTH - 70, height: 20 * SCREEN_SCALE_W, font: 13, textColor: UIColorFromRGB(80, green: 80, blue: 80), textAlignment: .center, text: "投资金额(元)", ishaveBorder: false, view: contentView)

        investAmountLabel = setupLabel(0, y: investMessageLabel.height + investMessageLabel.y + 5, width: SCREEN_WIDTH, height: 30 * SCREEN_SCALE_W, font: 30, textColor: UIColor.black, textAlignment: .center, text: "1,0000.00", ishaveBorder: false, view: contentView)
        
        //交易密码框
        tradePwdView = UIView(frame: CGRect(x: 30, y: investAmountLabel.y + investAmountLabel.height + 10 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 60, height: 45 * SCREEN_SCALE_W))
        tradePwdView.layer.cornerRadius = 5.0
        tradePwdView.layer.masksToBounds = true
        tradePwdView.layer.borderColor = UIColorFromRGB(219, green: 219, blue: 219).cgColor
        tradePwdView.layer.borderWidth = 1.0
        contentView.addSubview(tradePwdView)
        
        let blackDotW = tradePwdView.width / 6
        for i in 0...5 {
            
            let blackDot = setupLabel(CGFloat(i) * blackDotW, y: 0, width: blackDotW, height: tradePwdView.height, font: 20, textColor: UIColor.black, textAlignment: .center, text: "●", ishaveBorder: false, view: tradePwdView)
            //"●"
            blackDot.isHidden = true
            blackDotArray.append(blackDot)
            
            if i > 0 {
                let verticalLine = UIView(frame:CGRect(x: CGFloat(i) * blackDotW,y: 0,width: 1,height: tradePwdView.height))
                verticalLine.backgroundColor = UIColorFromRGB(219, green: 219, blue: 219)
                tradePwdView.addSubview(verticalLine)
            }
        }
        
        //错误信息提示
        errorLabel = setupLabel(tradePwdView.x , y: tradePwdView.y + tradePwdView.height + 9 * SCREEN_SCALE_W, width: tradePwdView.width, height: 12 * SCREEN_SCALE_W, font: 12, textColor: DEFAULT_REDCOLOR, textAlignment: .left, text: "", ishaveBorder: false, view: contentView)
        
        //横线
        let grayline = setupLabel(0, y: errorLabel.height + errorLabel.y + 8 * SCREEN_SCALE_W, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false, view: contentView)
        grayline.backgroundColor = UIColorFromRGB(236, green: 236, blue: 236)
        
        //安全键盘
        let alertView = UIView(frame: CGRect(x: 10, y: grayline.height + grayline.y + 5 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 20, height: 20 * SCREEN_SCALE_W))
        contentView.addSubview(alertView)
        
        let alertImgView = UIImageView(image: UIImage(named: "js_safe_key_icon"))
        alertImgView.size = (alertImgView.image?.size)!
        alertImgView.origin = CGPoint(x: 0, y: (alertView.height - alertImgView.height) / 2)
        alertView.addSubview(alertImgView)
        
        _ = setupLabel(alertImgView.width + alertImgView.x + 5, y: 0, width: alertView.width - alertImgView.width - alertImgView.x - 10 , height: alertView.height, font: 15, textColor: UIColorFromRGB(146, green: 146, blue: 146), textAlignment: .left, text: "嗷呜宝安全键盘", ishaveBorder: false, view: alertView)
        
        //忘记密码
        forgetTradePasswordButton = UIButton(frame:CGRect(x: alertView.width - 100 , y: 0, width: 100, height: alertView.height))
        forgetTradePasswordButton.setTitle("忘记密码？", for: UIControlState())
        forgetTradePasswordButton.setTitleColor(UIColorFromRGB(78, green: 137, blue: 228), for: UIControlState())
        forgetTradePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        forgetTradePasswordButton.titleLabel?.textAlignment = NSTextAlignment.right
        forgetTradePasswordButton.addTarget(self, action: #selector(JSTradePasswordView.forgetClick), for: UIControlEvents.touchUpInside)
        alertView.addSubview(forgetTradePasswordButton)
            
        //键盘View
        keyView = UIView(frame: CGRect(x: 0, y: alertView.height + alertView.y + 5, width: SCREEN_WIDTH, height: contentView.height - alertView.frame.maxY - 5)) //180 * SCREEN_SCALE_W - 64
        keyView.backgroundColor = UIColorFromRGB(222, green: 223, blue: 226)
        contentView.addSubview(keyView)
        
        let arr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let numbers = arr.sorted { (_, _) -> Bool in
            arc4random() < arc4random()
        }
        
        let row = 4
        let coloumn = 3
        let keyWidth = (SCREEN_WIDTH - 2) / CGFloat(coloumn)
        let keyHeight = (keyView.height - 3) / CGFloat(row)
        
        for i in 0...11 {
            
            let button = UIButton(frame:CGRect(x: CGFloat(i % coloumn) * (keyWidth + 1), y:CGFloat(i / coloumn) * (keyHeight + 1), width: keyWidth, height: keyHeight))
            button.backgroundColor = UIColorFromRGB(251, green: 251, blue: 252)
            
            if i == 9 {
                button.setTitle("", for: UIControlState())
                button.tag = 101
                button.backgroundColor = UIColorFromRGB(222, green: 223, blue: 226)
                
            } else if i == 11 {
                button.setImage(UIImage(named: "js_delete_icon"), for: UIControlState())
                button.tag = 102
                button.backgroundColor = UIColorFromRGB(222, green: 223, blue: 226)
            } else {
                
                if i >= 0 {
                    if i == 10 {
                        button.setTitle(numbers[9], for: UIControlState())
                        button.tag = Int(numbers[9])!
                    } else {
                        button.setTitle(numbers[i], for: UIControlState())
                        button.tag = Int(numbers[i])!
                    }
                }
            }
            
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(JSTradePasswordView.keyInputAction(_:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20 * SCREEN_WIDTH / 320)
            keyView.addSubview(button)
        }
    }
    
    //MARK: dismissAction
    func dismissAction() {
        if self.controllerType == 1 {
           MobClick.event("0400024")
        } else if self.controllerType == 2 {
            MobClick.event("0400044")
        } else if self.controllerType == 3 {
            MobClick.event("0400063")
        }
        
        self.dismissView(animate: true)
    }
    
    //MARK: - 密码输入按钮事件
    func keyInputAction(_ button:UIButton)
    {
        if button.tag == 101
        {
            button.isEnabled = false
        }
        else if button.tag == 102
        {
            button.isEnabled = true
            if passWord.length > 0 {
                let dot = blackDotArray[passWord.characters.count - 1]
                dot.isHidden = true
                let str = (passWord as NSString).substring(with: NSMakeRange(0, passWord.characters.count - 1))
                passWord = str
            }
        } else {
            if passWord.characters.count < 6 {
                button.isEnabled = true
                passWord = passWord + "\(button.tag)"
                for i in 0 ..< passWord.characters.count {
                    blackDotArray[i].isHidden = false
                }
            }
            if passWord.characters.count == 6 {
                print("\(passWord)")
                completeBlock!(passWord)
            }
        }
    }
    
    //MARK: - 忘记密码
    func forgetClick() {
        print("点击了忘记密码")
        if self.forgetPassword != nil {
            self.forgetPassword()
        }
    }
    
    //MARK: - 清空输入
    func clearTradePwd(_ secPwd: String)->Bool {
        
        for blackDot in blackDotArray {
            passWord = ""
            blackDot.isHidden = true
        }
        return true
    }
    
    //MARK: 显示错误信息
    func displayErrorMessage(_ errorMessage: String) -> () {
        self.clearTradePwd("")
        errorLabel.text = errorMessage
        tradePwdView.layer.borderColor = DEFAULT_REDCOLOR.cgColor
    }
    
    //MARK: - 展示从底部向上弹出的UIView（包含遮罩）
    func showView(_ view: UIView) {
        view.addSubview(self)
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.contentY)
        
        //位移动画
        let animation =  POPBasicAnimation()
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.property = POPAnimatableProperty.property(withName: kPOPLayerPositionY) as! POPAnimatableProperty
        animation.fromValue = SCREEN_HEIGHT + (SCREEN_HEIGHT - self.contentY) / 2
        animation.toValue = self.contentY + (SCREEN_HEIGHT - self.contentY) / 2
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        
        //渐变动画
        let animation_1 =  POPBasicAnimation()
        animation_1.duration = 0.25
        animation_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation_1.property = POPAnimatableProperty.property(withName: kPOPLayerOpacity) as! POPAnimatableProperty
        animation_1.fromValue = 0
        animation_1.toValue =  1
        self.layer.pop_add(animation_1, forKey: "OpacityKey")
    }
    
    //MARK: - 移除从上向底部弹下去的UIView（包含遮罩）
    func dismissView(animate: Bool) {
        
        //移动动画
        let animation =  POPBasicAnimation()
        animation.duration = (animate == true) ? 0.3 : 0.000001
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.property = POPAnimatableProperty.property(withName: kPOPLayerPositionY) as! POPAnimatableProperty
        animation.fromValue = self.contentY + (SCREEN_HEIGHT - self.contentY) / 2
        animation.toValue =  SCREEN_HEIGHT + (SCREEN_HEIGHT - self.contentY) / 2
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        
        //渐变动画
        let animation_1 =  POPBasicAnimation()
        animation_1.duration = (animate == true) ? 0.3 : 0.000001
        animation_1.delegate = self
        animation_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation_1.property = POPAnimatableProperty.property(withName: kPOPLayerOpacity) as! POPAnimatableProperty
        animation_1.fromValue = 1
        animation_1.toValue =  0
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        self.layer.pop_add(animation_1, forKey: "OpacityKey")
        
        //所有的子视图增加渐变效果
        for view in contentView.subviews {
            view.layer.pop_add(animation_1, forKey: "OpacityKey")
        }
    }
    
    //MARK: POPAnimationDelegate
    func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        if finished {
            self.removeFromSuperview()
        }
    }

    //MARK: 设置label
    func setupLabel(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,font:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,text:String,ishaveBorder:Bool,view:UIView) -> UILabel
    {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
