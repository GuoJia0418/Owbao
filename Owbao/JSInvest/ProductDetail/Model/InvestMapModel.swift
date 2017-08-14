//
//  InvestMapModel.swift
//  Owbao
//
//  Created by Panda on 16/6/30.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class InvestMapModel: NSObject {
    var activityURL: String = ""     //url
    var isActivity: Bool = false     //是否显示图片
    var luckCodes: String?           //本次投资幸运码列表
    var luckCodeCount: Int = 0      //总共有多少个幸运码
    
    var isRepeats: Bool = false     //同类期限产品的复投 true 复投
    var jumpURL: String = ""        //点击活动图片跳转链接
    
    //双旦活动
    var isDoubleEgg:Bool = false    //是否有机会拆双蛋机会:true :有
    var activityUrl:String = ""     //活动url
    
    var expireDate: Double = 0.0    //到期时间
    var investId: Int = 0           //投资id
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
