//
//  JSRechargeConfirmViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/1.
//  Copyright © 2017年 xiaofeng. All rights reserved.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSRechargeConfirmViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var telPhoneLabel: UILabel!          //手机号
    @IBOutlet weak var getVerifyCodeBtn: UIButton!      //获取验证码
    @IBOutlet weak var verifyCodeTextFeild: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var getCodeBgView: UIView!           //获取验证码背景
    @IBOutlet weak var getCodeLineView: UILabel!
    @IBOutlet weak var pertProgressView: KDCircularProgress!    //圆圈
    
    var rechargeModel:GoPayModel?
    var phoneNo:String = "" //手机号
    var timer: Timer?
    var seconds: Int = 0
    var drawCircleView:DrawCircleProgressButton?
    var isFromRecharge:Int =  0                     //是从充值进来的
    var timeSecondsBlock:((_ seconds: Int)->())!  //传递倒计时的时间
    
    var orderPayNum:String = ""                        //订单编号
    var rechargeAmount:String = ""                    //充值的金额
    var isSendSMS:Bool = false
    
    var nav:UINavigationController?
    var detailModel: ProductDetailsModel?           //从投资详情传过来的数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTagForTextField()
        //添加圆环动画
        self.addNoAnimateCircleView()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let smsTimeStr = Defaults.object(forKey: "RechargeSMSTime")
        if smsTimeStr != nil 
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let smsTimeDate = dateFormatter.date(from: smsTimeStr as! String)
            if smsTimeDate?.timeIntervalSinceNow > -60 && smsTimeDate?.timeIntervalSinceNow < 0
            {
                seconds = 60 - Int((smsTimeDate?.timeIntervalSinceNow)!) * (-1)
                self.getVerifyCodeBtn.isEnabled = false
                getVerifyCodeBtn?.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                getVerifyCodeBtn.setTitle("\(seconds)", for: UIControlState())
                
                self.timer?.fireDate = Date()
                if self.isFromRecharge == 1
                {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSRechargeConfirmViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
                }

//                self.addCircleView()
            }
            //1002 关闭弹窗
            //验证码错误留着，其他关掉
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.timeSecondsBlock != nil
        {
            print("输出时间是\(self.seconds)")
            self.timeSecondsBlock(self.seconds)
        }
        
//        self.seconds == 0
//        self.timer?.fireDate = Date.distantFuture

    }
    
    //MARK: - 确认充值
    @IBAction func confirmClick(_ sender: UIButton) {
        if self.verifyCodeTextFeild.text!.characters.count != 6 {
            self.view.showTextHud("请输入正确验证码")
            return
        }
        
        if !(self.isSendSMS) {
            self.view.showTextHud("请获取验证码")
            return
        }
        self.view.showLoadingHud()
        weak var weakSelf = self
        GoPayAPI(Uid: UserModel.shareInstance.uid!, PayNum: self.orderPayNum, SmsCode: self.verifyCodeTextFeild.text!).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("充值===\(resultDict)")
            let model:GoPayModel = GoPayModel(dict: resultDict!)
            self.rechargeModel = GoPayModel(dict: resultDict!)
            
            if model.success {
                weakSelf!.view.showTextHud("充值成功!")
                Defaults.removeObject(forKey: "RechargeSMSTime")
                weakSelf!.view.isUserInteractionEnabled = false
                
                delay(1, block: { () -> () in
                    
                    self.rechargeSuccess(2)
                })
            }
            else
            {
                if model.errorCode != ""
                {
                    if model.errorCode == "1004"
                    {
                        weakSelf!.view.showTextHud("处理中!")
                        Defaults.removeObject(forKey: "RechargeSMSTime")
                        weakSelf!.view.isUserInteractionEnabled = false
                        
                        delay(1, block: { () -> () in
                            self.rechargeSuccess(1)
                        })
                    }
                    else
                    {
                        self.rechargeFailed()
                    }

                }
                else
                {
                    self.view.showTextHud("系统错误")
                }

            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误,请稍候重试")
        }

    }
    //MARK: - 充值成功界面
    func rechargeSuccess(_ processStatus:Int)
    {
        let rechargeSuccessVC = JSPaySuccessViewController()
        self.isFromRecharge = 0
        rechargeSuccessVC.toFrom = 1
        rechargeSuccessVC.processStatus = processStatus
        rechargeSuccessVC.rechargeModel = self.rechargeModel
        rechargeSuccessVC.detailModel = self.detailModel
        self.navigationController?.pushViewController(rechargeSuccessVC, animated: true)
    }
    
    
    //MARK: - 充值失败界面
    func rechargeFailed()
    {
        let failVC = JSAuthenticationFailedViewController()
        failVC.rechargeModel = self.rechargeModel
        failVC.rechargeAmount = self.rechargeAmount
        self.isFromRecharge = 0
        
        failVC.rechrgeBackBlock = {(amount:String) in
            self.rechargeAmount = amount
        }
        self.navigationController?.pushViewController(failVC, animated: true)
    }
    
    //MARK: - 获取验证码
    @IBAction func getVerifyCodeClick(_ sender: UIButton) {
        if self.isFromRecharge == 1
        {
            //直接从充值界面过来的
            self.getVerifyCode()
        }
        else
        {
            weak var weakSelf = self
            CreatePayOrderAPI(Uid: UserModel.shareInstance.uid!, Amount: self.rechargeAmount).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in

                let resultDict  = request.responseJSONObject as? [String: AnyObject]
                let model: CreatePayOrderModel = CreatePayOrderModel(dict: resultDict!)
                print("充值创建订单\(resultDict)")
                if model.success
                {
                    //获取验证码界面
                    if model.map != nil && model.map?.bankMobilePhone != "" && model.map?.payNum != nil
                    {
                        self.orderPayNum = (model.map?.payNum)!
                        self.getVerifyCode()
                    }
                    
                } else {
                    if model.errorCode == "9999" {
                        weakSelf!.view.showTextHud("系统错误")
                    } else if model.errorCode == "1001" {
                        weakSelf!.view.showTextHud("金额有误")
                    } else if model.errorCode == "1002" {
                        weakSelf!.view.showTextHud("系统错误，请稍后重试")
                    } else if model.errorCode == "1003" {
                        weakSelf!.view.showTextHud("超过限额，请修改金额后重试")
                    }
                    else{
                        weakSelf!.view.showTextHud("系统错误")
                    }
                }
                
            }) { (request: YTKBaseRequest!) -> Void in
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误")
            }

        }

    }
    
    //MARK: - 获取验证码
    func getVerifyCode()
    {
        if telPhoneLabel.text == ""
        {
            self.view.showTextHud("手机号不能为空")
            return
        }
        
        self.view.showLoadingHud()
        weak var weakSelf = self
        SendRechargeSmsAPI(Uid: UserModel.shareInstance.uid!, PayNum: self.orderPayNum, Type: "1").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            let resultDict  = request.responseJSONObject as? [String: AnyObject]
            print("充值验证码的结果\(resultDict)")
            let model:SendRechargeSmsModel = SendRechargeSmsModel(dict: resultDict!)
            if model.success {
                weakSelf!.view.showTextHud("发送成功")
                weakSelf!.isSendSMS = true
                weakSelf!.verificationCountdown()
                
            } else {
                if model.errorCode == "9999" {
                    weakSelf!.view.showTextHud("系统错误，请稍候再试")
                } else if model.errorCode == "8888" {
                    weakSelf!.view.showTextHud("频繁操作,请稍候再试")
                } else if model.errorCode == "1002" {
                    weakSelf?.view.showTextHud("短信发送失败")
                }
                else
                {
                    weakSelf!.view.showTextHud("系统异常")
                }
            }
        }) { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("系统错误,请稍候再试")
        }
    }
    
    //MARK: 验证码倒计时
    func verificationCountdown(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: Date())
        Defaults.set(str, forKey: "RechargeSMSTime")
        self.getVerifyCodeBtn.isEnabled = false
        
        seconds = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JSRechargeConfirmViewController.timerFireMethod(_:)), userInfo: nil, repeats: true)
    }
    
    //MARK: - 倒计时
    func timerFireMethod(_ theTimer: Timer) {
        if seconds == 1  {
            if theTimer.isValid == true
            {
                 theTimer.invalidate()
                 self.timer = nil
            }
            let title = "重发验证码"
            getVerifyCodeBtn?.setTitle(title, for: UIControlState())
            getVerifyCodeBtn?.isEnabled = true
            getVerifyCodeBtn?.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
            pertProgressView.isHidden = true
            
        } else {
            seconds -= 1
            let title = "\(seconds)"
            getVerifyCodeBtn?.setTitle(title, for: UIControlState())
            getVerifyCodeBtn?.setTitleColor(UIColor(red:160/255.0, green:160/255.0, blue:160/255.0, alpha:1), for: UIControlState())
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
    
    //MARK: - 添加环形倒计时
    func addCircleView()
    {
        drawCircleView = DrawCircleProgressButton(frame: CGRect(x: (self.getVerifyCodeBtn.width - 35) / 2, y: (self.getVerifyCodeBtn.height - 35) / 2, width: 35, height: 35))
        drawCircleView!.lineWidth = 3
        self.getVerifyCodeBtn.addSubview(drawCircleView!)
        self.drawCircleView?.startAnimationDuration(CGFloat(seconds), with: {
            self.drawCircleView?.removeFromSuperview()
        })

    }
    
    //MARK: - 初始化view
    func setupView()
    {
        navigationItem.title = "短信验证"
        
        //显示手机号
        if self.phoneNo != ""
        {
            telPhoneLabel.text = self.phoneNo
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
  
    }

    //MARK: - 设置tag值
    func setTagForTextField() {
        
        self.confirmBtn.layer.cornerRadius = 5
        self.confirmBtn.layer.masksToBounds = true
        //设置UITextField的tag值
        self.verifyCodeTextFeild.delegate = self
    }
    
    //MARK: - 显示提交按钮
    func showSubmitButton(){
        
        let verifyLength = verifyCodeTextFeild.text?.lengthOfBytes(using: String.Encoding.utf8)
       
        if verifyLength == 6
        {
            self.confirmBtn.isEnabled = true
            self.confirmBtn.backgroundColor = UIColor.red
        } else {
            self.confirmBtn.isEnabled = false
            self.confirmBtn.backgroundColor = UIColor.gray
        }
    }

    //MARK: - 验证码textfield限制
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //密码框只能输入数字
        var res = true
        let tmSet = CharacterSet(charactersIn:"0123456789")
        var i = 0
        while i < string.characters.count {
            let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
            let range = string1.rangeOfCharacter(from: tmSet)
            if (range.length == 0) {
                res = false
                break
            }
            i += 1
        }
        return res
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.verifyCodeTextFeild.resignFirstResponder()
        return true
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == verifyCodeTextFeild
        {
            getCodeLineView.backgroundColor = DEFAULT_REDCOLOR
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == verifyCodeTextFeild
        {
            getCodeLineView.backgroundColor = UIColorFromRGB(215, green: 215, blue: 215)
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
        let nibNameOrNil = String?("JSRechargeConfirmViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    

}
