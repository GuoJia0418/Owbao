//
//  JSGiftDetailMapModel.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGiftDetailMapModel: NSObject {
    var name:String? = ""         //奖品名称
    var simpleName:String? = ""   //简称
    var price:Double = 0.00       //价格
    var amount:Double = 0.00      //投资金额
    
    var pcImgUrlV:String? = ""    //奖品图片-竖版
    var pcImgUrlH:String? = ""    //奖品图片-横版
    var h5ImgUrlV:String? = ""    //奖品图片-竖版
    var h5ImgUrlH:String? = ""    //奖品图片-横版
    
    var remark:String? = ""        //备注
    var collectName:String? = ""   //收货人名称
    var collectPhone:String? = ""   //收货人电话
    var collectaddress:String? = "" //收货人地址
    var prizeType:Int = 0          //0-实物奖品 1-虚拟奖品
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
