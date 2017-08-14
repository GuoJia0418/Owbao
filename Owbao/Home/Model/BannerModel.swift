//
//  BannerModel.swift
//  Owbao
//
//  Created by Panda on 16/5/18.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BannerModel: BaseModel {
    var id:Double = 0           //ID
    var imgUrl:String?          //图片url
    var title:String?           //标题
    var location:String?        //链接url
   
    required init(dic:AnyObject){
        super.init()
        let dict = dic as? [String: AnyObject]
        self.id       = dict!["id"] as! Double
        self.imgUrl   = dict!["imgUrl"] as? String
        self.title    = dict!["title"] as? String
        self.location = dict!["location"] as? String
    }
}
