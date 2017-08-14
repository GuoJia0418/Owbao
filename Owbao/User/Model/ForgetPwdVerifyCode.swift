//
//  ForgetPwdVerifyCode.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ForgetPwdVerifyCode: NSObject {
    var success: Int = 0
    var errorCode: String? = ""
    var msg: String?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "errorCode" {
            if value as? String == "1002" {
                msg = "当天短信发送次数超过限制,请联系客服"
            } else if value as? String == "1003" {
                msg = "短信发送失败"
            }else
            {
                msg = "发送失败"
            }
        }
        if key == "success" {
            if value as? Int == 1 {
                msg = "发送成功"
            } else {
                msg = "发送失败"
            }
        }

        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    static func forgetPwdVerifyCode(_ uid: Int, success: @escaping ((_ result: ForgetPwdVerifyCode) -> ()), failure: @escaping (_ error: NSError) -> ()) {
        ForgetPwdVerifyCodeApi(uid: uid,type: "1").startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            guard let resultDict = request.responseJSONObject as? [String: AnyObject] else {
                return
            }
            let forgetPwdVerifyCode = ForgetPwdVerifyCode(dict: resultDict)
            dump(forgetPwdVerifyCode)
            success(forgetPwdVerifyCode)
            }) { (request: YTKBaseRequest!) -> Void in
                failure(NSError(domain: "", code: 1, userInfo: nil)
            )}
    }

}
