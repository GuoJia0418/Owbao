//
//  JSSetTradePasswordView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSetTradePasswordView: UIView {
    
    var superView:UIView!                          //父view
    var contentView:UIView!                       //整个view
    var closeButton:UIButton!                     //关闭按钮
    var stepFirstLabel:UILabel!                   //第一步
    var stepFirstImgView:UIImageView!             //第一步完成
    var progressLabel:UILabel!                    //中间横线
    var stepSecondLabel:UILabel!                  //第二步
    var tradePwdView:UIView!                      //交易密码框
    var errorLabel:UILabel!                       //错误信息提示
    var keyView:UIView!                           //键盘按钮的view
    
    fileprivate var blackDotArray = [UILabel]()                      //"●"数组
    fileprivate var passWord:String! = ""                            //密码记录
    fileprivate var successPwd:String! = ""
    fileprivate var count:Int = 1                                    //第几次输入
    
    var completeBlock : (((String) -> Void)?)                    //密码输入完成的回调
    var completeCallback: ((_ isSuccess: Bool,_ password: String) -> ())?             //设置密码是否成功回调
    
    
    let contentY = 85 * SCREEN_SCALE_W + 64    //y值
    let process_color = UIColorFromRGB(226, green: 115, blue: 96)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = PopView_BackgroundColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JSSetTradePasswordView.dismissView)))
        setupContent()
    }
    
    func setupContent() {
        
        contentView = UIView(frame: CGRect(x: 0, y: contentY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - contentY))
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: SCREEN_WIDTH - 30, y: 5, width: 30, height: 30)
        closeButton.setImage(UIImage(named: "js_close_btn"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(JSSetTradePasswordView.dismissView), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        //进度
        let stepView = UIView(frame: CGRect(x: 80, y: 25 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 160, height: 33))
        contentView.addSubview(stepView)
        
        //第一步
        stepFirstLabel = setupLabel(0, y: 0, width: 33, height: 33, font: 16.0, textColor: UIColor.white, textAlignment: .center, text: "1", ishaveBorder: false, view: stepView)
        stepFirstLabel.layer.cornerRadius = 33 / 2
        stepFirstLabel.layer.masksToBounds = true
        stepFirstLabel.backgroundColor = process_color
        
        stepFirstImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        stepFirstImgView.image = UIImage(named: "js_set_trade_pwd")
        stepFirstLabel.addSubview(stepFirstImgView)
        stepFirstImgView.isHidden = true
        
        //中间横线
        progressLabel = setupLabel(stepFirstLabel.x + stepFirstLabel.width - 1, y: stepFirstLabel.y + stepFirstLabel.height / 2 - 2, width: SCREEN_WIDTH - 225, height: 5, font: 0, textColor: DEFAULT_GRAYCOLOR, textAlignment: .center, text: "", ishaveBorder: false, view: stepView)
        progressLabel.backgroundColor = DEFAULT_PWD_GRAYCOLOR
        
        //第二步
        stepSecondLabel = setupLabel(progressLabel.x + progressLabel.width, y: 0, width: 33, height: 33, font: 16.0, textColor: UIColor.white, textAlignment: .center, text: "2", ishaveBorder: false, view: stepView)
        stepSecondLabel.layer.cornerRadius = 33 / 2
        stepSecondLabel.layer.masksToBounds = true
        stepSecondLabel.backgroundColor = DEFAULT_PWD_GRAYCOLOR

        //设置/确认交易密码
        let setPwdLabel = setupLabel(0, y: stepView.y + stepView.height + 11, width: SCREEN_WIDTH / 2, height: 13 , font: 13 , textColor: UIColorFromRGB(84, green: 84, blue: 84), textAlignment: .center, text: "设置交易密码", ishaveBorder: false, view: contentView)
        
        let verifyPwdLabel = setupLabel(SCREEN_WIDTH / 2, y: setPwdLabel.y, width: SCREEN_WIDTH / 2, height: 13 , font: 13 , textColor: UIColorFromRGB(84, green: 84, blue: 84), textAlignment: .center, text: "确认交易密码", ishaveBorder: false, view: contentView)
        
        //交易密码框
        tradePwdView = UIView(frame: CGRect(x: 30, y: verifyPwdLabel.y + verifyPwdLabel.height + 25 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 60, height: 45 * SCREEN_SCALE_W))
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
        let grayline = setupLabel(0, y: errorLabel.height + errorLabel.y + 9 * SCREEN_SCALE_W, width: SCREEN_WIDTH, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false, view: contentView)
        grayline.backgroundColor = UIColorFromRGB(236, green: 236, blue: 236)
        
        
        //安全键盘
        let alertView = UIView(frame: CGRect(x: 10, y: grayline.height + grayline.y + 9 * SCREEN_SCALE_W, width: SCREEN_WIDTH - 20, height: 20 * SCREEN_SCALE_W))
        contentView.addSubview(alertView)
        
        let alertImgView = UIImageView(image: UIImage(named: "js_safe_key_icon"))
        alertImgView.size = (alertImgView.image?.size)!
        alertImgView.origin = CGPoint(x: 5, y: (alertView.height - alertImgView.height) / 2)
        alertView.addSubview(alertImgView)
        
        _ = setupLabel(alertImgView.width + alertImgView.x + 5, y: 0, width: alertView.width - alertImgView.width - alertImgView.x - 10 , height: alertView.height, font: 15, textColor: UIColorFromRGB(146, green: 146, blue: 146), textAlignment: .left, text: "嗷呜宝安全键盘", ishaveBorder: false, view: alertView)
        
        //键盘View
        keyView = UIView(frame: CGRect(x: 0, y: alertView.height + alertView.y + 5, width: SCREEN_WIDTH, height: contentView.height - alertView.frame.maxY - 5)) //- 208 * SCREEN_SCALE_W - 65
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
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
                button.tag = 101
                button.backgroundColor = UIColorFromRGB(222, green: 223, blue: 226)
                
            } else if i == 11 {
                button.setImage(UIImage(named: "js_delete_icon"), for: UIControlState())
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
                button.tag = 102
                button.backgroundColor = UIColorFromRGB(222, green: 223, blue: 226)
            } else {
                if i >= 0 {
                    if i == 10 {
                        button.setTitle(numbers[9], for: UIControlState())
                        button.tag = Int(numbers[9])!
                    } else
                    {
                        button.setTitle(numbers[i], for: UIControlState())
                        button.tag = Int(numbers[i])!
                    }
                }
            }
            
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(JSSetTradePasswordView.keyInputAction(_:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20 * SCREEN_WIDTH / 320)
            keyView.addSubview(button)
        }
    }
    
    //MARK: - 密码输入按钮事件
    func keyInputAction(_ button: UIButton) {
        print("按钮\(button.currentTitle)")
        
        //按钮是否可以点击
        if button.tag == 101 {
            button.isEnabled = false
        }
//        if button.tag == 101 {
//            
//            //不可点击
////            for blackDot in blackDotArray {
////                passWord = ""
////                blackDot.hidden = true
////            }
//        }
        
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
//                 print("输出密码\(passWord)以及次数\(count)")
                if count == 1
                {
                    button.isEnabled = clearTradePwd(passWord)
                }
                else
                {
                    //输完第二次密码
                    button.isEnabled = false
                    verifyPassword()
                    delay(1, block: {
                        button.isEnabled = true
                    })
                    
                }
//                completeBlock!(passWord)
            }
        }
    }
    
    //MARK: - 清空输入
    func clearTradePwd(_ secPwd:String)-> Bool
    {
        successPwd = secPwd
        
        //第一步变成对号
        stepFirstImgView.isHidden = false
        progressLabel.backgroundColor = process_color
        
        for blackDot in blackDotArray {
            passWord = ""
            blackDot.isHidden = true
        }
        count = 2
        return true
    }
    //MARK: - 输完第二次密码
    func verifyPassword()
    {
        print("第一次\(successPwd)第二次\(passWord)")
        if passWord == successPwd
        {
            //第二步变成红色
            stepSecondLabel.backgroundColor = process_color
            
            //调用设置密码接口
            setTradePwd()
        }
        else
        {
            tradePwdView.layer.borderColor = DEFAULT_REDCOLOR.cgColor
            errorLabel.text = "您输入的确认密码与第一次输入不一致"
            delay(1, block: {
                //清空
                for blackDot in self.blackDotArray {
                    self.passWord = ""
                    blackDot.isHidden = true
                }
                self.count == 2
                self.tradePwdView.layer.borderColor = UIColorFromRGB(219, green: 219, blue: 219).cgColor
                self.errorLabel.text = ""
            })
        }
    }
    
    //MARK: - 判断两次输入的密码是否一致
    func setTradePwd()
    {
        // 验证 密码 是否格式符合要求
        let dealPwd = passWord
        if !(dealPwd?.isNumberSix())! {
            errorLabel.text = "密码格式不正确"
            return
        }
        
        //  发送注册请求
        self.showLoadingHud()
        weak var weakSelf = self
        
        //短信验证码（立即投资的时候不需要短信验证码 self.verifyCodeTF.text!）
        JYPassWordApi(Tpwd: jm().sbjm(passWord), SmsCode: "", Uid:UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.hideHud()
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("设置交易密码\(resultDict)")
            let model = JYPassWordModel(dict: resultDict!)
            if model.success == false {
                
                if model.errorCode == "1001" {
                    weakSelf!.showTextHud("验证码错误")
                } else if model.errorCode == "1002" {
                    weakSelf!.showTextHud("密码为空")
                } else if model.errorCode == "1003" {
                    weakSelf!.showTextHud("交易密码不合法")
                } else if model.errorCode == "9999" {
                    weakSelf!.showTextHud("系统错误")
                } else {
                    weakSelf!.showTextHud("设置错误")
                }
                
                //设置密码失败回调
                if self.completeCallback != nil {
                    self.completeCallback!(false,"")
                }
            }
            else
            {
                weakSelf!.showTextHud("更改成功")
                UserModel.shareInstance.tpwdFlag = 1
                
                //设置密码成功回调
                if self.completeCallback != nil {
                   self.completeCallback!(true, self.passWord)
                }
                
            }
            }, failure: { (request: YTKBaseRequest!) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showTextHud("网络错误")
                
                //设置密码失败回调
                if self.completeCallback != nil {
                    self.completeCallback!(false,"")
                }
        })
    }
    
    //MARK: 清空所有操作，重新设置密码
    func clearAndResetPassWord() ->  () {
        
        
    }

    //MARK: - 展示从底部向上弹出的UIView（包含遮罩）
    func showView(_ view:UIView)
    {
        superView = view
        view.addSubview(self)
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: contentY)
        //        UIApplication.sharedApplication().keyWindow?.addSubview(presentView)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.alpha = 1.0
            self.contentView.frame = CGRect(x: 0, y: self.contentY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.contentY)
            
        }) { (complete:Bool) in
            
        }
    }
    
    //MARK: - 移除从上向底部弹下去的UIView（包含遮罩）
    func dismissView()
    {
        contentView.frame = CGRect(x: 0, y: self.contentY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.contentY)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH,height: self.contentY)
            
        }) {(finished: Bool)->() in
            self.removeFromSuperview()
            self.contentView.removeFromSuperview()
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
