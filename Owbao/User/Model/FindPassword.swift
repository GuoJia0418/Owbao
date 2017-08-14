//
//  FindPassword.swift
//  Owbao
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class FindPassword: NSObject {
    var success: Int = 0
    var errorCode: String? = ""
    var msg1: String?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    static func forgetPwdVerifyCode(_ uid: Int, Mobilephone: String,Type:String, success: @escaping ((_ result: FindPassword) -> ()), failure: @escaping (_ error: NSError) -> ())
    {
        FindPasswordApi(uid: uid, Mobilephone: Mobilephone,type:Type).startWithCompletionBlock(success: { (request: YTKBaseRequest?) -> Void in
            guard let resultDict = request?.responseJSONObject as? [String: AnyObject] else {
                return
            }
            print(request?.responseString)
            let forgetPwdVerifyCode = FindPassword(dict: resultDict)
            
            success(forgetPwdVerifyCode)
        }) { (request: YTKBaseRequest?) -> Void in
            failure(NSError(domain: "", code: 1, userInfo: nil)
            )}
    }
}
