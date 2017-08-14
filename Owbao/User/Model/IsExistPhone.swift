//
//  IsExistPhone.swift
//  Owbao
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class IsExistPhone: NSObject {
    // MARK: - 构造函数
 
 
    /** 是否成功处理 **/
    var success: Bool = false
    /** 错误码 9999表示系统错误 **/
    var errorCode: String?
    var map:IsExistPhoneMapModel!
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    //{"map":{"exists":false},"success":true}
    override func setValue(_ value: Any?, forKey key: String) {
 

        if key == "map" {
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = IsExistPhoneMapModel(dict: dict)
                return
            }
        }
         
        super.setValue(value, forKey: key)
    }
    
   override func setValue(_ value: Any?, forUndefinedKey key: String) {}
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
//    static func isExistPhone(phoneNo: String, success: ((result: IsExistPhone) -> ()), failure: (error: NSError) -> ()) {
//        IsExistPhoneApi(phoneNo:phoneNo).startWithCompletionBlockWithSuccess({ (request: YTKBaseRequest!) -> Void in
//            print(request.responseString)
//            print(request.responseJSONObject)
//
//            guard let resultDict = request.responseJSONObject as? [String: AnyObject] else {
//                return
//            }
//            let isExistPhone = IsExistPhone(dict: resultDict)
//            success(result:  isExistPhone)
//            
//            }, failure: { (request: YTKBaseRequest!) -> Void in
//                failure(error: NSError(domain: "", code: 1, userInfo: nil))
//        })
//    }

}
