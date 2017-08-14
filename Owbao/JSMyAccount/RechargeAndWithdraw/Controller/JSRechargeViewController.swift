//
//  JSRechargeViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSRechargeViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var bgView1: UIView!     //图标白色
    @IBOutlet weak var bgView2: UIView!
    
    @IBOutlet weak var bankImgView: UIImageView!        //银行图标
    @IBOutlet weak var bankNameLabel: UILabel!          //银行名称
    @IBOutlet weak var bankCodeLabel: UILabel!          //银行卡号
    @IBOutlet weak var balanceTitleLabel: UILabel!      //可用余额label
    @IBOutlet weak var balanceAmountLabel: UILabel!     //可用余额
    
    @IBOutlet weak var textFieldView: UIView!           //输入框背景view
    @IBOutlet weak var amountTextField: UITextField!    //金额输入框
    @IBOutlet weak var commitButton: UIButton!          //下一步按钮
    
    @IBOutlet weak var alertTitleLabel: UILabel!        //友情提示
    @IBOutlet weak var alertFirstLabel: UILabel!
    @IBOutlet weak var alertSecondLabel: UILabel!
    @IBOutlet weak var alertThirdLabel: UILabel!
    @IBOutlet weak var urgentLabel: UILabel!            //公告label
    
    var bankName:[String] = []                      //银行名称
    var model:RechargeHomeMapModel?
    var detailModel: ProductDetailsModel?           //从投资详情传过来的数据
    var seconds: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barType = .red
        
        //变量初始化
        varSetup()
        //创建view
        setupView()
        //数据
        loadData()
        //按钮显示
        showConfirmBtn()
    }
    
    
    //MARK: -  变量初始化
    func varSetup() {
        bankName = ["中国工商银行","中国农业银行","中国建设银行","中国银行","中国邮政储蓄银行","招商银行","兴业银行","中国光大银行","广发银行","平安银行","中国民生银行","浦发银行","中信银行","上海银行","北京银行","交通银行","兰州银行","华夏银行"]
    }
    
    //MARK: - 初始化
    func setupView() {
        
        self.view.backgroundColor = UIColorFromRGB(219, green: 102, blue: 94)
        navigationItem.title = "充值"
        bgScrollView.alwaysBounceVertical = true
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 100)
        bgScrollView.backgroundColor = UIColor.white
        
        bgView1.backgroundColor = UIColor.white
        bgView1.layer.cornerRadius = 42 / 2
        bgView1.layer.masksToBounds = true
        
        bgView2.backgroundColor = UIColor.white
        bgView2.layer.cornerRadius = 42 / 2
        bgView2.layer.masksToBounds = true
        
        //输入框
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(JSRechargeViewController.changeValue), for: .allEvents)
//        amountTextField.clearButtonMode = .WhileEditing
//        amountTextField.placeholder = "请输入金额"
        //修改键盘（数字+小数点）
//        amountTextField.keyboardType = UIKeyboardType.DecimalPad
        
        //确认按钮
        commitButton.layer.cornerRadius = 5.0
        commitButton.layer.masksToBounds = true
        commitButton.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
        
        //公告
        urgentLabel.isHidden = true

        //将投资金额带入
        if self.detailModel != nil && self.detailModel?.map != nil
        {
            amountTextField.text = "\(detailModel!.map!.inputAmount)"
        }
    }
    
    //MARK: - 显示btn
    func showConfirmBtn()
    {
        if self.detailModel != nil && self.detailModel?.map != nil
        {
            if Double(self.amountTextField.text!)! >= 3.00
            {
                self.commitButton.isEnabled = true
                self.commitButton.backgroundColor = DEFAULT_REDCOLOR
            }
        }
    }
    
    //MARK: - 数据
    override func loadData() {
        
        self.view.showLoadingHud()
        weak var weakSelf = self
        
        RechargeApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("充值界面的数据\(resultDict)")
            let homeModel = RechargeHomeModel(dict: resultDict!)
            weakSelf!.model = homeModel.map
            
            if homeModel.success == true
            {
                self.hideErrorView()
                weakSelf!.refreshView()
            }
            else
            {
                if homeModel.errorCode == "9998"
                {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                }
                else
                {
                    weakSelf!.view.hideHud()
                    weakSelf!.view.showTextHud("系统错误!")
                    weakSelf!.loadDataError()
                }
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.loadDataError()
        }
    }
    
    //MARK: - 刷新视图
    func refreshView()
    {
        bankImgView.image = UIImage(named: "js\((model!.bankCode))")
        if model!.bankCode == 21{
           bankNameLabel.text = "洛阳银行"
        }
        else if model!.bankCode == 22{
           bankCodeLabel.text = "上海农商银行"
        }else{
            bankNameLabel.text = bankName[(model!.bankCode) - 1]
        }
        bankCodeLabel.text = "尾号" + model!.bankNum
        
        balanceTitleLabel.text = "可用余额"
        balanceAmountLabel.text = String(format: "%.2f", model!.funds)
        
        alertSecondLabel.text = "● 银行充值单笔限额\(model!.singleQuota.thousandPoint())元"
        if self.model!.dayQuota == 0{
            self.alertThirdLabel.text = "● 银行充值单日无限额"
        }else {
            self.alertThirdLabel.text = "● 银行充值单日限额\(self.model!.dayQuota.thousandPoint())元"
        }

        if model?.sysArticleList.count != 0 && model?.sysArticleList != nil
        {
            textFieldView.isHidden = true
            commitButton.isHidden = true
            
            urgentLabel.isHidden = false
            urgentLabel.numberOfLines = 0
            urgentLabel.text = model?.sysArticleList[0].summaryContents
            
        }
        else
        {
            textFieldView.isHidden = false
            commitButton.isHidden = false
            urgentLabel.isHidden = true
        }
        
        // 放在请求数据之后
        if self.detailModel != nil && self.detailModel?.map != nil
        {
            if Double(self.amountTextField.text!)! >= 3.00
            {
                self.commitButton.isEnabled = true
                self.commitButton.backgroundColor = DEFAULT_REDCOLOR

                let str = "\((self.amountTextField.text! as NSString).doubleValue + (self.balanceAmountLabel.text! as NSString).doubleValue)"
                self.balanceTitleLabel.text = "充值后可用余额"
                self.balanceAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard(str, decimalPointType: 2, numVerification: false)
            }
        }

    }
    
    //MARK: - 充值下一步 创建订单
    @IBAction func confirmClick(_ sender: UIButton) {
        if self.amountTextField.text?.characters.count == 0 || self.amountTextField.text!.verifyNumberTwo() == false {
            self.view.showTextHud("请输入正确的金额")
            return
        } else if Double(self.amountTextField.text!)! > self.model!.singleQuota {
            self.view.showTextHud("超出单笔充值最大金额")
            return
        } else if Double(self.amountTextField.text!)! < 3.00 {
            self.view.showTextHud("充值金额不能低于3元")
            return
        }
        
        sender.isEnabled = false //设置不可用
        self.view.showLoadingHud()
        weak var weakSelf = self
        
        CreatePayOrderAPI(Uid: UserModel.shareInstance.uid!, Amount: self.amountTextField.text!).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            sender.isEnabled = true //设置可用
            let resultDict  = request.responseJSONObject as? [String: AnyObject]
            let model: CreatePayOrderModel = CreatePayOrderModel(dict: resultDict!)
            print("充值创建订单\(resultDict)")
            if model.success
            {
                //发送充值的短信验证码
                if self.seconds != 1
                {
                    //获取验证码界面
                    if model.map != nil && model.map?.bankMobilePhone != "" && model.map?.payNum != nil
                    {
                        let confirm =  JSRechargeConfirmViewController()
                        confirm.orderPayNum = (model.map?.payNum)!
                        confirm.phoneNo = (model.map?.bankMobilePhone)!
                        confirm.detailModel = self.detailModel
                        confirm.isFromRecharge = 1
                        confirm.isSendSMS = true 
                        confirm.rechargeAmount = self.amountTextField.text!
                        confirm.timeSecondsBlock = {(seconds: Int) in
                            self.seconds = seconds
                        }
                        confirm.seconds = self.seconds
                        self.navigationController?.pushViewController(confirm, animated: true)
                    }
                    
                }
                else
                {
                    if model.map != nil && model.map?.bankMobilePhone != "" && model.map?.payNum != nil
                    {
                        self.getVerifyCode(payModel: model)
                    }
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
                else
                {
                    weakSelf!.view.showTextHud("系统错误")
                }
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.showTextHud("请求失败")
            sender.isEnabled = true //设置可用
            weakSelf!.view.hideHud()
        }
    }
    
    //MARK: - 获取验证码
    func getVerifyCode(payModel: CreatePayOrderModel)
    {
        weak var weakSelf = self
        SendRechargeSmsAPI(Uid: UserModel.shareInstance.uid!, PayNum: payModel.map?.payNum, Type: "1").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            let resultDict  = request.responseJSONObject as? [String: AnyObject]
            print("充值验证码的结果\(resultDict)")
            let model:SendRechargeSmsModel = SendRechargeSmsModel(dict: resultDict!)
            if model.success {
                
                //获取验证码界面
                if payModel.map != nil && payModel.map?.bankMobilePhone != "" && payModel.map?.payNum != nil
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let str = dateFormatter.string(from: Date())
                    Defaults.set(str, forKey: "RechargeSMSTime")
                    
                    let confirm =  JSRechargeConfirmViewController()
                    confirm.orderPayNum = (payModel.map?.payNum)!
                    confirm.phoneNo = (payModel.map?.bankMobilePhone)!
                    confirm.detailModel = self.detailModel
                    confirm.isSendSMS = true
                    confirm.isFromRecharge = 1
                    confirm.rechargeAmount = self.amountTextField.text!
                    confirm.timeSecondsBlock = {(seconds: Int) in
                        self.seconds = seconds
                    }
                    confirm.seconds = self.seconds
                    self.navigationController?.pushViewController(confirm, animated: true)
                }

                
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
    
    //MARK: - 金额输入
    func amountConfig()
    {
        self.balanceAmountLabel.text = String(format: "%.2f", model!.funds)
        
        if self.amountTextField.text?.characters.count == 0
        {
            self.balanceTitleLabel.text = "可用余额"
            self.balanceAmountLabel.text = String(format: "%.2f", model!.funds)
            
        }
//        else if self.amountTextField.text!.verifyNumberTwo() == false {
//            self.view.showTextHud("请输入正确的金额")
//        }
        else if Double(self.amountTextField.text!)! >= 1.00 && Double(self.amountTextField.text!)! < 3.00
        {
            self.commitButton.isEnabled = false
            self.commitButton.backgroundColor = UIColorFromRGB(204, green: 204, blue: 204)
            
            let str = "\(Double(self.amountTextField.text!)! + Double(self.balanceAmountLabel.text!)!)"
            self.balanceTitleLabel.text = "充值后可用余额"
            self.balanceAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard(str, decimalPointType: 2, numVerification: false)
//            self.view.showTextHud("充值金额不能低于3元")
        }
//        else if Double(self.amountTextField.text!)! > self.model!.dayQuota {
//            self.view.showTextHud("超出单笔充值最大金额")
//        }
        else if Double(self.amountTextField.text!)! >= 3.00
        {
            self.commitButton.isEnabled = true
            self.commitButton.backgroundColor = DEFAULT_REDCOLOR

            let str = "\((self.amountTextField.text! as NSString).doubleValue + (self.balanceAmountLabel.text! as NSString).doubleValue)"
            self.balanceTitleLabel.text = "充值后可用余额"
            self.balanceAmountLabel.text = PD_NumDisplayStandard.numDisplayStandard(str, decimalPointType: 2, numVerification: false)
        }

    }
    //MARK: - 限制金额
    func changeValue()
    {
        amountConfig()
    }

    //MARK: -  UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let existedLength = textField.text?.characters.count
        let selectedLength = range.length
        let replaceLength = string.characters.count
        
        if existedLength! - selectedLength + replaceLength > 9{
            return false
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options:.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options: .reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
        
    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        amountConfig()
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.amountTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        amountTextField.resignFirstResponder()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSRechargeViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
