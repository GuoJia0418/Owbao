//
//  Withdrawals.swift
//  Owbao
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class WithdrawalsApi: BaseApi {
    var uid: Int = 0
    init(Uid: Int) {
        super.init()
        self.uid = Uid
    }
    override func requestUrl() -> String! {
        return Withdrawals_Api
    }
    override func untreatedArgument() -> Any! {
        return ["uid": uid]
    }
}
