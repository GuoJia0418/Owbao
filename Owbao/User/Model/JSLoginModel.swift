//
//  JSLoginModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/3.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLoginModel: NSObject {
    var msg: String? = ""
    var success: Int = 0
    var map:JSLoginMapModel?
    var errorCode: String? {
        didSet {
            let promptDict = ["1003": "账号或密码错误","success": "登录成功","error": "系统错误","9999":"系统错误","1004":"要输入图形验证码","1002":"图形验证码错误"]
            msg = promptDict[errorCode!];
        }
    }
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
        
    }

    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "map" {
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

    static func login(_ phoneNo: String, password: String, PicCode: String, success: @escaping ((_ result: JSLoginModel) -> ()), failure: (_ error: NSError) -> ()) {
        LoginApi(mobilephone: phoneNo, passWord: password, PicCode: PicCode).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("手机登录\(resultDict)")
            let loginResult = JSLoginModel(dict: resultDict!)
//            print(loginResult.member?.token)
            success(loginResult)
        }) { (request: YTKBaseRequest!) -> Void in
            print(request.responseStatusCode)
        }
    }

    
}
