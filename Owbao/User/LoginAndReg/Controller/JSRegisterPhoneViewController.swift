//
//  JSRegisterPhoneViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/10.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class JSRegisterPhoneViewController: BaseViewController {

    @IBOutlet weak var telPhoneTextField: UITextField!      //手机号
    @IBOutlet weak var nextBtn: UIButton!   //下一步
    @IBOutlet weak var loginLabel: UILabel!     //显示label
    @IBOutlet weak var textFieldLine: UIView!   //textField输入线
    @IBOutlet weak var protocolLabel: UILabel!  //协议label
    
    var seconds: Int = 1
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showSubmitButton()
        
        //pop等操作之前的回调
        self.popBeforeCallback = {
            (popType: JSNavigationPop)in
            
            if popType == .dismissGoHome { //表示是dismiss操作才会进行以下操作
                UserModel.shareInstance.isLogin = 0
                UserModel.shareInstance.uid = 0
                UserModel.shareInstance.isPromptGesturePassword = 0
                UserModel.shareInstance.isSetGestureUnlock = 0
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /** 
     * 获取需要被present的控制器，该控制器被RootNavigationController管理
     * 且控制器popType的类型是.DismissGoHome类型
     *
     */
    class func getPresentController() -> RootNavigationController {
        let registerVC = JSRegisterPhoneViewController()
        let nvc = RootNavigationController(rootViewController:registerVC)
        registerVC.popType = .dismissGoHome //dismiss操作
        return nvc
    }

    //MARK: 初始化
    func setupView() {
        navigationItem.title = "注册"
        let attributedString = NSMutableAttributedString(string: "已有账号，请登录")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: DEFAULT_REDCOLOR, range: NSMakeRange("已有账号，".characters.count, "请登录".characters.count))
        loginLabel.attributedText = attributedString
        
        nextBtn.layer.cornerRadius = 5.0
        nextBtn.layer.masksToBounds = true
        
        //设置UITextField的tag值
        self.telPhoneTextField.tag = 100
        telPhoneTextField.addTarget(self, action: #selector(JSRegisterPhoneViewController.showSubmitButton), for: UIControlEvents.allEditingEvents)
        
        //协议
        let attributedStr = NSMutableAttributedString(string: "点击下一步代表您已阅读并同意《嗷呜宝注册协议》")
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: DEFAULT_REDCOLOR, range: NSMakeRange("点击下一步代表您已阅读并同意".characters.count, "《嗷呜宝注册协议》".characters.count))
        protocolLabel.attributedText = attributedStr
    }
    
    //MARK: - 下一步
    @IBAction func nextClick(_ sender: UIButton) {
        
        MobClick.event("0100003")
        let dealPhoneNo = self.telPhoneTextField.text!.replacingOccurrences(of: " ", with: "")
        if !dealPhoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        
        //验证手机号是否已经注册
        weak var weakSelf = self
        self.view.showLoadingHud()
        IsExistPhoneApi(phoneNo: dealPhoneNo).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            
            print("手机号是否存在\(resultDict)")
            let isExistPhone = IsExistPhone(dict: resultDict!)
            weakSelf!.view.hideHud()
            
            if isExistPhone.success {
                
                if isExistPhone.map.exists == 1 {
                    //传入的手机号已经注册过了
                    self.view.showTextHud("您的手机号已经注册,可立即登录")
                    
                    //去登陆界面
                    delay(1.0, block: {
                        self.navigationController?.pushViewController(JSLoginViewController.getLoginControllerPopRootType(), animated: true)
                    })
                   
                    return
                }
                else
                {
//                    if isExistPhone.map.time != ""
//                    {
//                        self.getVerifyCode(phoneToken: isExistPhone.map.time)
//                    }
//                    //注册第二步界面
                    if self.seconds != 1
                    {
                        let registerSecondVC = JSRegisterViewController()
                        registerSecondVC.phoneToken = isExistPhone.map.time
                        registerSecondVC.phoneNo = self.telPhoneTextField.text!.replacingOccurrences(of: " ", with: "")
                        registerSecondVC.timeSecondsBlock = {(seconds: Int) in
                            self.seconds = seconds
                        }
                        registerSecondVC.seconds = self.seconds
                        self.navigationController?.pushViewController(registerSecondVC, animated: true)
                    }
                    else
                    {
                        if isExistPhone.map.time != ""
                        {
                            self.getVerifyCode(phoneToken: isExistPhone.map.time)
                        }
                    }

                }
            }
            else
            {
                weakSelf!.view.showTextHud("数据错误，请稍候重试")
            }
            }, failure: { (request: YTKBaseRequest!) in
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误，请稍候重试")
        })
    }
    
    //MARK: - 获取验证码
    func getVerifyCode(phoneToken:String)
    {
        //验证手机号
        let dealPhoneNo = self.telPhoneTextField.text!.replacingOccurrences(of: " ", with: "")
        if !dealPhoneNo.isPhoneNo() {
            self.view.showTextHud("手机号不合法")
            return
        }
        //手机号没有注册过
        GainVerifyCode.gainVerifyCode(dealPhoneNo,type: "1", time: jm().sbjm(phoneToken), success:
            { (result: GainVerifyCode) -> () in
                self.view.hideHud()
                
                if result.success == 1 {
                    self.view.showTextHud("短信发送成功")

                    let registerSecondVC = JSRegisterViewController()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let str = dateFormatter.string(from: Date())
                    Defaults.set(str, forKey: "RegisterMsgTime")
                    
                    registerSecondVC.phoneToken = phoneToken
                    registerSecondVC.phoneNo = self.telPhoneTextField.text!.replacingOccurrences(of: " ", with: "")
                    registerSecondVC.timeSecondsBlock = {(seconds: Int) in
                        self.seconds = seconds
                        }
                    registerSecondVC.seconds = self.seconds
                    self.navigationController?.pushViewController(registerSecondVC, animated: true)
                    
                    
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

    
    //MARK: - 注册协议
    @IBAction func registerProtocolClick(_ sender: UIButton) {
        let pro = RegisterProtocolViewController()
        pro.urlStr = PROTOCOL_URL + RegisterProtocol_Api
        pro.protocolName = "注册协议"
        navigationController?.pushViewController(pro, animated: true)
    }
    
    //MARK: - 去登陆
    @IBAction func goLoginClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(JSLoginViewController.getLoginControllerPopRootType(), animated: true)
    }

    //MARK: - 展示view
    func showSubmitButton() {
        let telPhoneLength = telPhoneTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        if telPhoneLength == 11 {
            self.nextBtn.isEnabled = true
            self.nextBtn.backgroundColor = DEFAULT_REDCOLOR
        } else {
            self.nextBtn.isEnabled = false
            self.nextBtn.backgroundColor = UIColor.gray
        }
    }

    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == telPhoneTextField
        {
            textFieldLine.backgroundColor = DEFAULT_REDCOLOR
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == telPhoneTextField
        {
            MobClick.event("0100002")
            textFieldLine.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
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
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.telPhoneTextField.resignFirstResponder()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSRegisterPhoneViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
