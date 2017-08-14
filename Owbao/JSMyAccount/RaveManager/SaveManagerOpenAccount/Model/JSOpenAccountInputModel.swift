//
//  JSOpenAccountInputModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

//输入数据
class JSOpenAccountInputModel: NSObject {
    
    var phoneNumber: String = ""  //手机号码
    var realName: String = ""     //真是姓名
    var certif_id: String = ""    //身份证号码
    
    //***********银行输入数据******************//
    var bankCode: String = ""         //开户行代码
    var cardNumber: String = ""       //银行卡号
    var OpenBankAddressCode: String = ""  //开户行所在地代码
    
    //***********输入密码******************//
    var password: String = ""         //密码
    var confirmPassword: String = ""  //确认密码
    
    //真实姓名、身份证号是否需要校验，如果服务器获取到则不需要校验
    var realNameNeedVerification: Bool = true
    var certif_idNeedVerification: Bool = true
    
//    func checkInputInformation() -> (Bool,String) {
    
//        if self.realName.verifyUserName() == false {
//            return (false,"请输入正确的姓名")
//        } else if self.certif_id.verifyId() == false {
//            return (false,"请输入正确的身份证号")
//        } else if self.cardNumber.characters.count == 0 {
//            return (false,"银行卡号不能为空")
//        } else if self.cardNumber.characters.count > 0 &&  self.cardNumber.characters.count < 8 {
//            return (false,"银行卡位数不正确")
//        } else if self.cardNumber.CheckBankCard() == false {
//            return (false,"银行卡号不正确")
//        } else if self.phoneNumber.isPhoneNo() == false {
//            return (false,"请输入正确的手机号")
//        } else if self.bankCode == "" {
//            return (false,"请选择开户行")
//        } else if self.OpenBankAddressCode == "" {
//            return (false,"请选择开户行所在地")
//        } else if self.infoModel.password == "" {
//            self.view.showTextHud("请输入支付密码")
//            return
//        } else if self.infoModel.password == "" {
//            self.view.showTextHud("请输入确认支付密码")
//            return
//        } else if self.infoModel.password.characters.count < 8 || self.infoModel.password.characters.count > 16 {
//            self.view.showTextHud("支付密码位数不正确")
//            return
//        } else if self.infoModel.confirmPassword.characters.count < 8 || self.infoModel.confirmPassword.characters.count > 16 {
//            self.view.showTextHud("确认支付密码位数不正确")
//            return
//        } else if self.infoModel.password != self.infoModel.confirmPassword {
//            self.view.showTextHud("两次输入的密码不相同")
//            return
//        } else if self.infoModel.password.checkPasswordSecond() == false {
//            self.view.showTextHud("支付密码格式不正确")
//            return
//        } else if self.infoModel.confirmPassword.checkPasswordSecond() == false {
//            self.view.showTextHud("确认支付密码格式不正确")
//            return
//        }
        
//    }
    
}
