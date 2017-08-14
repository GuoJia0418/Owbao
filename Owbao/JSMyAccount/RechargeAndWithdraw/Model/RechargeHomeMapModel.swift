//
//  RechargeHomeMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RechargeHomeMapModel: NSObject {
    var funds:Double = 0.00
    var fuiou_balance: Double = 0.00  //存管账户余额
    var isFuiou: Int = 0              //是否开通存管
    var bankNumFuiou: String = ""     //银行尾号
    var bankNameFuiou: String = ""    //存管银行名称
    var mobilePhone:String = ""       //手机号
    var bankName: String = ""
    var bankNum:String = ""
    var bankCode:Int = 0
    var bankCodeFuiou: Int = 0 
    var dayQuota:Double = 0.00 
    var singleQuota:Double = 0.00
    var sysArticleList = [RechargeHomeSysArticleListModel]()
    
    var bankNoFuiou:String = ""    //存管银行卡号
    var realName:String = ""       //姓名
    var idCards:String = ""        //身份证号
    var bankMobilePhoneFuiou: String = ""   //银行预留手机号
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String)
    {
        
        if key == "sysArticleList"
        {
            if let arr = value as? [[String: AnyObject]]
            {
                for dict in arr
                {
                    let article = RechargeHomeSysArticleListModel(dict: dict)
                    sysArticleList.append(article)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
