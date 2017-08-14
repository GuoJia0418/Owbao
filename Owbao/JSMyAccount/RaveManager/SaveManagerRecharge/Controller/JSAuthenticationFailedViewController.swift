//
//  JSAuthenticationFailedViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/15.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSAuthenticationFailedViewController: BaseViewController {

    @IBOutlet weak var failedTitleLabel: UILabel!       //失败title
    @IBOutlet weak var failedMsgLabel: UILabel!         //失败原因
    @IBOutlet weak var failedBtn: UIButton!             //失败按钮
    var rechrgeBackBlock:((_ rechargeAmount:String)->())! //充值失败回调
    var modelBank:MemberSetBankModel?                   //绑卡界面model
    var rechargeModel:GoPayModel?                       //充值model
    var rechargeAmount:String = ""                      //充值金额要带过来
    
    var fuiouRechargeModel: JSRechargeModel?        //存管充值
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        //绑卡失败
        if modelBank != nil
        {
            self.setupBankModel(modelBank!)
        }
        
        //充值失败
//        if rechargeModel != nil
//        {
//            self.setupRechargeModel(rechargeModel!)
//        }
        
        //存管充值失败
        if fuiouRechargeModel != nil
        {
            self.setupFuiouRechargeModel(fuiouRechargeModel: fuiouRechargeModel!)
        }
    }
    
    //MARK: - 存管充值失败
    func setupFuiouRechargeModel(fuiouRechargeModel:JSRechargeModel)
    {
        self.failedBtn.setTitle("重新充值", for: UIControlState())
        self.failedTitleLabel.text = "充值失败"
        
        let errorAlert: String = "失败原因"
        
        if fuiouRechargeModel.errorMsg != "" || fuiouRechargeModel.errorCode != ""
        {
            failedMsgLabel.text = errorAlert + "\((fuiouRechargeModel.errorCode)):" + fuiouRechargeModel.errorMsg
        }
        else
        {
            failedMsgLabel.text = errorAlert + ":系统错误"
        }
    }
    
    //MARK: - 充值失败
    func setupRechargeModel(_ rechargeModel:GoPayModel)
    {
        var errorMsg: String = ""
        let dict = ["9999": "系统错误",
                    "1001": "充值金额有误",
                    "1002":"验证码不能为空",
                    "1003":"验证码错误",
                    "1004":"处理中",
                    "1005":"系统错误，请稍后重试",
                    "1006":"超出单卡号累计交易次数限制",
                    "1007":"超出银行授信额度",
                    "1008":"超过用户在银行设置的限额",
                    "1009":"持卡人身份证验证失败",
                    "1010":"累计交易支付金额超出单笔限额",
                    "1011":"累计交易支付金额超出当日限额",
                    "1012":"累计交易支付金额超出当月限额",
                    "1013":"非法用户号",
                    "1014":"该卡暂不支持支付,请更换银行卡",
                    "1015":"该卡暂不支持支付，请稍后再试",
                    "1016":"交易超时",
                    "1017":"交易金额不能大于最大限额",
                    "1018":"交易金额不能低于最小限额",
                    "1019":"交易金额超过渠道当月限额",
                    "1020":"交易金额为空",
                    "1021":"交易金额有误错误",
                    "1022":"交易失败，风险受限",
                    "1023":"交易失败，详情请咨询您的发卡行",
                    "1024":"金额格式有误",
                    "1025":"仅支持个人银行卡支付",
                    "1026":"您的银行卡不支持该业务，请与发卡行联系",
                    "1027":"请核对个人身份证信息",
                    "1028":"请核对您的订单号",
                    "1029":"请核对您的个人信息",
                    "1030":"请核对您的银行卡信息",
                    "1031":"请核对您的银行信息",
                    "1032":"请核对您的银行预留手机号",
                    "1033":"未开通无卡支付或交易超过限额",
                    "1034":"信息错误，请核对",
                    "1035":"银行户名不能为空",
                    "1036":"银行卡未开通银联在线支付",
                    "1037":"银行名称无效",
                    "1038":"银行系统繁忙,请稍后再试",
                    "1039":"银行账号不能为空",
                    "1040":"余额不足",
                    "1041":"证件号错误,请核实",
                    "1042":"证件号码不能为空",
                    "1043":"证件类型与卡号不符",
                    "1045":"银行账户余额不足",
                    "1044":"银行账户余额不足"]
        errorMsg = dict[rechargeModel.errorCode]!
        
        self.failedBtn.setTitle("重新充值", for: UIControlState())
        self.failedTitleLabel.text = "充值失败"
        
        let errorAlert: String = "失败原因"
        if rechargeModel.errorCode != ""
        {
           failedMsgLabel.text = errorAlert + "\((rechargeModel.errorCode)):" + errorMsg
        }
        else
        {
            failedMsgLabel.text = errorMsg + "系统错误"
        }
        
    }
    
    //MARK: - 绑卡失败model
    func setupBankModel(_ bankModel:MemberSetBankModel)
    {
        self.failedBtn.setTitle("重新绑定", for: UIControlState())
        self.failedTitleLabel.text = "绑卡失败"
        let errorMsg: String = "失败原因:"
        if bankModel.errorCode != nil
        {
            if bankModel.errorCode == "9999" {
                failedMsgLabel.text = errorMsg + "系统错误"
                
            } else if bankModel.errorCode == "1001" {
                failedMsgLabel.text = errorMsg + "真实姓名不能为空"
                
            } else if bankModel.errorCode == "1002" {
                failedMsgLabel.text = errorMsg + "身份证卡不能为空"
                
            } else if bankModel.errorCode == "1003" {
                failedMsgLabel.text = errorMsg + "银行卡号不能为空"

            } else if bankModel.errorCode == "1004" {
                failedMsgLabel.text = errorMsg + "手机号码不能为空"
        
            } else if bankModel.errorCode == "1005" {
                failedMsgLabel.text = errorMsg + "短信验证码不能为空"
               
            } else if bankModel.errorCode == "1006" {
                failedMsgLabel.text = errorMsg + "短信验证码错误"
                
            } else if bankModel.errorCode == "1007" {
                failedMsgLabel.text = errorMsg + "银行卡类型不符"
               
            } else if bankModel.errorCode == "1008" {
                failedMsgLabel.text = errorMsg + "此卡未开通银联在线支付功能"
                
            } else if bankModel.errorCode == "1009" {
                failedMsgLabel.text = errorMsg + "不支持此银行卡的验证"
                
            } else if bankModel.errorCode == "1010" {
                failedMsgLabel.text = errorMsg + "免费次数已用完，请联系客服人工验证"
                
            } else if bankModel.errorCode == "1011" {
                failedMsgLabel.text = errorMsg + "认证失败"
                
            } else if bankModel.errorCode == "1012" {
                failedMsgLabel.text = errorMsg + "该身份证已存在"
                
            } else if bankModel.errorCode == "1013" {
                failedMsgLabel.text = errorMsg + "渠道不能为空"
                
            } else if bankModel.errorCode == "1014" {
                failedMsgLabel.text = errorMsg + "请核对个人信息"

            } else if bankModel.errorCode == "1015" {
                failedMsgLabel.text = errorMsg + "请核对银行卡信息"
                
            } else if bankModel.errorCode == "1016" {
                failedMsgLabel.text = errorMsg + "该银行卡bin不支持"
               
            } else if bankModel.errorCode == "1017" {
                failedMsgLabel.text = errorMsg + "认证失败，系统异常请稍后再试"
                
            } else {
                failedMsgLabel.text = errorMsg + "系统错误"
   
            }

        }
    }
    
    //MARK: - 初始化view
    func setupView()
    {
        failedBtn.layer.cornerRadius = 5.0
        failedBtn.layer.masksToBounds = true
    }
    
    //MARK: - 失败按钮点击
    @IBAction func failedBtnClick(_ sender: UIButton) {
        
        if let block = rechrgeBackBlock
        {
            block(self.rechargeAmount)
        }
        
        self.navigationController?.popViewController(animated: true)
        
//        if self.rechargeModel != nil
//        {
//            for vc in (self.navigationController?.viewControllers)! {
//                print("打印出\(vc)==\(self.navigationController?.viewControllers[1])")
//                print("输出的class == \(type(of: vc.self)))==\(vc.self)")
//                if "\(type(of: vc.self))" == "JSRechargeViewController"
//                {
//                    vc.rechargeAmount = self.rechargeAmount
//                    self.navigationController?.popToViewController(vc, animated: true)
//                }
//            }
//        }
//        else
//        {
//            self.navigationController?.popViewController(animated: true)
//        }
        
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSAuthenticationFailedViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    

}
