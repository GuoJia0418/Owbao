//
//  JSLoginViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/9.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSLoginViewController: BaseViewController,UIAlertViewDelegate,GraphCodeViewDelegate {
    
    //手机号
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var loginPwdTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var eyeBtnWidthConstains: NSLayoutConstraint!
    @IBOutlet weak var eyeBtnHeightConstains: NSLayoutConstraint!
    
    //图形验证码graphCodeView
    var graphCodeView: GraphCodeView?        //图形验证码View
    var picCodeModel: JSLoginPicCodeModel?
    
    @IBOutlet weak var picCodeBgView: UIView!   //图形验证码背景view
    @IBOutlet weak var imageVerifyCodeView: UIView!
    @IBOutlet weak var lineView: UIView!        //线条
    @IBOutlet weak var imageVerifyCodeTextField: UITextField!
    
    //错误信息提示
    @IBOutlet weak var errorMsgView: UIView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    //线条
    @IBOutlet weak var phoneLineView: UIView!
    @IBOutlet weak var pwdLineView: UIView!
    @IBOutlet weak var verifyCodeLineView: UIView!
    
    //图标
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var pwdIcon: UIImageView!
    @IBOutlet weak var verifyCodeIcon: UIImageView!
    
    //登录错误3次显示图形验证码
    var loginErrorNums: Int = 0
    var picCode: String?  = ""   //图形验证码
    var seconds: Int = 1
    
    @IBOutlet weak var forgetButtonTop_contrains: NSLayoutConstraint!
    //测试
    var phoneNum: String!
    
    //获取popToRoot类型的登录控制器
    class func getLoginControllerPopRootType() -> JSLoginViewController {
        let controller = JSLoginViewController()
        controller.popType = .popToRoot
        return controller
    }
    
    class func getLoginControllerDismissGoHome() -> JSLoginViewController {
        let controller = JSLoginViewController()
        controller.popType = .dismissGoHome
        return controller
    }
    
    //present受RootNavigationController管理的DismissGoHome类型的登录控制器
    class func presentLoginControllerDismissGoHomeType(_ supreController: BaseViewController) {
        UserModel.shareInstance.logout() //退出登录
        
        let controller = JSLoginViewController()
        controller.popType = .dismissGoHome
        
        let navController = RootNavigationController(rootViewController: controller)
        supreController.present(navController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        showLoginBtn()
        
        //pop之前回调
        self.popBeforeCallback = {
            (popType: JSNavigationPop ) in
            
            if popType == .dismissGoHome {
                UserModel.shareInstance.isLogin = 0
                UserModel.shareInstance.uid = 0
                UserModel.shareInstance.isPromptGesturePassword = 0
                UserModel.shareInstance.isSetGestureUnlock = 0
                //发送更新界面通知
                NotificationCenter.default.post(name: Notification.Name(rawValue: RefreshControllerPostNotification), object: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
  
    
    //MARK: 忘记密码
    @IBAction func forgetLoginPasswordClick(_ sender: UIButton) {
        
        if self.phoneNumTextField.text?.characters.count == 0
        {
            self.view.showTextHud("手机号不能为空")
            return
        }
        
        if self.phoneNumTextField.text?.characters.count < 11
        {
            self.view.showTextHud("请输入正确的手机号")
            return
        }
        
        if !self.phoneNumTextField.text!.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        
        if self.seconds != 1
        {
            let findVC = JSForgetLoginPasswordViewController()
            findVC.phoneNo = self.phoneNumTextField.text!.replacingOccurrences(of: " ", with: "")
            findVC.type = 1
            findVC.timeSecondsBlock = {(seconds: Int) in
                self.seconds = seconds
            }
            findVC.seconds = self.seconds
            self.navigationController?.pushViewController(findVC, animated: true)
        }
        else
        {
            self.getVerifyCode(phoneNo: self.phoneNumTextField.text!.replacingOccurrences(of: " ", with: ""))
        }
    }
    
    //MARK: - 忘记密码发送验证码
    func getVerifyCode(phoneNo: String)
    {
        if !phoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        FindPassword.forgetPwdVerifyCode(0, Mobilephone:phoneNo,Type: "1", success: { (result: FindPassword) -> () in
            self.view.hideHud()
            if result.success == 1
            {
                self.view.showTextHud("发送成功")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let str = dateFormatter.string(from: Date())
                Defaults.set(str, forKey: "JSForgetLoginPasswordViewControllerTime")
                
                let findVC = JSForgetLoginPasswordViewController()
                findVC.phoneNo = self.phoneNumTextField.text!.replacingOccurrences(of: " ", with: "")
                findVC.type = 1
                findVC.timeSecondsBlock = {(seconds: Int) in
                    self.seconds = seconds
                }
                findVC.seconds = self.seconds
                self.navigationController?.pushViewController(findVC, animated: true)
                
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
    
    //MARK: 注册送大礼
    @IBAction func registerBtnClick(_ sender: UIButton) {
        let registerVC = JSRegisterPhoneViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK: 眼睛 显示密码
    @IBAction func eyeBtnClick(_ sender: UIButton) {
        self.loginPwdTextField.isSecureTextEntry = self.eyeBtn.isSelected
        self.eyeBtn.isSelected = !self.eyeBtn.isSelected
        
        if self.eyeBtn.isSelected {
            self.eyeBtnWidthConstains.constant = 24
            self.eyeBtnHeightConstains.constant = 16.8
        } else {
            self.eyeBtnWidthConstains.constant = 24
            self.eyeBtnHeightConstains.constant = 11
        }
    }
    
    //MARK: 登录
    @IBAction func loginConfirmClick(_ sender: UIButton) {
        
        let dealPhoneNo = self.phoneNumTextField.text!.replacingOccurrences(of: " ", with: "")
        if !dealPhoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        
        if !self.loginPwdTextField.text!.replacingOccurrences(of: " ", with: "").isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        // 判断手机号 是否 已经注册过
        self.view.showLoadingHud()
        
        weak var weakSelf = self
        IsExistPhoneApi(phoneNo: dealPhoneNo).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let isExistPhone = IsExistPhone(dict: resultDict!)
            weakSelf!.view.hideHud()
            
            if isExistPhone.success {
                if isExistPhone.map.exists == 1 {
                    
                    JSLoginModel.login(dealPhoneNo, password: jm().sbjm(self.loginPwdTextField.text!), PicCode: self.imageVerifyCodeTextField.text!, success: { (result: JSLoginModel) -> () in
                        self.view.hideHud()
                        
                        if result.success == 1 {
                            
                            if Defaults.object(forKey: "IsNewHeadExpire") != nil {
                                Defaults.remove("IsNewHeadExpire")
                            }
                            self.view.showTextHud("登录成功")
                            
                            UserDefaults.standard.setValue("\(0)", forKey: "loginErrorNum")
                            UserDefaults.standard.synchronize()
                            
//                            UserDefaults.standard.setValue("\(1)", forKey: "InMyAccountShowFuiouWindow")
//                            UserDefaults.standard.synchronize()
                            
                            let mem = result.map?.member
                            UserModel.shareInstance.uid = mem!.uid
                            UserModel.shareInstance.realVerify = mem!.realVerify
                            UserModel.shareInstance.tpwdFlag = mem!.tpwdSetting
                            UserModel.shareInstance.mobilephone = mem!.mobilephone
                            UserModel.shareInstance.isShowOpenWindow = 1
                            
                            if mem!.idCards != nil {
                                UserModel.shareInstance.idCards = mem!.idCards
                            }
                            
                            UserModel.shareInstance.token = result.map?.token
//                            UserModel.shareInstance.token = mem!.token
                            UserModel.shareInstance.isLogin = 1
                            UserModel.shareInstance.recommCodes = mem!.recommCodes
//                            print("输出token ==\(mem!.token)member = \(UserModel.shareInstance.token) == model中的token \(result.map?.token)")
                    
                            NotificationCenter.default.post(name: Notification.Name(rawValue: LoginSucessPostNotification), object: false)
                            
                            /**
                             *  MARK: 登录成功跳出提示是否设置手势密码
                             */
                            if UserModel.shareInstance.isPromptGesturePassword == 0 && UserModel.shareInstance.isSetGestureUnlock == 0 && UserModel.shareInstance.realVerify == 1 {
                                //跳出提示，是否设置手势密码
                                UserModel.shareInstance.isPromptGesturePassword = 1        //第一次跳出提示
                                self.showAlertView()
                            } else {
                                
                                let navController = self.navigationController as? RootNavigationController
                                self.popType = .dismiss  //只退出
                                navController?.popAction(true, popController: self)
                            }
                            
                        } else {
                            
                            //展示图形验证码
                            print("图像验证码\(result.map?.loginErrorNums)")
                            
                            if result.map != nil && result.map?.loginErrorNums != nil {
                                self.loginErrorNums = (result.map?.loginErrorNums)!
                            }
                            
                            if result.msg != nil && result.msg != "" {
                                self.view.showTextHud(result.msg!)
                            }
                            
                            if result.map?.loginErrorNums >= 3 || result.errorCode == "1004" || result.errorCode == "1002" {
                                //MARK:此处调用图形验证码接口
                                self.getPicCode()
                            } else {
                                self.imageVerifyCodeView.isHidden = true
                                self.lineView.isHidden = true
                            }
                        }
                        
                        }, failure: { (error) -> () in
                            
                            self.view.hideHud()
                            self.view.showTextHud("网络错误")
                    })
                    
                }
                else
                {
                    weakSelf!.view.showTextHud("手机号未注册,请注册")
                    return
                }
                
            } else {
                weakSelf!.view.showTextHud("数据错误，请稍候重试")
            }
            
            }, failure: { (request: YTKBaseRequest!) in
                self.view.hideHud()
                self.view.showTextHud("网络错误，请稍候重试")
        })
        
    }
    
    //MARK: - 调用图形验证码接口
    func getPicCode()
    {
        JSLoginPicCodeApi().startWithCompletionBlock(success: { (request:YTKBaseRequest!) in

            let resultDict = request.responseJSONObject as? [String: AnyObject]
//            print("登录图形验证码\(resultDict)")
            self.picCodeModel = JSLoginPicCodeModel(dict: resultDict!)
            if (self.picCodeModel?.success)! == true
            {
                self.imageVerifyCodeView.isHidden = false
                self.lineView.isHidden = false
                self.forgetButtonTop_contrains.constant = 60  //忘记密码顶部约束 70
                
                //设置图形验证码
                self.graphCodeView = GraphCodeView(frame: CGRect(x: 0, y: 0, width: self.picCodeBgView.width, height: self.picCodeBgView.height))
                self.graphCodeView?.delegate = self
                self.picCodeBgView.addSubview(self.graphCodeView!)
                self.graphCodeView?.codeStr = self.picCodeModel?.map?.code
                
                self.imageVerifyCodeTextField.isEnabled = true
            }
            else
            {
                self.imageVerifyCodeView.isHidden = true
                self.lineView.isHidden = true
                
                if self.picCodeModel?.errorCode == "9999"
                {
                    self.view.showTextHud("系统错误，请稍后重试")
                }
                else
                {
                    self.view.showTextHud("\(self.picCodeModel?.errorCode)")
                }
            }
            
        }) { (request:YTKBaseRequest!) in
            
            self.view.hideHud()
            self.view.showTextHud("网络错误")
        }
    }
    //MARK: - 图像验证码代理
    func didTap(_ graphCodeView: GraphCodeView!) {
        self.getPicCode()
        print("点击的图形验证码是\(graphCodeView.codeStr)")
    }
    
    //MARK: - 初始化
    func createUI()
    {
        loginBtn.layer.cornerRadius = 5.0
        loginBtn.layer.masksToBounds = true 
        
        // 显示登录按钮
        self.phoneNumTextField.addTarget(self, action: #selector(JSLoginViewController.showLoginBtn), for: UIControlEvents.allEditingEvents)
        self.loginPwdTextField.addTarget(self, action: #selector(JSLoginViewController.showLoginBtn), for: UIControlEvents.allEditingEvents)
        //图形验证码输入框
        self.imageVerifyCodeTextField.addTarget(self, action:  #selector(JSLoginViewController.showLoginBtn), for: UIControlEvents.allEvents)
        
        self.loginPwdTextField.tag = 102
        self.phoneNumTextField.tag = 100
        self.imageVerifyCodeTextField.tag = 103
        self.imageVerifyCodeTextField.isEnabled = false
        
        if phoneNum != nil {
            self.phoneNumTextField.text = phoneNum!
        }
        
        //图形验证码
        self.imageVerifyCodeView.isHidden = true
        self.verifyCodeLineView.isHidden = true
    }
    
    //MARK: - 展示登录密码
    func showLoginBtn()
    {
        let telPhoneLength = phoneNumTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let passwordLength = loginPwdTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let picCodeLength = imageVerifyCodeTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        
        if loginErrorNums != 3
        {
            if (telPhoneLength == 0 || telPhoneLength == 11) && (passwordLength >= 6 && passwordLength <= 18)
            {
                self.loginBtn.isEnabled = true
                self.loginBtn.backgroundColor = Global_yellow_deep
            }
            else
            {
                self.loginBtn.isEnabled = false
                self.loginBtn.backgroundColor = UIColor.gray
            }
        }
        else
        {
            //MARK: - 后台确定几位
            if (telPhoneLength == 0 || telPhoneLength == 11) && (passwordLength >= 6 && passwordLength <= 18) && picCodeLength == 4
            {
                self.loginBtn.isEnabled = true
                self.loginBtn.backgroundColor = Global_yellow_deep
            }
            else
            {
                self.loginBtn.isEnabled = false
                self.loginBtn.backgroundColor = UIColor.gray
            }
        }
    }
    
    //MARK: 手势密码
    func showAlertView() {
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "登录成功！"
        alertView.message = "是否立即设置手势密码?"
        alertView.addButton(withTitle: "暂不设置")
        alertView.addButton(withTitle: "立即设置")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
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
            
            vc.transitorilyNotSet = {
                //验证
                UserModel.shareInstance.isSetGestureUnlock = 0
                self.view.showTextHud("手势密码已关闭")
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let navController = self.navigationController as? RootNavigationController
            self.popType = .dismiss  //只退出
            navController?.popAction(true, popController: self)
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == phoneNumTextField
        {
            phoneIcon.image = UIImage(named: "js_login_red_mobile")?.withTintColor(Global_yellow_deep)
            phoneLineView.backgroundColor = Global_yellow_deep
            
        }
        else if textField == loginPwdTextField
        {
            pwdIcon.image = UIImage(named: "js_login_red_pwd")?.withTintColor(Global_yellow_deep)
            pwdLineView.backgroundColor = Global_yellow_deep
        }
        else if textField == imageVerifyCodeTextField
        {
            verifyCodeIcon.image = UIImage(named: "js_login_red_protect")?.withTintColor(Global_yellow_deep)
            verifyCodeLineView.backgroundColor = Global_yellow_deep
        }
        return true 
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == phoneNumTextField
        {
            phoneIcon.image = UIImage(named: "js_login_gray_mobile")
            phoneLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
            
        }
        else if textField == loginPwdTextField
        {
            pwdIcon.image = UIImage(named: "js_login_gray_pwd")
            pwdLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
        }
        else if textField == imageVerifyCodeTextField
        {
            verifyCodeIcon.image = UIImage(named: "js_login_gray_protect")
            verifyCodeLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string.characters.count == 0{
            
            return true
        }
        let existedLength = textField.text?.characters.count
        let selectedLength = range.length
        let replaceLength = string.characters.count
        
        if textField.tag == 100 {
            if existedLength! - selectedLength + replaceLength > 11{
                return false
            }
        }
        else if textField.tag == 102 {
            if existedLength! - selectedLength + replaceLength > 18{
                return false
            }
        }
        else if textField.tag == 103 {
            if existedLength! - selectedLength + replaceLength > 4{
                return false
            }
        }

        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.phoneNumTextField.resignFirstResponder()
        self.loginPwdTextField.resignFirstResponder()
        self.imageVerifyCodeTextField.resignFirstResponder()
    }
    
    
    /**
     输入框文字 change 后的操作，主要是要使 手机号 分割
     格式如下——138 7898 7345
     输入框下方展示上面的手机号，
     - parameter textField: 输入手机的操作
     */
    func textFiedAction(_ textField: UITextField) {
        // 避免 字符串中有空格 每次调用  去掉空格
        let chongzhi = textField.text!.replacingOccurrences(of: " ", with: "")
        let text = " "+String(chongzhi)
        let length = text.trim().characters.count
        
        if textField.text?.characters.count > 13 {
            textField.text =  textField.text?.substring(to: (textField.text?.characters.index((textField.text?.startIndex)!, offsetBy: 13))!)
        } else if length > 0 {
            // 输入框为 一旦有文字 的时候 手机号展示（黄色区域） 高度为 64
            //            TelHeightConstraint.constant = 64
            view.layoutIfNeeded()
            var newStr = ""
            var i = 0
            for s in text.characters
            {
                i += 1
                newStr += "\(s)"
                if i % 4 == 0 {
                    newStr +=  " "
                }
            }
            //            telPhoneNumLabel.text = newStr.trim()
            textField.text = newStr.trim()
            if length == 11 {
                if chongzhi.trim().CheckPhoneNo() == true {
                    print(chongzhi.trim())
                    print("11")
                    return
                }
            }
        }else if length == 0 {
            // 输入框为空的时候 手机号不展示 高度为 0
            //            TelHeightConstraint.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSLoginViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
