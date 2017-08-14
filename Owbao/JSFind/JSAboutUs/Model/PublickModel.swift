//
//  PublickModel.swift
//  Owbao
//
//  Created by GuoJia on 16/11/28.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class PublickModel: JSBaseModel {
    var map: PublickMapModel?
}

class PublickMapModel: NSObject {
    var page: PublickPageModel?
}

class PublickPageModel: NSObject {
    var total: Int = 0
    var totalPage: Int = 0
    
    var rows = [PublickDetailModel]()
    
    class func modelContainerPropertyGenericClass() -> NSDictionary {
        return NSDictionary(dictionary: ["rows": PublickDetailModel.classForCoder()])
    }
}

class PublickDetailModel: NSObject {
    var artiId: Int = 0         //文章标识号
    var title: String = ""      //标题
    var createTime: Double = 0  //创建时间，返回时间戳
    var litpic: String = ""     //缩略图
    var proId: Int = 0         //栏目
}
