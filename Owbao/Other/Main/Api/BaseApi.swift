//
//  BaseApi.swift
//  Owbao
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BaseApi: YTKRequest {
    
    override func requestTimeoutInterval() -> TimeInterval {
        return 30
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .post
    }
    
    func untreatedArgument() ->Any! {
        return [:]
    }
    
    override func requestArgument() -> Any! {
        // 1.获取程序当前的版本
        var argumentDict: [String: AnyObject]  = untreatedArgument() as! [String : AnyObject]
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        //swift 3.0
        if (argumentDict["pid"] as AnyObject) as? NSObject == nil
        {
            argumentDict.removeValue(forKey: "pid")
        }
        
        if (argumentDict["uid"] as AnyObject) as? NSObject == nil
        {
            let dict: [String: AnyObject] = ["version": currentVersion as AnyObject, "channel":"1" as AnyObject]
            return dict.combinedWith(argumentDict)
        }
        else
        {
            let dict: [String: AnyObject] = ["version": currentVersion as AnyObject, "channel":"1" as AnyObject,"token":UserModel.shareInstance.token! as AnyObject]
            return dict.combinedWith(argumentDict)
        }
    }
}

extension Dictionary {
    
    func combinedWith(_ other: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var newDict = other
        for (key, value) in self {
            newDict[key] = value
        }
        
        return newDict
    }
}
