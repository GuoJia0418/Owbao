//
//  Login.swift
//  Owbao
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class Login: NSObject {
    var errorCode: String? {
        didSet {
            let promptDict = ["1003": "账号或密码错误","success": "登录成功","error": "系统错误","9999":"系统错误"]
            msg = promptDict[errorCode!];
        }
    }
    var msg: String? = ""
    var success: Int = 0
    var member: Member?
    
    var map:JSLoginMapModel?
    // MARK: - 构造函数
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
        
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        // 判断 key 是否是 member，如果是 member 单独处理
        if key == "member" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                member = Member(dict: dict)
//                member?.saveMember()
            }
            return
        }
        if key == "map" {
            let valueDict = value as? [String: AnyObject]
            if let mem = valueDict!["member"] as? [String: AnyObject] {
                member = Member(dict: mem)
            }
            if let abc = valueDict!["token"] as? String {
                member?.token = abc
            }
            
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = JSLoginMapModel(dict: dict)
            }
            
            return
        }
            
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
    static func login(_ phoneNo: String, password: String,PicCode:String,success: @escaping ((_ result: Login) -> ()), failure: (_ error: NSError) -> ()) {
        LoginApi(mobilephone: phoneNo, passWord: password,PicCode: PicCode).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
    
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("手机登录\(resultDict)")
            let loginResult = Login(dict: resultDict!)
            print(loginResult.member?.token)
            success(loginResult)
            }) { (request: YTKBaseRequest!) -> Void in
                print(request.responseStatusCode)
        }
    }
}
