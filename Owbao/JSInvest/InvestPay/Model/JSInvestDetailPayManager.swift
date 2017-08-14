//
//  JSInvestDetailPayManager.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/3.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  投资单例

import UIKit

class JSInvestDetailPayManager: NSObject {
    
    var investPayCallback: ((_ model: InvestModel?,_ isConnect: Bool) -> Void)? //支付回调 model：支付结果，isConnect；连接是否陈宫
    
    //开始支付
    func beginPayAction(_ payModel: JSPayModel) ->  Void {
        
        ProductInvestApi(Pid: payModel.JSProductNameID, Tpwd: payModel.JSPassWord, Amount: payModel.JSInputAmount, Uid: UserModel.shareInstance.uid!, Fid: payModel.JSFid).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
        
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("确认投资 -- 投资的结果 \(resultDict)")
            let model: InvestModel = InvestModel(dict: resultDict!)
            
            if self.investPayCallback != nil {
                self.investPayCallback!(model,true)
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            if self.investPayCallback != nil {
                self.investPayCallback!(nil,false)
            }
        }
    }
}

class JSPayModel: NSObject {
    var JSPassWord: String = ""       //密码
    var JSInputAmount: Double = 0.0   //用户投资金额
    var JSProductNameID: Int = 0     //产品ID
    var JSFid: Int = 0
    
    init(passWord: String,inputAmount: Double,productNameID: Int,fid: Int) {
        JSPassWord = passWord
        JSInputAmount = inputAmount
        JSProductNameID = productNameID
        JSFid = fid
    }
    
    //新手标没有红包的，fid要为0;没选红包，fid也要为0
    class func getFid(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            
            if detailModel?.map?.selectCouponModel != nil && detailModel?.map?.controllerType != .novice {
                
                return (detailModel?.map?.selectCouponModel?.id)!
            }
        }
        
        return 0
    }
}
