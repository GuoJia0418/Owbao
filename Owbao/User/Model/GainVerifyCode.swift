//
//  GainVerifyCode.swift
//  Owbao
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class GainVerifyCode: NSObject {
    var success: Int = 0
    var errorCode: String?
    var msg: String?
    var aa: Int = 0
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    //{"map":{"exists":false},"success":true}
    
    override func setValue( _ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
        // 判断 key 是否是 product，如果是 product 单独处理
        //        if key == "plan" {
        //            // 判断 value 是否是一个有效的字典
        //            if let dict = value as? [String: AnyObject] {
        //                // 创建用户数据
        //                plan = Product(dict: dict)
        //            }
        //            return
        //        }
        //        value = value ?? ""
        ////        print("key type====\()")
        //        if key == "errorCode" {
        //
        //
        //            if value as! String == "1002" {
        //                msg = "每个手机号当天只能发送5条"
        //            } else if value as! String == "1003" {
        //                msg = "短信发送失败"
        //            }
        //        }
        //        if key == "success" {
        //            if value as! Int == 1 {
        //                msg = "发送成功"
        //            } else {
        //                msg = "发送失败"
        //            }
        //        }
        //
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    static func gainVerifyCode(_ phoneNo: String,type:String,time:String,success: @escaping ((_ result: GainVerifyCode) -> ()), failure: @escaping (_ error: NSError) -> ()) {
        GainVerifyCodeApi(mobilephone: phoneNo,type: type,Time: time).startWithCompletionBlock(success: { (request: YTKBaseRequest?) -> Void in
            guard let resultDict = request?.responseJSONObject as? [String: AnyObject] else {
                return
            }
//            print("输出注册获取验证码结果==\(resultDict)")
            let gainVerifyCode = GainVerifyCode(dict: resultDict)
            
            success(gainVerifyCode)
        }) { (request:YTKBaseRequest?) -> Void in
            failure(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
    
}
