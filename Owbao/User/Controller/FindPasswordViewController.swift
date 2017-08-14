
//
//  FindPasswordViewController.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// 原始值的隐式赋值
enum FROMTYPE: Int {
    case confirmpwdvc = 1, myinfovc
} 
class FindPasswordViewController: BaseViewController,UITextFieldDelegate {
    var seconds: Int = 0
    var timer: Timer?
    var type: Int = 0
    var telNum: UILabel!
    var codeBgView:UIView!      //获取验证码背景
    var getVerifyBtn: UIButton!
    var submitButton: UIButton!

    var verifyCodeTF: UITextField!
    var passWordTF: UITextField!
    
    var eyeBtn: UIButton!
    var voiceButton:UIButton!
    
    var fromType: FROMTYPE = .confirmpwdvc
    var phoneNo: String = ""
    var drawCircleView: DrawCircleProgressButton?
    var pertProgressView: KDCircularProgress!    //募集进度的圆圈
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createView()
        if type == 1 {
            navigationItem.title = "重置登录密码"
            submitButton.setTitle("完成", for: UIControlState.disabled)
        }else if type == 2 {
            navigationItem.title = "设置登录密码"
            submitButton.setTitle("完成", for: UIControlState.disabled)
        }
        
//        SetAttributedString(telNum.text!)
//        telNum.text = "已向手机\(phoneNo.phoneNoAddAsterisk())发送短信"
//        getVerifyBtnClickAction(getVerifyBtn)
//        setupRac()
    }
    
    //MARK: - 初始化界面
    func createView(){
        
        self.view.backgroundColor = UIColor.white
        
        //灰色view
        let grayLabel = setupLabel(0, y: 0, width: SCREEN_WIDTH, height: 30 * SCREEN_SCALE_W, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false, view: self.view)
        grayLabel.backgroundColor = UIColorFromRGB(243, green: 243, blue: 243)
        
        //验证码bgView
        let x = CGFloat(15)
        let w = SCREEN_WIDTH - 30
        let h = 45 * SCREEN_SCALE_W
        
        codeBgView = UIView(frame: CGRect(x: x, y: grayLabel.height + grayLabel.y, width: w , height: h))
        codeBgView.backgroundColor = UIColor.white
        self.view.addSubview(codeBgView)
        
        //验证码输入框
        self.verifyCodeTF = UITextField(frame: CGRect(x: 0, y: 0, width: w / 3 * 2, height: h - 1))
        self.verifyCodeTF.placeholder = "请输入验证码"
        self.verifyCodeTF.delegate = self
        self.verifyCodeTF.keyboardType = UIKeyboardType.numberPad
        self.verifyCodeTF.clearButtonMode = .whileEditing
        self.verifyCodeTF.borderStyle = .none
        self.verifyCodeTF.addTarget(self, action: #selector(showSubmitButton), for: UIControlEvents.allEditingEvents)
        codeBgView.addSubview(self.verifyCodeTF)
        
        //获取验证码
        self.getVerifyBtn = UIButton(frame: CGRect(x: verifyCodeTF.width + verifyCodeTF.x, y: 0, width: w / 3, height: h - 1))
        self.getVerifyBtn.setTitle("获取验证码", for: UIControlState())
        self.getVerifyBtn.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())
        self.getVerifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.getVerifyBtn.addTarget(self, action: #selector(FindPasswordViewController.getVerifyBtnClickAction(_:)), for: UIControlEvents.touchUpInside)
        codeBgView.addSubview(self.getVerifyBtn)

        //添加圆环动画
        self.addNoAnimateCircleView()
        
        //线条
        let lineLabel = setupLabel(0, y: verifyCodeTF.height + verifyCodeTF.y, width: w, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false, view: codeBgView)
        lineLabel.backgroundColor = UIColorFromRGB(243, green: 243, blue: 243)
        
        
        //密码背景
        let pwdBgView = UIView(frame: CGRect(x: x, y: codeBgView.height + codeBgView.y, width: w , height: h))
        pwdBgView.backgroundColor = UIColor.white
        self.view.addSubview(pwdBgView)
        
        self.passWordTF = UITextField(frame: CGRect(x: 0,y: 0,width: w - 25 ,height: h - 1))
        self.passWordTF.placeholder = "请输入登录密码"
        self.passWordTF.tag = 1
        self.passWordTF.delegate = self
        self.passWordTF.isSecureTextEntry = true
        self.passWordTF.clearButtonMode = .whileEditing
        self.passWordTF.borderStyle = .none
        self.passWordTF.addTarget(self, action: #selector(showSubmitButton), for: UIControlEvents.allEditingEvents)
        pwdBgView.addSubview(self.passWordTF)
        
        
        self.eyeBtn = UIButton(frame: CGRect(x: passWordTF.width + passWordTF.x,y: (h - 30) / 2, width: 25, height: 25))
        self.eyeBtn.addTarget(self, action: #selector(eyeAction), for: UIControlEvents.touchUpInside)
        self.eyeBtn.setImage(UIImage(named: "js_login_close_eye"), for: UIControlState())
        self.eyeBtn.setImage(UIImage(named: "js_login_open_eye"), for: .highlighted)
        self.eyeBtn.setImage(UIImage(named: "js_login_open_eye"), for: UIControlState.selected)
        pwdBgView.addSubview(self.eyeBtn)
        
        //线条
        let line = setupLabel(0, y: verifyCodeTF.height + verifyCodeTF.y, width: w, height: 1, font: 0, textColor: UIColor.white, textAlignment: .center, text: "", ishaveBorder: false, view: pwdBgView)
        line.backgroundColor = UIColorFromRGB(243, green: 243, blue: 243)
        
        
        let passwordPromptLabel = setupLabel(x, y: pwdBgView.height + pwdBgView.y, width: w, height: 25, font: 12, textColor: DEFAULT_REDCOLOR, textAlignment: .left, text: "登录密码为6-18位数字与字母组合", ishaveBorder: false, view: self.view)
        
        self.submitButton = UIButton(frame: CGRect(x: x, y: passwordPromptLabel.frame.origin.y + 60, width: w, height: h))
        self.submitButton.addTarget(self, action: #selector(submitAction), for: UIControlEvents.touchUpInside)
        self.submitButton.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 5
        self.submitButton.setTitle("修改", for: UIControlState())
        self.submitButton.backgroundColor = DEFAULT_REDCOLOR
        self.submitButton.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addSubview(self.submitButton)
        
        self.showSubmitButton()
    }
    
    //MARK: - 提交按钮点击事件
       func submitAction(){
        if !self.verifyCodeTF.text!.isNumber() {
            self.view.showTextHud("验证码格式不正确")
            return
        }
        // 验证密码
        if !self.passWordTF.text!.isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        self.view.showLoadingHud() //加密
        UpdateLoginPassword.updateLoginPassword(0, passWord: jm().sbjm(self.passWordTF.text!), smsCode: self.verifyCodeTF.text!, mobilephone: self.phoneNo, success: { (result) -> () in
            self.view.hideHud()
            
            if result.success == 1 {
                self.view.showTextHud("设置成功")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                if result.errorCode == "1001" {
                    //1001=验证码错误，1002=密码为空，1003=登录密码不合法，9999系统错误
                    self.view.showTextHud("短信验证码错误")
                } else if result.errorCode == "1002" {
                    self.view.showTextHud("密码为空")
                } else if result.errorCode == "1003" {
                    self.view.showTextHud("登录密码不合法")
                } else if result.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else {
                    self.view.showTextHud("设置失败")
                }
            }
            }, failure: { (error) -> () in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
        })

    }
    
    func eyeAction(){
        
        self.passWordTF.isSecureTextEntry = self.eyeBtn.isSelected
        self.eyeBtn.isSelected = !self.eyeBtn.isSelected
    }
    
    //MARK: - 获取验证码
    @IBAction func getVerifyBtnClickAction(_ sender: UIButton) {
        print("输出手机号\(self.phoneNo)")
        if !self.phoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        self.view.showLoadingHud()
        FindPassword.forgetPwdVerifyCode(0, Mobilephone: self.phoneNo,Type: "1", success: { (result: FindPassword) -> () in
            self.view.hideHud()
            if result.success == 1
            {
                self.view.showTextHud("发送成功")
                
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerFireMethod(_:)), userInfo: nil, repeats: true)
                self.seconds = 60
                //圆圈倒计时
//                self.addCircleView()
                
            } else {
                
                if result.errorCode == "1001" {
                    self.view.showTextHud("发送失败")
                } else if result.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if result.errorCode == "8888" {
                    self.view.showTextHud("频繁操作")
                } else {
                    self.view.showTextHud("发送失败")
                }
            }

            }) { (error) -> () in
                self.view.showTextHud(NETWORK_ERROR)
        }
    }

    
    func SetAttributedString(_ title:String) {
        let labeltitle  = title
        let mub = NSMutableAttributedString(string: labeltitle)
        let smallTextLen = "135****2151".characters.count
        mub.addAttributes([NSForegroundColorAttributeName:UIColor(red:254/255.0, green:118/255.0, blue:52/255.0, alpha:1)], range: NSMakeRange(4, smallTextLen))
        telNum.attributedText = mub
    }
    
    
    //MARK: - 倒计时
    func timerFireMethod(_ theTimer: Timer) {
        
        if seconds == 1  {
            theTimer.invalidate()
            let title = "重发验证码"
            getVerifyBtn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
            getVerifyBtn?.setTitle("\(title)", for: UIControlState())
            getVerifyBtn?.isEnabled = true
            pertProgressView.isHidden = true
            
        } else {
            
            seconds -= 1
            let title = "\(seconds)"
            getVerifyBtn?.setTitle("", for: UIControlState())
            getVerifyBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState())
            getVerifyBtn?.setTitle(title, for: UIControlState())
            getVerifyBtn?.isEnabled = false
            pertProgressView.isHidden = false
            
//            self.drawCircleView?.titleLabel?.font = UIFont.systemFontOfSize(12)
//            self.drawCircleView?.setTitle(title, forState: .Normal)
//            self.drawCircleView?.setTitleColor(DEFAULT_DARKGRAYCOLOR, forState: .Normal)
        }
    }
    //MARK: - 添加圆环
    func addNoAnimateCircleView()
    {
        let circleW = self.getVerifyBtn.height - 5
        let circleX = (getVerifyBtn.width - circleW) / 2
        let circleY = (getVerifyBtn.height - circleW) / 2
        pertProgressView = KDCircularProgress(frame: CGRect(x: circleX, y: circleY, width: circleW, height: circleW))
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = DEFAULT_REDCOLOR//底部圈颜色
        pertProgressView.progressColors = [DEFAULT_REDCOLOR]
        getVerifyBtn.addSubview(pertProgressView!)
        pertProgressView.isHidden = true
    }
    //MARK: - 添加环形倒计时
    func addCircleView()
    {
        drawCircleView = DrawCircleProgressButton(frame: CGRect(x: verifyCodeTF.width + verifyCodeTF.x + (SCREEN_WIDTH - 30) / 3 / 2, y: 10, width: 35, height: 35))
        drawCircleView!.lineWidth = 3
        self.codeBgView.addSubview(self.drawCircleView!)
        
        self.getVerifyBtn.isHidden = true
        self.drawCircleView?.startAnimationDuration(CGFloat(62), with: {
            self.getVerifyBtn.isHidden = false
            self.drawCircleView?.removeFromSuperview()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0{
//            self.showSubmitButton()
            return true
        }
        let existedLength = textField.text?.characters.count
        let selectedLength = range.length
        let replaceLength = string.characters.count
        
        if textField.tag == 0 {
            if existedLength! - selectedLength + replaceLength > 4{
                return false
            }
        } else if textField.tag == 1 {
            if existedLength! - selectedLength + replaceLength > 18{
                return false
            }
        }  else if textField.tag == 2 {
            if existedLength! - selectedLength + replaceLength > 11{
                return false
            }
        }
        //        self.showSubmitButton()
        return true
    }
    
    func showSubmitButton(){

        let verifyLength = verifyCodeTF.text?.length
        let passwordLength = passWordTF.text?.length

        if passwordLength >= 6 && passwordLength <= 18 && verifyLength == 4  {
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = DEFAULT_ORANGECOLOR
        } else {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        }
    }
    
    //MARK: - 设置label
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

    
    //MARK: - init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience  init() {
        
        let nibNameOrNil = String?("FindPasswordViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    //
    //    func setupRac() {
    //        RAC(submitButton, "enabled") <= RACSignal.combineLatest([verifyCodeTF.rac_textSignal(), passWordTF.rac_textSignal()], reduce: { () -> AnyObject! in
    //            return (self.verifyCodeTF.text?.characters.count > 0 && self.passWordTF.text?.characters.count > 0)
    //        })
    //
    //        //             显示 明文 或者显示 暗文
    //        eyeBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) -> Void in
    //            self.passWordTF.secureTextEntry = self.eyeBtn.selected
    //            self.eyeBtn.selected = !self.eyeBtn.selected
    //        }
    //        submitButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (btn: AnyObject!) -> Void in
    //            // 验证验证码
    //            if !self.verifyCodeTF.text!.isNumber() {
    //                self.view.showTextHud("验证码格式不正确")
    //                return
    //            }
    //            // 验证密码
    //            if !self.passWordTF.text!.isPassword() {
    //                self.view.showTextHud("密码格式不正确")
    //                return
    //            }
    //            self.view.showLoadingHud() //加密
    //            UpdateLoginPassword.updateLoginPassword(0, passWord: jm().sbjm(self.passWordTF.text!), smsCode: self.verifyCodeTF.text!, mobilephone: self.phoneNo, success: { (result) -> () in
    //                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats: true)
    //                self.seconds = 60
    //                self.view.hideHud()
    //                self.view.showTextHud(result.msg!)
    //                if result.success == 1 {
    //                    self.navigationController?.popToRootViewControllerAnimated(true)
    //                }
    //                }, failure: { (error) -> () in
    //                    self.view.hideHud()
    //                    self.view.showTextHud("网络错误")
    //            })
    //        }
    //    }

    //MARK: - 废弃
    func voiceAction(){
        //        self.voiceButton.enabled = false
        //        self.voiceButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        if self.seconds == 0 {
            self.getVerifyBtn.isEnabled = false
            self.getVerifyBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
            self.getVerifyBtn.setTitle("重发60秒", for: UIControlState())
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(FindPasswordViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
            seconds = 60
        }
        //        if self.voiceButton.tag == 0 {
        //            self.voiceButton.tag = 1
        //        }
        
        FindPassword.forgetPwdVerifyCode(0, Mobilephone: self.phoneNo,Type: "2", success: { (result: FindPassword) -> () in
            self.view.hideHud()
            if result.success == 1{
                self.view.showTextHud("获取成功请留意您的电话")
            } else {
                
                if result.errorCode == "1001" {
                    self.view.showTextHud("发送失败")
                } else if result.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if result.errorCode == "8888" {
                    self.view.showTextHud("频繁操作")
                } else {
                    self.view.showTextHud("语音发送失败")
                }
            }
            
        }) { (error) -> () in
            self.view.showTextHud(NETWORK_ERROR)
        }
        
    }
    
    
}
