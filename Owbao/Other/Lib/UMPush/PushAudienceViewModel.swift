//
//  PushAudienceViewModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class PushAudienceViewModel: JSBaseViewModel {
    
    func loadPushAudicenceData(_ registrationId: String,appType: Int) -> () {
        
        self.requestServer(PushAudienceApi(Uid: UserModel.shareInstance.uid ?? 0, RegistrationId: registrationId, AppType: appType), modelName: "PushModel", callback: { (JSBaseModel) in
            
        }) { (String) in
            
        }
    }
}
    
class PushModel: JSBaseModel {
    
    var map: PushMapModel?
}

class PushMapModel: NSObject {
    
    var code: Int = 0 //类型0tag,1alias,3 registetrant_id
    var type: Int = 0
}
