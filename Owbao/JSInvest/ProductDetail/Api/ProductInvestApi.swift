//
//  ProductInvestApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/17.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductInvestApi: BaseApi {
    var pid: Int = 0
    var tpwd:String?
    var amount:Double = 0.00
    var uid :Int = 0
    var fid :Int = 0
    init(Pid:Int,Tpwd:String,Amount:Double,Uid:Int,Fid:Int)
    {
        super.init()
        pid = Pid
        tpwd = Tpwd
        amount = Amount
        uid = Uid
        fid = Fid
    }
    
    override func requestUrl() -> String! {
        return ProductInvest_Api
    }
    
    override func requestTimeoutInterval() -> TimeInterval {
        return 10
    }
    
    override func untreatedArgument() -> Any! {
        if fid == 0 {
            return ["pid": pid,"tpwd":tpwd!,"amount":amount,"uid":uid]
        }else{
            return ["pid": pid,"tpwd":tpwd!,"amount":amount,"uid":uid,"fid":fid]
        }
    }
}
