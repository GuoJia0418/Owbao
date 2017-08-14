//
//  UpdateLoginPassword.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UpdateLoginPassword: NSObject {
    var success: Int = 0
    var errorCode: String?
    var msg: String?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    //{"map":{"exists":false},"success":true}
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "success" {
            if value as? Int == 1 {
                msg = "发送成功"
            } else {
                msg = "发送失败"
            }
        }
        
        if key == "errorCode" {
            let dict = ["1002": "短信验证码错误", "1005": "密码格式错误"]
            
            msg = dict[value as! String]
        }
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    static func updateLoginPassword(_ uid: Int, passWord: String,smsCode: String,mobilephone:String, success: @escaping ((_ result: UpdateLoginPassword) -> ()), failure: @escaping (_ error: NSError) -> ()) {
        UpdateLoginPasswordApi(uid: uid, pwd: passWord, smsCode: smsCode, Mobilephone: mobilephone).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            print(request.responseString)
            guard let resultDict = request.responseJSONObject as? [String: AnyObject] else {
                return
            }
            let update = UpdateLoginPassword(dict: resultDict)
            success(update)
            }) { (request: YTKBaseRequest!) -> Void in
                failure(NSError(domain: "", code: 1, userInfo: nil))
        }
    }

}
