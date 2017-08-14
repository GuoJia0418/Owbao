//
//  JSLoginMapModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/3.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLoginMapModel: NSObject {
    var loginErrorNums:Int = 0     //登录的错误次数
    var isOldUser: Int = 0         //是否是老用户
    var member: Member?            //member
    var token:String?              //token
    
    init(dict: [String: AnyObject]) {
        print(dict)
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
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
