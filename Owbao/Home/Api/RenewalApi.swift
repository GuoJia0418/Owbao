//
//  RenewalApi.swift
//  Owbao
//
//  Created by Panda on 16/6/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RenewalApi: BaseApi {

    override func requestUrl() -> String! {
        return Renewal_Api
    }
    
    override func requestTimeoutInterval() -> TimeInterval {
        return 5
    }
}
