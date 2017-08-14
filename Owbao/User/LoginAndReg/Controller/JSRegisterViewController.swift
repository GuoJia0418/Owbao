//
//  JSRegisterViewController.swift
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


class JSRegisterViewController: BaseViewController {
    @IBOutlet weak var telPhoneLabel: UILabel!     //手机号
    @IBOutlet weak var verifyCodeTextField: UITextField!  //获取验证码输入框
    @IBOutlet weak var getVerifyCodeBtn: UIButton!  //获取验证码
    @IBOutlet weak var pwdTextField: UITextField!   //密码输入框
    
    @IBOutlet weak var eyeBtn: UIButton!       //眼睛
    @IBOutlet weak var eyeBtnWidthConstains: NSLayoutConstraint! //眼睛宽度约束
    @IBOutlet weak var eyeBtnHeightConstains: NSLayoutConstraint! //眼睛高度约束
    
    @IBOutlet weak var recommPhoneTextField: UITextField!    //推荐人手机号
    @IBOutlet weak var switchView: UIView!      //开关view
    @IBOutlet weak var regSwitch: UISwitch!     //开关
    @IBOutlet weak var errorLabel: UILabel!      //错误信息
    @IBOutlet weak var registerBtn: UIButton!     //注册

    @IBOutlet weak var getCodeView: UIView!     //获取验证码view
    //线条
    @IBOutlet weak var verifyCodeLine: UIView!
    @IBOutlet weak var pwdLine: UIView!
    @IBOutlet weak var recommPhoneLine: UIView!
    @IBOutlet weak var pertProgressView: KDCircularProgress!    //倒计时圆环
    
    //手机号码
    var phoneNo: String = ""
    var phoneToken: String = ""  //后台传的手机token(防刷验证码)
    var seconds: Int = 0
    var timer: Timer?
    var timeSecondsBlock:((_ seconds: Int)->())!  //传递倒计时的时间
    
    var drawCircleView: DrawCircleProgressButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let smsTimeStr = Defaults.object(forKey: "RegisterMsgTime")
        if smsTimeStr != nil
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let smsTimeDate = dateFormatter.date(from: smsTimeStr as! String)
            if (smsTimeDate?.timeIntervalSinceNow)! > TimeInterval(-60.00) && smsTimeDate?.timeIntervalSinceNow < 0
            {
                seconds = 60 - Int((smsTimeDate?.timeIntervalSinceNow)!) * (-1)
                self.getVerifyCodeBtn.isEnabled = false
                getVerifyCodeBtn?.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                getVerifyCodeBtn.setTitle("\(seconds)", for: UIControlState())
                
                self.timer?.fireDate = Date()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSRegisterViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("0100004")
        navigationItem.title = "注册"
        
        //显示手机号
        if self.phoneNo != ""
        {
            telPhoneLabel.text = self.phoneNo
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.setTagForTextField()
        self.showSubmitButton()
        
        //点击返回按钮回调
        self.popBeforeCallback = {(popType) in
            
            if popType == .dismissGoHome {
                UserModel.shareInstance.isLogin = 0
                UserModel.shareInstance.uid = 0
                UserModel.shareInstance.isPromptGesturePassword = 0
                UserModel.shareInstance.isSetGestureUnlock = 0
            }
        }

    }

    //MARK: - 设置tag值
    func setTagForTextField() {
        
        self.registerBtn.layer.cornerRadius = 5
        self.registerBtn.layer.masksToBounds = true
        
        //圆环倒计时隐藏
        pertProgressView.trackThickness = 0.25
        pertProgressView.progressThickness = 0.25
        pertProgressView.startAngle = -90
        pertProgressView.glowAmount = 0
        pertProgressView.trackColor = DEFAULT_REDCOLOR//底部圈颜色
        pertProgressView.progressColors = [DEFAULT_REDCOLOR]
        pertProgressView.isHidden = true
        
        //设置UITextField的tag值
        self.verifyCodeTextField.tag = 101
        self.pwdTextField.tag = 102
        self.recommPhoneTextField.tag = 103
        
        recommPhoneTextField.addTarget(self, action: #selector(JSRegisterViewController.showSubmitButton), for: UIControlEvents.allEditingEvents)
        pwdTextField.addTarget(self, action: #selector(JSRegisterViewController.showSubmitButton), for: UIControlEvents.allEditingEvents)
        verifyCodeTextField.addTarget(self, action: #selector(JSRegisterViewController.showSubmitButton), for: UIControlEvents.allEditingEvents)
    }
    
    //MARK: - 点击开关
    @IBAction func clickSwitch(_ sender: UISwitch) {
    
        if regSwitch.isOn
        {
            recommPhoneTextField.isEnabled = true
        }
        else
        {
            recommPhoneTextField.isEnabled = false
        }
    }
    
    //MARK: - 获取验证码之前先获取一下token
    func getPhoneToken()
    {
        //验证手机号
        let dealPhoneNo = self.phoneNo.replacingOccurrences(of: " ", with: "")
        if !dealPhoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        
        IsExistPhoneApi(phoneNo: self.phoneNo).startWithCompletionBlock(success: { (request: YTKBaseRequest?) in
            let resultDict = request?.responseJSONObject as? [String: AnyObject]
            print("手机号是否存在\(resultDict)")
            let isExistPhone = IsExistPhone(dict: resultDict!)
            if isExistPhone.success
            {
                if isExistPhone.map.exists == 1
                {
                    //传入的手机号已经注册过了
                    self.view.showTextHud("您的手机号已经注册,可立即登录")
                    return
                }
                else
                {
                    //注册第二步界面
                    self.phoneToken = isExistPhone.map.time
                    self.getVerifyCode()
                }
            }
            else
            {
                self.view.showTextHud("数据错误，请稍候重试")
            }
        }, failure: { (request: YTKBaseRequest!) in
            self.view.hideHud()
            self.view.showTextHud("网络错误，请稍候重试")
        })

    }
    
    //MARK: 获取验证码
    @IBAction func getVerifyCodeClick(_ sender: UIButton) {
        
        //1: 先去获取phoneToken
        if self.phoneToken != ""
        {
            self.getVerifyCode()
        }
        else
        {
            self.getPhoneToken()
        }
    }
    
    //MARK: - 获取验证码
    func getVerifyCode()
    {
        //验证手机号
        let dealPhoneNo = self.phoneNo.replacingOccurrences(of: " ", with: "")
        if !dealPhoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        //手机号没有注册过
        GainVerifyCode.gainVerifyCode(dealPhoneNo,type: "1", time: jm().sbjm(self.phoneToken), success:
            { (result: GainVerifyCode) -> () in
                self.view.hideHud()

                if result.success == 1 {
                    self.view.showTextHud("短信发送成功")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let str = dateFormatter.string(from: Date())
                    Defaults.set(str, forKey: "RegisterMsgTime")
                    self.getVerifyCodeBtn.isEnabled = false
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerFireMethod(_:)), userInfo: nil, repeats: true)
                    self.seconds = 60
                    
                } else {
                    if result.errorCode == "1002" {
                        self.view.showTextHud("当天短信发送次数超过限制,请联系客服")
                    }
                    else if result.errorCode == "1003"
                    {
                        self.view.showTextHud("短信发送失败")
                    }
                    else if result.errorCode == "8888"
                    {
                        self.view.showTextHud("频繁操作,请稍后再试")
                    }
                    else if result.errorCode == "9999"
                    {
                        self.view.showTextHud("系统错误")
                    }
                    else {
                        self.view.showTextHud("获取失败")
                    }
                    
                }
        }) { (error) -> () in
            self.view.hideHud()
            self.view.showTextHud(NETWORK_ERROR)
        }

    }
    //MARK: 点击眼睛
    @IBAction func eyeBtnClick(_ sender: UIButton) {
        self.pwdTextField.isSecureTextEntry = self.eyeBtn.isSelected
        self.eyeBtn.isSelected = !self.eyeBtn.isSelected
        
        if self.eyeBtn.isSelected {
            self.eyeBtnWidthConstains.constant = 24
            self.eyeBtnHeightConstains.constant = 16.8
        } else {
            self.eyeBtnWidthConstains.constant = 24
            self.eyeBtnHeightConstains.constant = 11
        }
    }
    
    //MARK: - 注册界面
    @IBAction func registerClick(_ sender: UIButton) {
        MobClick.event("0100009")
        
        if !phoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不正确")
            return
        }
        
        // 验证 验证码 是否为 数字
        let dealCode = self.verifyCodeTextField.text!
        if !dealCode.isNumber() {
            self.view.showTextHud("验证码格式不正确")
            return
        }
        
        // 验证 密码 是否格式符合要求
        let dealPwd = self.pwdTextField.text!
        if !dealPwd.isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        
        //开关判断
        var recommPhone = ""
        if regSwitch.isOn {
            
            recommPhone = self.recommPhoneTextField.text!
            if  !recommPhone.isPhoneNo() && recommPhone.trim().characters.count != 0 {
                self.view.showTextHud("推荐人手机号不正确")
                return
            }
        }
        
        //发送注册请求
        self.view.showLoadingHud()
        Register.register(phoneNo, passWord: jm().sbjm(dealPwd), smsCode: dealCode, recommPhone: recommPhone, success: { (result: Register) -> () in
            self.view.hideHud()
            self.view.showTextHud(result.msg!)
            print("注册界面返回的\(result)==\(result.msg!)")
            
            if result.success == 1 {
                
                let mem = result.member
                
                if Defaults.object(forKey: "IsNewHeadExpire") != nil {
                    Defaults.remove("IsNewHeadExpire")
                }
                
                UserModel.shareInstance.uid = mem!.uid
                UserModel.shareInstance.realVerify = mem!.realVerify
                UserModel.shareInstance.tpwdFlag = mem!.tpwdSetting
                UserModel.shareInstance.mobilephone = mem!.mobilephone
                UserModel.shareInstance.idCards = mem!.idCards
                UserModel.shareInstance.token = mem!.token
                UserModel.shareInstance.recommCodes = mem!.recommCodes
                UserModel.shareInstance.isLogin = 1
                UserModel.shareInstance.isShowOpenWindow = 1

                Defaults.removeObject(forKey: "RegisterMsgTime")
                self.view.showTextHud("您已注册成功")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Register_SUCCESS_NOTIFICATION_POST_NOTIFICATION"), object: true)
                
                delay(1, block: { () -> () in
                    
                    let controller = JSRegisterSuccessViewController()
                    controller.regiseter = result
                    controller.popType = .reloadApp
                    self.navigationController?.pushViewController(controller, animated: true)

                })

                
//                delay(1, block: { () -> () in
//                    let vc = JSAuthenticationInformationVC()
//                    vc.setRightButton("跳过")
//                    vc.isRegister = true
////                    vc.navigationItem.leftBarButtonItem = nil
////                    vc.navigationItem.backBarButtonItem = nil
////                    vc.navigationItem.setHidesBackButton(true, animated: false)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                })
                
//                    CLLockVC.showSettingLockVCInVC(self, successBlock: { [weak self] (lockVC: CLLockVC! , PWD: String!) -> Void  in
//                        lockVC.vcType = 0
//                        lockVC.dismiss(0.0)
//                        if let strongSelf = self {
//                            strongSelf.dismissViewControllerAnimated(true, completion: nil)
//                            if GLfromType == JumpToTarget.HomeNoviceBit.rawValue || GLfromType == JumpToTarget.InvestmentPiaoAn.rawValue || GLfromType == JumpToTarget.InvestmentPiaoYou.rawValue || GLfromType == JumpToTarget.HomeRegisterGift.rawValue {
//                            }
//                        }
//                    })
                
            }else{
                if result.errorCode == "1002" {
                    self.view.showTextHud("短信验证码错误")
                } else if result.errorCode == "1001" {
                    self.view.showTextHud("短信验证码为空")
                } else if result.errorCode == "1003" {
                    self.view.showTextHud("手机号为空")
                } else if result.errorCode == "1005" {
                    self.view.showTextHud("密码格式错误")
                } else if result.errorCode == "1006" {
                    self.view.showTextHud("未勾选注册协议")
                } else if result.errorCode == "1007" {
                    self.view.showTextHud("手机号已注册")
                } else if result.errorCode == "1008" {
                    self.view.showTextHud("推荐人不存在")
                } else {
                    self.view.showTextHud("注册失败")
                }
                
            }
            }, failure: { (error) -> () in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
        })

    }
    
    func timerFireMethod(_ theTimer: Timer) {
        if seconds == 1  {
            theTimer.invalidate()
            MobClick.event("0100006")
            let title = "重发验证码"
            getVerifyCodeBtn?.setTitle("\(title)", for: UIControlState())
            getVerifyCodeBtn?.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
            getVerifyCodeBtn?.isEnabled = true
            pertProgressView.isHidden = true
            
        } else {
            seconds -= 1
            let title = "\(seconds)"
            
            getVerifyCodeBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState())
            getVerifyCodeBtn?.setTitle(title, for: UIControlState())
            getVerifyCodeBtn?.isEnabled = false
            pertProgressView.isHidden = false

        }
    }
    
    //MARK: - 添加环形倒计时
    func addCircleView()
    {
        drawCircleView = DrawCircleProgressButton(frame: CGRect(x: verifyCodeTextField.width + verifyCodeTextField.x + (SCREEN_WIDTH - 30) / 3 / 2, y: 10, width: 35, height: 35))
        drawCircleView!.lineWidth = 3
        self.getCodeView.addSubview(self.drawCircleView!)
        
        self.getVerifyCodeBtn.isHidden = true
        self.drawCircleView?.startAnimationDuration(CGFloat(62), with: {
            self.getVerifyCodeBtn.isHidden = false
            self.drawCircleView?.removeFromSuperview()
        })
    }

    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
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
        }
        else if textField.tag == 103 {
            if existedLength! - selectedLength + replaceLength > 11{
                return false
            }
        }
        
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.recommPhoneTextField.resignFirstResponder()
        self.verifyCodeTextField.resignFirstResponder()
        self.pwdTextField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == verifyCodeTextField
        {
            verifyCodeLine.backgroundColor = DEFAULT_REDCOLOR
        }
        else if textField == pwdTextField
        {
            pwdLine.backgroundColor = DEFAULT_REDCOLOR
        }
        else
        {
            if regSwitch.isOn == true
            {
                recommPhoneLine.backgroundColor = DEFAULT_REDCOLOR
                return true
            }
            else
            {
                recommPhoneLine.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
                return false
            }
        }
        
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == verifyCodeTextField
        {
            MobClick.event("0100005")
            verifyCodeLine.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
            
        }
        else if textField == pwdTextField
        {
            MobClick.event("0100007")
            pwdLine.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        }
        else if textField == recommPhoneTextField
        {
            MobClick.event("0100008")
            recommPhoneLine.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        }
        
        return true
    }
    
    //MARK: - 显示提交按钮
    func showSubmitButton(){
        
        let verifyLength = verifyCodeTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let passwordLength = pwdTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let recommPhoneLength = recommPhoneTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        
        if passwordLength >= 6 && passwordLength <= 18 && verifyLength == 4 && (recommPhoneLength == 0 || recommPhoneLength == 11) {
            self.registerBtn.isEnabled = true
            self.registerBtn.backgroundColor = DEFAULT_REDCOLOR
        } else {
            self.registerBtn.isEnabled = false
            self.registerBtn.backgroundColor = UIColor.gray
        }
    }
    
    //手势密码
    func showAlertView()
    {
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "注册成功!"
        alertView.message = "是否立即设置手势密码?"
        alertView.addButton(withTitle: "暂不设置")
        alertView.addButton(withTitle: "立即设置")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex:Int) {
        
//        if buttonIndex == 1
//        {
//            CLLockVC.showSettingLockVCInVC(self, successBlock: { [weak self] (lockVC: CLLockVC! , PWD: String!) -> Void  in
//                //                lockVC.vcType = 0
//                lockVC.dismiss(0.0)
//                if let strongSelf = self {
//                    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                    //                        Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
//                    //                    })
//                }
//
//                })
//        }
//        else
//        {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
        
        if buttonIndex == 1 {
            let vc = GestureUnlockViewController()
            vc.createView()
            vc.state = GestureUnlockState.set
            
            vc.setSuc = {
                psw in
                Defaults.setValue(psw, forKeyPath: "GesturePassword")
                UserModel.shareInstance.isSetGestureUnlock = 1
                self.view.showTextHud("设置手势密码成功")
            }
            
            vc.transitorilyNotSet = { //暂时不设置
                //验证
                UserModel.shareInstance.isSetGestureUnlock = 0
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.showLoadingHud()
            self.view.showLongTextHud("可以在我的信息-手势密码 中进行修改")
            delay(1.5, block: {
                //                self.navigationController?.popToRootViewControllerAnimated(true)
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSRegisterViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
