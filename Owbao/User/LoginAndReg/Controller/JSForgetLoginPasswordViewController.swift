//
//  JSForgetLoginPasswordViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/10.
//  Copyright © 2017年 wangyuxi. All rights reserved.
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


class JSForgetLoginPasswordViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var telPhoneLabel: UILabel!
    @IBOutlet weak var getVerifyBtn: UIButton!  //获取验证码按钮
    @IBOutlet weak var verifyCodeTextField: UITextField!    //验证码输入框
    @IBOutlet weak var pwdTextField: UITextField!   //密码输入框
    @IBOutlet weak var eyeBtn: UIButton!            //眼睛
    @IBOutlet weak var confirmPwdTextField: UITextField!    //确认密码输入框
    @IBOutlet weak var errorLabel: UILabel!     //错误信息
    @IBOutlet weak var commitButton: UIButton!      //确认按钮
    @IBOutlet weak var getCodeView: UIView!     //获取验证码view
    
    @IBOutlet weak var getVerifyCodeLineView: UIView!  //获取验证码横线
    @IBOutlet weak var pwdLineView: UIView!     //第一个密码横线
    @IBOutlet weak var confirmPwdLineView: UIView!     //第二个密码横线
    @IBOutlet weak var pertProgressView: KDCircularProgress!    //倒计时圆环
    
    var phoneNo: String = ""
    var seconds: Int = 0
    var timer: Timer?
    var type: Int = 0
    var timeSecondsBlock:((_ seconds: Int)->())!  //传递倒计时的时间
    
    var drawCircleView: DrawCircleProgressButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        telPhoneLabel.text = phoneNo
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let smsTimeStr = Defaults.object(forKey: "JSForgetLoginPasswordViewControllerTime")
        if smsTimeStr != nil
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let smsTimeDate = dateFormatter.date(from: smsTimeStr as! String)
            if (smsTimeDate?.timeIntervalSinceNow)! > TimeInterval(-60.00) && smsTimeDate?.timeIntervalSinceNow < 0
            {
                seconds = 60 - Int((smsTimeDate?.timeIntervalSinceNow)!) * (-1)
                self.getVerifyBtn.isEnabled = false
                getVerifyBtn?.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                getVerifyBtn.setTitle("\(seconds)", for: UIControlState())
                
                self.timer?.fireDate = Date()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSForgetLoginPasswordViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.timeSecondsBlock != nil
        {
            print("输出时间是\(self.seconds)")
            self.timeSecondsBlock(self.seconds)
        }
    }
    //MARK: - 初始化
    func setupView() {
        navigationItem.title = "忘记密码"
        commitButton.layer.cornerRadius = 5.0
        commitButton.layer.masksToBounds = true
 
        self.verifyCodeTextField.tag = 101
        self.pwdTextField.tag = 102
        self.confirmPwdTextField.tag = 103
        
        verifyCodeTextField.addTarget(self, action: #selector(showSubmitButton), for: UIControlEvents.allEditingEvents)
        pwdTextField.addTarget(self, action: #selector(showSubmitButton), for: UIControlEvents.allEditingEvents)
        confirmPwdTextField.addTarget(self, action: #selector(showSubmitButton), for: UIControlEvents.allEditingEvents)
        
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = Global_red//底部圈颜色
        pertProgressView.progressColors = [Global_red]
        pertProgressView.isHidden = true
    }

    //MARK: - 眼睛
    @IBAction func eyeClick(_ sender: UIButton) {
        self.pwdTextField.isSecureTextEntry = self.eyeBtn.isSelected
        self.confirmPwdTextField.isSecureTextEntry = self.eyeBtn.isSelected
        self.eyeBtn.isSelected = !self.eyeBtn.isSelected
    }
    
    //MARK: - 获取验证码
    @IBAction func getVerifyCodeBtn(_ sender: UIButton) {
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
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let str = dateFormatter.string(from: Date())
                Defaults.set(str, forKey: "JSForgetLoginPasswordViewControllerTime")
                self.getVerifyBtn.isEnabled = false
                
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerFireMethod(_:)), userInfo: nil, repeats: true)
                self.seconds = 60

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
    
    //MARK: - 提交按钮
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        if !self.verifyCodeTextField.text!.isNumber() {
            self.view.showTextHud("验证码格式不正确")
            return
        }
        // 验证密码
        if !self.pwdTextField.text!.isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        if !self.confirmPwdTextField.text!.isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        
        if self.pwdTextField.text != self.confirmPwdTextField.text {
            errorLabel.text = "两次密码输入不一致,请重新输入"
            return
        }
        
        self.view.showLoadingHud() //加密
        UpdateLoginPassword.updateLoginPassword(0, passWord: jm().sbjm(self.pwdTextField.text!), smsCode: self.verifyCodeTextField.text!, mobilephone: self.phoneNo, success: { (result) -> () in
            
            self.view.hideHud()
            if result.success == 1 {
                self.view.showTextHud("登录密码已重置,请重新登录")
                Defaults.removeObject(forKey: "JSForgetLoginPasswordViewControllerTime")
                
                delay(1, block: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                
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

    //MARK: - 显示btn
    func showSubmitButton(){
        
        let verifyLength = verifyCodeTextField.text?.length
        let passwordLength = pwdTextField.text?.length
        let confirmPwdLength = confirmPwdTextField.text?.length
        
        if passwordLength >= 6 && passwordLength <= 18 && verifyLength == 4 && confirmPwdLength >= 6 && confirmPwdLength <= 18
        {
            self.commitButton.isEnabled = true
            self.commitButton.backgroundColor = Global_yellow_deep
            
        } else {
            self.commitButton.isEnabled = false
            self.commitButton.backgroundColor = UIColor.gray
        }
    }
    
    //MARK: - 倒计时
    func timerFireMethod(_ theTimer: Timer) {
        if seconds == 1  {
            theTimer.invalidate()
            let title = "重发验证码"
            getVerifyBtn.setTitleColor(Global_red, for: UIControlState())
            getVerifyBtn?.setTitle("\(title)", for: UIControlState())
            getVerifyBtn?.isEnabled = true
            pertProgressView.isHidden = true
            
        } else {
            seconds -= 1
            let title = "\(seconds)"
            getVerifyBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState())
            getVerifyBtn?.setTitle(title, for: UIControlState())
            getVerifyBtn?.isEnabled = false
            pertProgressView.isHidden = false
        }
    }

    //MARK: - 添加圆环
    func addNoAnimateCircleView()
    {
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = Global_red//底部圈颜色
        pertProgressView.progressColors = [Global_red]
        pertProgressView.isHidden = true
    }
    
    //MARK: - 添加环形倒计时
    func addCircleView()
    {
        drawCircleView = DrawCircleProgressButton(frame: CGRect(x: verifyCodeTextField.width + verifyCodeTextField.x + (SCREEN_WIDTH - 30) / 3 / 2, y: 10, width: 35, height: 35))
        drawCircleView!.lineWidth = 3
        self.getCodeView.addSubview(self.drawCircleView!)
        
        self.getVerifyBtn.isHidden = true
        self.drawCircleView?.startAnimationDuration(CGFloat(62), with: {
            self.getVerifyBtn.isHidden = false
            self.drawCircleView?.removeFromSuperview()
        })
    }

    
    //MARK: - 输入框
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.verifyCodeTextField.resignFirstResponder()
        self.pwdTextField.resignFirstResponder()
        self.confirmPwdTextField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0{
            return true
        }
        let existedLength = textField.text?.characters.count
        let selectedLength = range.length
        let replaceLength = string.characters.count
        
        if textField.tag == 101 {
            if existedLength! - selectedLength + replaceLength > 4{
                return false
            }
        } else if textField.tag == 102 {
            if existedLength! - selectedLength + replaceLength > 18{
                return false
            }
        }  else if textField.tag == 103 {
            if existedLength! - selectedLength + replaceLength > 18{
                return false
            }
        }
        return true
    }

    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == verifyCodeTextField
        {
            getVerifyCodeLineView.backgroundColor = Global_yellow_deep
        }
        else if textField == pwdTextField
        {
            pwdLineView.backgroundColor = Global_yellow_deep
        }
        else if textField == confirmPwdTextField
        {
            confirmPwdLineView.backgroundColor = Global_yellow_deep
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        
        if textField == verifyCodeTextField
        {
            getVerifyCodeLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
        }
        else if textField == pwdTextField
        {
            pwdLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
        }
        else if textField == confirmPwdTextField
        {
            confirmPwdLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
        }
        return true
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSForgetLoginPasswordViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
}
