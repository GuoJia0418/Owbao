//
//  JSProductActivityBannerModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/17.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProductActivityBannerModel: JSBaseModel {

    var map: JSProductActivityBannerMapModel?
}

class JSProductActivityBannerMapModel: JSBaseModel {
    
    var sysBanners = [JSProductActivityBannerRowModel]() //广告对象
    
    class func modelContainerPropertyGenericClass() -> NSDictionary {
        return NSDictionary(dictionary: ["sysBanners": JSProductActivityBannerRowModel.classForCoder()])
    }
}

class JSProductActivityBannerRowModel: JSBaseModel {
    var imgUrl: String = ""   //图片
    var title: String = ""    //标题
    var location: String = "" //点击地址
    var id: Int = 0           //商品id
    var code: Int = 0
}
