//
//  UrgentNoticeAPI.swift
//  Owbao
//
//  Created by Panda on 16/4/27.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class UrgentNoticeAPI: BaseApi {

    var limit: String?
    var proId: String?
    
    init(Limit: String?,ProId: String?) {
        super.init()
        self.limit = Limit
        self.proId = ProId
    }
    override func requestUrl() -> String! {
        return UrgentNotice_Api
    }
    override func untreatedArgument() -> Any! {
        
        if proId == "1" {
            
            return ["limit":limit!]
        }
        else
        {
            return ["limit":limit! ,"proId":proId!]
        }
    }
}
