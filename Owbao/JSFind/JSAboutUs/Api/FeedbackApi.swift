//
//  FeedbackApi.swift
//  Owbao
//
//  Created by lufeng on 16/3/22.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class FeedbackApi: BaseApi {
    var uid: Int = 0
    var content:String?
    init(Uid:Int,Content:String?)
    {
        super.init()
        uid = Uid
        content = Content
    }
    
    override func requestUrl() -> String! {
        return Feedback_Api
    }
    
    override func untreatedArgument() -> Any! {
        if uid == 0 {
            return ["content":content!]
        }
        return ["uid": uid,"content":content!]
    }
}

//修改
