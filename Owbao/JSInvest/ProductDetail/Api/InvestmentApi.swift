//
//  InvestmentApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestmentApi: BaseApi {
    
    var pageOn: Int = 1
    var pageSize: Int = 6  //默认是6
    var uid: Int = 0
    var type: Int = 0      //0=全部,1=活动标，2=优选理财,3=聚划算
    var status: Int = 0    //5 = 募集中
    
    init(PageOn: Int,
         Uid: Int,
         Type: Int,
         Status: Int,
         PageSize: Int) {
        super.init()
        
        pageOn = PageOn
        uid = Uid
        type = Type
        status = Status
        pageSize = PageSize
        
    }
    
    override func requestUrl() -> String! {
        return Investment_Api
    }
    
    override func untreatedArgument() -> Any! {
        
        if uid == 0 {
            
            
//            var _dict = [AnyHashable:Any]()
            
//            .updateValue(pageOn, forKey: "pageOn")
            
            
            if status ==  0 {
                
                if type == 0 {
                    return ["pageOn": pageOn,"pageSize": pageSize]
                } else {
                    return ["pageOn": pageOn,"pageSize": pageSize,"type": type]
                }
                
            } else {
                
                if type == 0 {
                    return ["pageOn": pageOn,"pageSize": pageSize,"status": status]
                } else {
                    return ["pageOn": pageOn,"pageSize": pageSize,"type": type,"status": status]
                }
            }
            
        } else {
            
            if status ==  0 {
                if type == 0 {
                    return ["pageOn": pageOn,"pageSize": pageSize,"uid": uid]
                } else {
                    return ["pageOn": pageOn,"pageSize": pageSize,"uid": uid,"type": type]
                }
            } else {
                if type == 0 {
                    return ["pageOn": pageOn,"pageSize": pageSize,"uid": uid,"status": status]
                } else {
                    return ["pageOn": pageOn,"pageSize": pageSize,"uid": uid,"type": type,"status": status]
                }
            }
            
        }
    }
}
