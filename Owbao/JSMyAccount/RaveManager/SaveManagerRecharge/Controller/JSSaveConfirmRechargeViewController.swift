//
//  JSSaveConfirmRechargeViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSaveConfirmRechargeViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var rechargeAmount: UILabel! //充值金额
    @IBOutlet weak var bankName: UILabel!   //银行名称
    @IBOutlet weak var bankNum: UILabel!    //银行卡号
    @IBOutlet weak var realName: UILabel!   //姓名
    @IBOutlet weak var idCardLabel: UILabel!    //身份证号
    @IBOutlet weak var mobileTextField: UITextField!        //银行预留手机号
    @IBOutlet weak var verifyCodeTextField: UITextField!    //短信验证码textField
    @IBOutlet weak var getVerifyCodeBtn: UIButton!  //获取验证码按钮
    @IBOutlet weak var commitBtn: UIButton! //确定按钮
    @IBOutlet weak var pertProgressView: KDCircularProgress!    //验证码倒计时
    
    var timeSecondsBlock:((_ seconds: Int)->())!  //传递倒计时的时间
    var bankNameArr:[String] = []           //银行名称
    var rechargeModel: RechargeHomeModel?   //充值首页model
    var detailModel: ProductDetailsModel?   //从投资详情传过来的数据
    var fuiouRechargeModel: JSRechargeModel?
    var rechargeVerifyModel: JSRechargeVerificationModel?
    var amount: String = ""                 //充值金额
    var seconds:Int = 0
    var timer:Timer?
    var isFromRecharge:Int =  0                     //是从充值进来的
    var isSendSMS:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //变量初始化
        varSetup()
        //创建view
        setupView()
        //添加圆环动画
        self.addNoAnimateCircleView()
        
        self.showCommitBtn()
    }
    override func leftBarButtonItemAction() {
        super.leftBarButtonItemAction()
        MobClick.event("0300010")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.isFromRecharge != 1
        {
            let smsTimeStr = Defaults.object(forKey: "SaveRechargeSMSTime")
            if smsTimeStr != nil
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let smsTimeDate = dateFormatter.date(from: smsTimeStr as! String)
                if (smsTimeDate?.timeIntervalSinceNow)! > TimeInterval(-180.00) && (smsTimeDate?.timeIntervalSinceNow)! < TimeInterval(0)
                {
                    seconds = 180 - Int((smsTimeDate?.timeIntervalSinceNow)!) * (-1)
                    self.getVerifyCodeBtn.isEnabled = false
                    getVerifyCodeBtn?.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                    getVerifyCodeBtn.layer.borderWidth = 0.0
                    getVerifyCodeBtn.setTitle("\(seconds)", for: UIControlState())
                    
                    self.timer?.fireDate = Date()
                    //                    if self.isFromRecharge == 1
                    //                    {
                    //                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSSaveConfirmRechargeViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
                    //                    }
                    
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if self.timeSecondsBlock != nil
//        {
//            print("输出时间是\(self.seconds)")
//            self.timeSecondsBlock(self.seconds)
//        }
    }
    
    //MARK: -  变量初始化
    func varSetup() {
        bankNameArr = ["中国工商银行","中国农业银行","中国建设银行","中国银行","中国邮政储蓄银行","招商银行","兴业银行","中国光大银行","广发银行","平安银行","中国民生银行","浦发银行","中信银行","上海银行","北京银行","交通银行","兰州银行","华夏银行"]
    }
    
    //MARK: - 初始化
    func setupView() {
        navigationItem.title = "快捷充值"
        self.view.backgroundColor = UIColorFromRGB(219, green: 102, blue: 94)
        bgScrollView.alwaysBounceVertical = true
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 100)
        bgScrollView.backgroundColor = UIColorFromRGB(241, green: 241, blue: 241)
        
        //手机号输入框
        mobileTextField.delegate = self
        mobileTextField.addTarget(self, action: #selector(JSSaveConfirmRechargeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        mobileTextField.tag = 103
        
        //短信验证码输入框
        verifyCodeTextField.delegate = self
        verifyCodeTextField.addTarget(self, action: #selector(JSSaveConfirmRechargeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        verifyCodeTextField.tag = 104
        
//        mobileTextField.addTarget(self, action: #selector(JSSaveRechargeViewController.changeValue), for: .allEvents)
        //        amountTextField.clearButtonMode = .WhileEditing
        //        amountTextField.placeholder = "请输入金额"
        //修改键盘（数字+小数点）
        //        amountTextField.keyboardType = UIKeyboardType.DecimalPad
        
        //获取验证码按钮
        getVerifyCodeBtn.layer.cornerRadius = 2.0
        getVerifyCodeBtn.layer.masksToBounds = true
        getVerifyCodeBtn.layer.borderWidth = 1.0
        getVerifyCodeBtn.layer.borderColor = DEFAULT_REDCOLOR.cgColor
        
        //确认按钮
        commitBtn.layer.cornerRadius = 5.0
        commitBtn.layer.masksToBounds = true
        commitBtn.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        
        //添加倒计倒计时
        self.addNoAnimateCircleView()
        
        //将投资金额带入
//        if self.detailModel != nil && self.detailModel?.map != nil
//        {
//            amountTextField.text = "\(detailModel!.map!.inputAmount)"
//        }
        
        //刷新数据
        refreshView()
        
    }

    func refreshView()
    {
        rechargeAmount.text = amount
        
        if self.rechargeModel?.map != nil
        {
            //银行名称
            if self.rechargeModel?.map!.bankCodeFuiou == 21{
                bankName.text = "洛阳银行"
            }
            else if self.rechargeModel?.map!.bankCodeFuiou == 22{
                bankName.text = "上海农商银行"
            }else{
                bankName.text = bankNameArr[(self.rechargeModel?.map!.bankCodeFuiou)! - 1]
            }
            
            //卡号
            bankNum.text = self.rechargeModel?.map!.bankNoFuiou

            //姓名
            realName.text = self.rechargeModel?.map!.realName
            
            //身份证号
            idCardLabel.text = self.rechargeModel?.map!.idCards
            
            //手机号
            mobileTextField.text = self.rechargeModel?.map!.bankMobilePhoneFuiou
        }
    }
   
    
    
    //MARK: - 获取验证码
    @IBAction func getVerifyCodeClick(_ sender: UIButton) {
        
        MobClick.event("0300007")
        if mobileTextField.text == ""
        {
            self.view.showTextHud("银行预留手机号不能为空")
            return
        }
        else
        {
            if mobileTextField.text?.contains("****") == true
            {
                if self.mobileTextField.text == self.rechargeModel?.map!.bankMobilePhoneFuiou && self.rechargeModel?.map!.bankMobilePhoneFuiou != ""
                {
                    //获取验证码
                    self.getVerifyCodeData(amount: self.amount, bankMobile: self.mobileTextField.text!)
                }
                else
                {
                    if self.mobileTextField.text?.isPhoneNo() == true
                    {
                        //获取验证码
                        self.getVerifyCodeData(amount: self.amount, bankMobile: self.mobileTextField.text!)
                    }
                    else
                    {
                        self.view.showTextHud("请输入正确的手机号")
                        return
                    }
                }
            }
            else
            {
                if self.mobileTextField.text?.isPhoneNo() == true
                {
                    //获取验证码
                    self.getVerifyCodeData(amount: self.amount, bankMobile: self.mobileTextField.text!)
                }
                else
                {
                    self.view.showTextHud("请输入正确的手机号")
                    return
                }

            }
        
        }
    }

    //MARK: - 获取验证码
    func getVerifyCodeData(amount: String,bankMobile: String)
    {
        if self.amount == ""
        {
            self.view.showTextHud("金额不能为空")
            return
        }
        self.view.showLoadingHud()
        
        let model = JSRchargeVerificationCodeViewModel()
        model.requestServer(JSRchargeVerificationCodeApi(uid: UserModel.shareInstance.uid!, amount: amount, bank_mobile: bankMobile), modelName: "JSRechargeVerificationModel", callback: { (baseModel) in
            let model = baseModel as! JSRechargeVerificationModel
            self.rechargeVerifyModel = model
            self.view.hideHud()
            
            if model.success == true
            {
                self.view.showTextHud("发送成功")
                self.isSendSMS = true
                self.verificationCountdown()
            }
            else
            {
                if model.errorCode == "XTWH"
                {//系统维护
                    SystemUpdateViewController.presentSystemUpdateController("")
                }
                else if model.errorCode == "9999"
                {
                    self.view.showTextHud("系统错误")
                }
                else if model.errorCode == "9998"
                {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                }
                else
                {
                   self.view.showTextHud(model.errorMsg)
                }
                
            }
            
            
        }) { (errorString) in
            self.view.hideHud()
            self.view.showTextHud(errorString)
        }
    }
    
    //MARK: 验证码倒计时
    func verificationCountdown(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: Date())
        Defaults.set(str, forKey: "SaveRechargeSMSTime")
        self.getVerifyCodeBtn!.isEnabled = false
//        self.getVerifyCodeBtn?.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
//        self.getVerifyCodeBtn!.setTitle("", for: UIControlState())
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSSaveConfirmRechargeViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
        seconds = 180

    }

    //MARK: 倒计时 - NStimer方法
    func timerFireMethod(_ theTimer: Timer)
    {
        if seconds == 1  {
            theTimer.invalidate()
            getVerifyCodeBtn!.setTitle("重发验证码", for: UIControlState())
            getVerifyCodeBtn!.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())
            getVerifyCodeBtn.layer.borderWidth = 1.0
            getVerifyCodeBtn.layer.borderColor = DEFAULT_REDCOLOR.cgColor
            
            getVerifyCodeBtn!.isEnabled = true
            pertProgressView.isHidden = true
            
        } else {
            seconds -= 1
            let title = "\(seconds)"
            getVerifyCodeBtn.layer.borderWidth = 0
            getVerifyCodeBtn?.setTitle("", for: UIControlState())
            getVerifyCodeBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState())
            getVerifyCodeBtn?.setTitle(title, for: UIControlState())
            getVerifyCodeBtn?.isEnabled = false
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
        pertProgressView.trackColor = DEFAULT_REDCOLOR//底部圈颜色
        pertProgressView.progressColors = [DEFAULT_REDCOLOR]
        pertProgressView.isHidden = true
    }
    
    //MARK: - 点击确认
    @IBAction func commitClick(_ sender: UIButton) {
        MobClick.event("0300009")
        if !(self.isSendSMS) {
            self.view.showTextHud("请获取验证码")
            return
        }
        
        if mobileTextField.text == ""
        {
            self.view.showTextHud("银行预留手机号不能为空")
            return
        }
        else if verifyCodeTextField.text == ""
        {
            self.view.showTextHud("验证码不能为空")
            return
        }
        else if verifyCodeTextField.text?.lengthOfBytes(using: String.Encoding.utf8) != 4
        {
            self.view.showTextHud("请填入正确的验证码")
            return
        }
        else
        {
            if mobileTextField.text?.contains("****") == true
            {
                if self.mobileTextField.text == self.rechargeModel?.map!.bankMobilePhoneFuiou && self.rechargeModel?.map!.bankMobilePhoneFuiou != ""
                {
                    //确认充值
//                    self.mobileTextField.isEnabled = false
                    self.commitRecharge(verifyCode: self.verifyCodeTextField.text!, bankMobile: self.mobileTextField.text!, amount: self.amount)
                }
                else
                {
                    if self.mobileTextField.text?.isPhoneNo() == true
                    {
                        //确认充值
                        self.commitRecharge(verifyCode: self.verifyCodeTextField.text!, bankMobile: self.mobileTextField.text!, amount: self.amount)
                    }
                    else
                    {
                        self.view.showTextHud("请输入正确的手机号")
                        return
                    }
                }
            }
            else
            {
                if self.mobileTextField.text?.isPhoneNo() == true
                {
                    //确认充值
                    self.commitRecharge(verifyCode: self.verifyCodeTextField.text!, bankMobile: self.mobileTextField.text!, amount: self.amount)
                }
                else
                {
                    self.view.showTextHud("请输入正确的手机号")
                    return
                }
                
            }
            
        }

    }
    
    //MARK: - 充值确认
    func commitRecharge(verifyCode: String,bankMobile: String,amount: String)
    {
        self.view.showLoadingHud()
        let model_sub = JSRechargeFuiouViewModel()
        model_sub.requestServer(JSRechargeApi.init(uid: UserModel.shareInstance.uid ?? 0, yzm: verifyCode, bank_mobile: bankMobile, Amount: amount, Order: (self.rechargeVerifyModel?.map?.order)!), modelName: "JSRechargeModel", callback: { (baseModel) in
            self.view.hideHud()
            let model = baseModel as! JSRechargeModel
            self.fuiouRechargeModel = model
            if model.success == true
            {
                self.view.showTextHud("充值成功！")
                Defaults.removeObject(forKey: "SaveRechargeSMSTime")
                self.view.isUserInteractionEnabled = false
                delay(1, block: { () -> () in
                    self.rechargeSuccess(1)
                })

            }
            else
            {
                if model.errorCode == "XTWH"
                {//系统维护
                    SystemUpdateViewController.presentSystemUpdateController("")
                }
                else if model.errorCode == "9999"
                {
                    self.view.showTextHud("系统错误")
                }
                else if model.errorCode == "9998"
                {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                }
                else
                {
                   self.rechargeFailed()
                }
                
            }

        }) { (errorString) in
            
            self.view.hideHud()
            self.view.showTextHud(errorString)
        }
    }
    
    //MARK: - 充值成功界面
    func rechargeSuccess(_ processStatus:Int)
    {
        let rechargeSuccessVC = JSPaySuccessViewController()
        self.isFromRecharge = 0
        rechargeSuccessVC.toFrom = 1
        rechargeSuccessVC.fuiouRechargeAmount = self.amount
        rechargeSuccessVC.processStatus = processStatus
        rechargeSuccessVC.fuiouRechargeModel = self.fuiouRechargeModel
        rechargeSuccessVC.detailModel = self.detailModel
        self.navigationController?.pushViewController(rechargeSuccessVC, animated: true)
    }
    
    
    //MARK: - 充值失败界面
    func rechargeFailed()
    {
        let failVC = JSAuthenticationFailedViewController()
        failVC.fuiouRechargeModel = self.fuiouRechargeModel
        failVC.rechargeAmount = self.amount
        self.isFromRecharge = 0
        
        failVC.rechrgeBackBlock = {(amount:String) in
            self.amount = amount
        }
        self.navigationController?.pushViewController(failVC, animated: true)
    }

    
    //MARK: - UITextField
    /*
     这里就会出现了问题，就是你在输入到12个字的时候，键盘上会有联想字，点击联想字可以直接输入到UITextField中这显然不行的  所以解决办法来了 就是在加上以下这个方法
     */
    func textFieldDidChange(_ sender:UITextField) {
        if sender.tag == 103 {
            if (sender.text?.characters.count)! > 11 {
                sender.text = (sender.text! as NSString).substring(to: 11)
                
            }
        }
        if sender.tag == 104 {
            MobClick.event("0300008")
            if (sender.text?.characters.count)! > 4 {
                sender.text = (sender.text! as NSString).substring(to: 4)
                
            }
        }
        
        self.showCommitBtn()
    }
    
    //MARK: - 确认按钮的可点击状态显示
    func showCommitBtn()
    {
        let telPhoneLength = mobileTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let verifyCodeLength = verifyCodeTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        
        if (telPhoneLength == 11) && (verifyCodeLength)! == 4
        {
            self.commitBtn.isEnabled = true
            self.commitBtn.backgroundColor = DEFAULT_REDCOLOR
        }
        else
        {
            self.commitBtn.isEnabled = false
            self.commitBtn.backgroundColor = UIColorFromRGB(199, green: 199, blue: 199)
        }
    
    }

    
    //MARK: - 输入限制
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.mobileTextField
        {
            if mobileTextField.text?.contains("****") == true
            {
                if self.mobileTextField.text == self.rechargeModel?.map!.bankMobilePhoneFuiou && self.rechargeModel?.map!.bankMobilePhoneFuiou != ""
                {
                    return false
                }
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var res = true
        //手机号输入限制
        if textField.tag == 103 {
            let tmSet = CharacterSet(charactersIn:"0123456789")
            var i = 0
            while i < string.characters.count {
                let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
                let range = string1.rangeOfCharacter(from: tmSet)
                if (range.length == 0) {
                    res = false
                    break;
                }
                i += 1
            }
            //            if textField.text?.characters.count > 12 {
            //                res = false  //会引起删不掉的情况
            //            }
            if range.location >= 11 {
                res = false
            }
            return res
        }
        //验证码输入限制
        if textField.tag == 104 {
            let tmSet = CharacterSet(charactersIn:"0123456789")
            var i = 0
            while i < string.characters.count {
                let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
                let range = string1.rangeOfCharacter(from: tmSet)
                if (range.length == 0) {
                    res = false
                    break;
                }
                i += 1
            }
            if range.location >= 4 {
                res = false
            }
            return res
        }
        
        return res
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSSaveConfirmRechargeViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
}
