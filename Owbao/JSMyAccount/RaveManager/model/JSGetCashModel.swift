//
//  JSGetCashModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSGetCashModel: JSBaseModel {
    var map: JSGetCashMapModel?

    
    //获取提交到存管web界面的form类型string
    func getFormString() -> String {
    
        let dictionary = self.map?.message
        
        if self.map?.signature != nil && dictionary != nil {
            dictionary?["signature"] = (self.map?.signature
                )!
        }
        
        if self.map?.fuiouUrl != nil && dictionary != nil {
            return self.makePostData500001((self.map?.fuiouUrl)!, dataMap: dictionary!)
        }
        
        return ""
    }
    
    fileprivate func makePostData500001(_ apiURL: String,dataMap: NSDictionary) -> String {
        
        var formIn = ""
        for (key,value) in dataMap {
            formIn += "<input type='hidden' name='\(key)' value='\(value)'/>"
        }
        
        let ret = "<!DOCTYPE HTML><html><body><form id='sbform' action='\(apiURL)' method='post'>\(formIn)</form><script type='text/javascript'>document.getElementById('sbform').submit();</script></body></html>"
        
        NSLog(ret)
        
        return ret
    }
}

class JSGetCashMapModel: NSObject {
    var fuiouUrl: String = ""
    var message =  NSMutableDictionary()
    var signature = ""
}



