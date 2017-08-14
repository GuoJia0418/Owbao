//
//  JYPassWordController.swift
//  Owbao
//
//  Created by lufeng on 16/3/15.
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


class JYPassWordController: BaseViewController,UITextFieldDelegate {
    
    var seconds: Int = 0
    var timer: Timer?

    var getVerifyBtn: UIButton!
    var verifyCodeTF: UITextField!
    var passWordTF: UITextField!
    var eyeBtn: UIButton!
    var submitButton: UIButton!
    var codeBgView:UIView!      //获取验证码背景
    var drawCircleView:DrawCircleProgressButton?
    var pertProgressView: KDCircularProgress!    //募集进度的圆圈
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化
        self.createView()
        
        if UserModel.shareInstance.tpwdFlag == 1 {
            self.title = "重置交易密码"
            submitButton.setTitle("完成", for: UIControlState())
        } else {
            self.title = "设置交易密码"
            submitButton.setTitle("完成", for: UIControlState())
        }
        
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
        self.getVerifyBtn.addTarget(self, action: #selector(JYPassWordController.getVerifyBtnClickAction(_:)), for: UIControlEvents.touchUpInside)
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
        self.passWordTF.placeholder = "输入交易密码"
        self.passWordTF.tag = 1
        self.passWordTF.delegate = self
        self.passWordTF.isSecureTextEntry = true
        self.passWordTF.keyboardType = UIKeyboardType.numberPad
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
        
        
        let passwordPromptLabel = setupLabel(x, y: pwdBgView.height + pwdBgView.y, width: w, height: 25, font: 12, textColor: DEFAULT_REDCOLOR, textAlignment: .left, text: "交易密码为6位数字组合", ishaveBorder: false, view: self.view)
        
        self.submitButton = UIButton(frame: CGRect(x: x, y: passwordPromptLabel.frame.origin.y + 60, width: w, height: h))
        self.submitButton.addTarget(self, action: #selector(submitAction), for: UIControlEvents.touchUpInside)
        self.submitButton.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 5
        self.submitButton.setTitle("完成", for: UIControlState())
        self.submitButton.backgroundColor = DEFAULT_REDCOLOR
        self.submitButton.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addSubview(self.submitButton)
        
        self.showSubmitButton()
        
    }
    
    
    
    func eyeAction(){
        
        self.passWordTF.isSecureTextEntry = self.eyeBtn.isSelected
        self.eyeBtn.isSelected = !self.eyeBtn.isSelected
        
    }
    
    func showSubmitButton(){
        let verifyLength = verifyCodeTF.text?.lengthOfBytes(using: String.Encoding.utf8)
        let passwordLength = passWordTF.text?.lengthOfBytes(using: String.Encoding.utf8)
        
        if passwordLength >= 6 && passwordLength <= 18 && verifyLength == 4  {
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = DEFAULT_ORANGECOLOR
        } else {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        }
    }
    
    
    func getVerifyBtnClickAction(_ sender: UIButton){

//        self.getVerifyBtn.enabled = false
//        self.getVerifyBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, forState: .Normal)
//        self.getVerifyBtn.setTitle("重发60秒", forState: .Normal)
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(JYPassWordController.timerFireMethod(_:)), userInfo: nil, repeats: true)
//        seconds = 60
        
        
//        if self.voiceButton.tag == 1 {
//            self.voiceButton.enabled = false
//            self.voiceButton.setTitleColor(DEFAULT_GRAYCOLOR, forState: .Normal)
//        }
        
        
        weak var weakSelf = self
        ForgetPwdVerifyCodeApi(uid:UserModel.shareInstance.uid ?? 0,type:"1").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("获取验证码的\(resultDict)")
            let model = ForgetPwdModel(dict: resultDict!)
            if model.success == true
            {
                weakSelf!.view.showTextHud("发送成功")
                self.getVerifyBtn.isEnabled = false
//                self.getVerifyBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
//                self.getVerifyBtn.setTitle("重发60秒", for: UIControlState())
                
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JYPassWordController.timerFireMethod(_:)), userInfo: nil, repeats: true)
                self.seconds = 60
                
                //圆圈倒计时
//                self.addCircleView()
            }
            else if model.success == false
            {
                if model.errorCode == "1001"
                {
                    weakSelf!.view.showTextHud("获取失败,请60s后再试")
                }
                else if model.errorCode == "8888"
                {
                    weakSelf!.view.showTextHud("获取失败,请勿频繁操作")
                }
                else
                {
                    weakSelf!.view.showTextHud("系统错误")
                }
                
            }
            
            }, failure: { (request: YTKBaseRequest!) -> Void in
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误")
        })

    }
    func submitAction(){
        // 验证 验证码 是否为 数字
        let dealCode = self.verifyCodeTF.text!
        if !dealCode.isNumber() {
            self.view.showTextHud("验证码格式不正确")
            return
        }
        // 验证 密码 是否格式符合要求
        let dealPwd = self.passWordTF.text!
        if !dealPwd.isNumberSix() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        self.passWordTF.resignFirstResponder()
        //  发送注册请求
        self.view.showLoadingHud()
        weak var weakSelf = self
        JYPassWordApi(Tpwd: jm().sbjm(self.passWordTF.text!), SmsCode: self.verifyCodeTF.text!, Uid:UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
           
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("设置交易密码\(resultDict)")
            let model = JYPassWordModel(dict: resultDict!)
            if model.success == false {

                if model.errorCode == "1001" {
                    weakSelf!.view.showTextHud("验证码错误")
                } else if model.errorCode == "1002" {
                    weakSelf!.view.showTextHud("密码为空")
                } else if model.errorCode == "1003" {
                    weakSelf!.view.showTextHud("交易密码不合法")
                } else if model.errorCode == "9999" {
                    weakSelf!.view.showTextHud("系统错误")
                } else {
                    weakSelf!.view.showTextHud("设置错误")
                }
            }else{
 
                weakSelf!.view.showTextHud("更改成功")
                UserModel.shareInstance.tpwdFlag = 1
                self.navigationController?.popViewController(animated: true)
            }
            }, failure: { (request: YTKBaseRequest!) -> Void in
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误")
        })
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

    //MARK: - 倒计时
    func timerFireMethod(_ theTimer: Timer) {
        if seconds == 1  {
            theTimer.invalidate()
            let title = "重发验证码"
            getVerifyBtn?.setTitle("\(title)", for: UIControlState())
            getVerifyBtn?.isEnabled = true
            self.getVerifyBtn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
            pertProgressView.isHidden = true
            
        } else {
            seconds -= 1
            let title = "\(seconds)"
            getVerifyBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState.disabled)
            getVerifyBtn?.setTitle(title, for: UIControlState())
            getVerifyBtn?.isEnabled = false
            pertProgressView.isHidden = false
        }
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
            if existedLength! - selectedLength + replaceLength > 6{
                return false
            }
        }  else if textField.tag == 2 {
            if existedLength! - selectedLength + replaceLength > 11{
                return false
            }
        }
        return true
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
        let nibNameOrNil = String?("JYPassWordController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    //MARK: - 废弃代码
    func voiceAction(){
        if self.seconds == 0 {
            self.getVerifyBtn.isEnabled = false
//            self.getVerifyBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
//            self.getVerifyBtn.setTitle("重发60秒", for: UIControlState())
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JYPassWordController.timerFireMethod(_:)), userInfo: nil, repeats: true)
            seconds = 60
        }
        weak var weakSelf = self
        
        ForgetPwdVerifyCodeApi(uid:UserModel.shareInstance.uid ?? 0,type:"2").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let model = ForgetPwdModel(dict: resultDict!)
            if model.success == false {
                weakSelf!.view.showTextHud("\((model.errorCode)!)")
            } else {
                weakSelf!.view.showTextHud("获取成功请留意您的电话")
            }
            }, failure: { (request: YTKBaseRequest!) -> Void in
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误")
        })
        
        
    }

}
