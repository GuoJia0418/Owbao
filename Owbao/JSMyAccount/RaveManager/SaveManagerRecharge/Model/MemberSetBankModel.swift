//
//  MemberSetBankModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class MemberSetBankModel: NSObject {
    var errorCode:String?
    var success:Bool = false
    var map:MemberSetBankMapModel?
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = MemberSetBankMapModel(dict: dict)
            }
            return
        }
//        if key == "errorCode" {
//            let dict = ["9999": "系统错误", "1001": "真实姓名不能为空","1002":"身份证卡不能为空", "1003": "银行卡号不能为空","1004":"手机号码不能为空","1005":"短信验证码不能为空","1006":"短信验证码错误","1007":"银行卡类型不符","1008":"此卡未开通银联在线支付功能","1009":"不支持此银行卡的验证","1010":"免费次数已用完，请联系客服人工验证","1011":"验证失败","1012":"该身份证已存在","1013":"渠道不能为空","1014":"请核对个人信息","1015":"请核对银行卡信息","1016":"该银行卡bin不支持","1017":"认证失败，系统异常请稍后再试"]
//            errorCode = dict[value as! String]
//            return
//        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
