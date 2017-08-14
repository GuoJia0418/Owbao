//
//  Register.swift
//  Owbao
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class Register: NSObject {
    
    var success: Int = 0
    var errorCode: String? = ""
    var msg: String?
    var member: Member?
    var isCps: Int  = 0               //0=不是cps ，1=是cps
    var regSendLabel: String = ""    //10000体验金666红包之类的
    var pid: Int = 0                 //新手标id
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "member" {
            // 判断 value 是否是一个有效的字典
            let valueStr = value ?? ""
            if let dict = valueStr as? [String: AnyObject] {
                // 创建用户数据
                member = Member(dict: dict)
//                member?.saveMember()
            }
            return
        }
        
        if key == "map" {
            
            let valueDict = value as? [String: AnyObject]
            let mem = valueDict!["member"] as? [String: AnyObject]
            
            if mem != nil {
                member = Member(dict: mem!)
            }
            
            if let abc = valueDict! ["token"] as? String {
                member?.token = abc
            }
            
            if let abc = valueDict! ["regSendLabel"] as? String {
                regSendLabel = abc
            }
            
            if let abc = valueDict! ["isCps"] as? Int {
                isCps = abc
            }
            
            if let abc = valueDict! ["pid"] as? Int {
                pid = abc
            }
            
            return
        }
        
        if key == "success" {
            if value as? Int == 1 {
                msg = "发送成功"
            } else {
                msg = "注册失败"
            }
        }
        
//        if key == "errorCode" {
//            let valueStr = value ?? ""
//            let dict = ["1001":"短信验证码为空","1002": "短信验证码错误","1003":"手机号为空","1005": "密码格式错误","1006":"未勾选注册协议","1007":"手机号已注册","1008":"推荐人不存在"]
//            errorCode = dict[valueStr as! String]
//            msg = dict[value as! String]
//        }

        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    static func register(_ phoneNo: String,
                         passWord: String,
                         smsCode: String,
                         recommPhone: String,
                         success:  @escaping ((_ result: Register) -> ()),
                         failure: @escaping (_ error: NSError) -> ()) {
        
        RegisterApi(mobilephone: phoneNo,
            passWord: passWord,
            smsCode: smsCode,
            recommPhone: recommPhone,
            toFrom: REG_FROM).startWithCompletionBlock(success: { (request: YTKBaseRequest!) ->
                Void in
                
            print(request.responseString)
                
            guard let resultDict = request.responseJSONObject as? [String: AnyObject] else {
                return
            }
                
            print("注册返回的\(resultDict)")
            let register = Register(dict: resultDict)
                
             success(register)
                
            }) { (request: YTKBaseRequest!) -> Void in
                failure(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
}
