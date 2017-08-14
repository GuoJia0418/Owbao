//
//  UserModel.swift
//  Owbao
//
//  Created by Panda on 16/4/20.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    static let shareInstance = UserModel()

    //真实姓名
    var realName: String? = "" {
        didSet{
            UserDefaults.standard.setValue(realName, forKey: "realName")
        }
    }
    //实名认证
    var realVerify:Int? = 0{
        didSet{
            UserDefaults.standard.setValue(realVerify, forKey: "realVerify")
        }
    }
    //性别
    var sex:Int? = 0 {
        didSet{
            UserDefaults.standard.setValue(sex, forKey: "sex")
        }
    }
    
    //未读信息
    var unReadMsg:Int? = 0{
        didSet{
            UserDefaults.standard.setValue(unReadMsg, forKey: "unReadMsg")
        }
    }
    
    //代收收益
    var winterest:Double?   = 0{
        didSet{
            UserDefaults.standard.setValue(winterest, forKey: "winterest")
        }
    }
    //待收本金
    var wprincipal:Double?  = 0.00{
        didSet {
            UserDefaults.standard.setValue(wprincipal, forKey: "wprincipal")
        }
    }
    //是否设置交易密码
    var tpwdFlag:Int?       = 0 {
        didSet {
            UserDefaults.standard.setValue(tpwdFlag, forKey: "tpwdFlag")
        }
    }
    //手机号码
    var mobilephone:String? = "" {
        didSet {
            UserDefaults.standard.setValue(mobilephone, forKey: "mobilephone")
        }
    }
    //银行ID
    var bankId:Int?         = 0 {
        didSet {
            UserDefaults.standard.setValue(bankId, forKey: "bankId")
        }
    }
    //银行名称
    var bankName:String?    = "" {
        didSet {
            UserDefaults.standard.setValue(bankName, forKey: "bankName")
        }
    }
    //银行卡号
    var idCards:String?     = "" {
        didSet {
            UserDefaults.standard.setValue(idCards, forKey: "idCards")
        }
    }
    //token
    var token:String?       = "" {
        didSet {
            UserDefaults.standard.setValue(token, forKey: "token")
        }
    }
    //是否登录
    var isLogin:Int?   = 0 {
        didSet {
            UserDefaults.standard.setValue(isLogin, forKey: "isLogin")
        }
    }
    //用户id
    var uid:Int?            = 0 {
        didSet {
           UserDefaults.standard.setValue(uid, forKey: "uid")
        }
    }
    //邀请码
    var recommCodes:String? = "" {
        didSet {
           UserDefaults.standard.setValue(recommCodes, forKey: "recommCodes")
        }
    }
    //手势密码
    var gestureUnlock:Int? = 0 {
        didSet {
           UserDefaults.standard.setValue(gestureUnlock, forKey: "gestureUnlock")
        }
    }
    
    //是否设置过
    var isSetGestureUnlock:Int? = 0 {
        didSet {
            UserDefaults.standard.setValue(isSetGestureUnlock, forKey: "isSetGestureUnlock")
        }
    }
    
    //是否提示过
    var isPromptGesturePassword:Int? = 0 {
        didSet {
            UserDefaults.standard.setValue(isPromptGesturePassword, forKey: "isPromptGesturePassword")
        }
    }
    
    //是否显示弹窗
    var isShowOpenWindow:Int? = 0{
    
        didSet {
            UserDefaults.standard.setValue(isShowOpenWindow, forKey: "isShowOpenWindow")
        }
    }

    //调用服务器给定接口的时间(/login/lastLogin.do)
    var invokeFunctionTime: NSDate? = NSDate() {
        
        didSet{
            UserDefaults.standard.setValue(invokeFunctionTime, forKey: "invokeFunctionTime")
        }
    }

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        UserDefaults.standard.setValue(value, forKey: key)
    }


    override init() {
        super.init()
        if UserDefaults.standard.value(forKey: "realName") != nil {
            realName =  UserDefaults.standard.value(forKey: "realName") as? String
        }
        
        realVerify  = UserDefaults.standard.value(forKey: "realVerify") as? Int   ?? 0
        unReadMsg   = UserDefaults.standard.value(forKey: "unReadMsg") as? Int ?? 0
        sex         = UserDefaults.standard.value(forKey: "sex") as? Int ?? 0
        winterest   = UserDefaults.standard.value(forKey: "winterest") as? Double ?? 0
        wprincipal  = UserDefaults.standard.value(forKey: "wprincipal") as? Double ?? 0
        tpwdFlag    = UserDefaults.standard.value(forKey: "tpwdFlag") as? Int ?? 0
        mobilephone = UserDefaults.standard.value(forKey: "mobilephone") as? String ?? ""
        bankId      = UserDefaults.standard.value(forKey: "bankId") as? Int ?? 0
        bankName    = UserDefaults.standard.value(forKey: "bankName") as? String ?? ""
        idCards     = UserDefaults.standard.value(forKey: "idCards") as? String ?? ""
        token       = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        isLogin     = UserDefaults.standard.value(forKey: "isLogin") as? Int ?? 0
        uid         = UserDefaults.standard.value(forKey: "uid") as? Int ?? 0
        recommCodes = UserDefaults.standard.value(forKey: "recommCodes") as? String ?? ""
        gestureUnlock = UserDefaults.standard.value(forKey: "gestureUnlock") as? Int ?? 0
        isSetGestureUnlock = UserDefaults.standard.value(forKey: "isSetGestureUnlock") as? Int ?? 0
        isPromptGesturePassword = UserDefaults.standard.value(forKey: "isPromptGesturePassword") as? Int ?? 0
        isShowOpenWindow = UserDefaults.standard.value(forKey: "isShowOpenWindow") as? Int ?? 0
        
        //保存调用接口的时间
        invokeFunctionTime = UserDefaults.standard.value(forKey: "invokeFunctionTime") as? NSDate
    }
    
    func logout() {
        
        self.uid = 0
        self.isLogin = 0
        self.isPromptGesturePassword = 0
        self.isSetGestureUnlock = 0
        self.isShowOpenWindow = 0
        
        UserDefaults.standard.removeObject(forKey: "uid")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLogin")
        
//        Defaults.setValue(0, forKey: "isLogin")
//        Defaults.setValue(0, forKey: "uid")
    }
 
}
