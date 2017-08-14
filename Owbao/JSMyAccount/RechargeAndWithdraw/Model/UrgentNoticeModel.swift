//
//  UrgentNoticeModel.swift
//  Owbao
//
//  Created by Panda on 16/4/27.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UrgentNoticeModel: NSObject {
    var arti_id:Int = 0
    var title:String? = ""
//    var source:String? = ""
    var summaryContents:String? = ""
//    var writer:String? = ""
//    var pro_id:String? = ""
//    var litpic:String? = ""
//    var create_time:String? = ""
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
