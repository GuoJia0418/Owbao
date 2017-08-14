//
//  Member.swift
//  hyq2.0
//
//  Created by iOS on 15/9/2.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class Member: NSObject, NSCoding  {
    /** 用户id **/
    var uid: Int        = 0
    var realVerify: Int = 0
    var tpwdSetting     = 0
    var realName: String?
    var idCards: String?
    var mobilephone: String?
    var isLogin: Int = 0
    var token:String?
    var recommCodes:String?
    /** 默认 登录过的账户 暂时不用**/
    var isDefault: Int = 0
    static let shareInstance = Member()
    static fileprivate let filePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("memberInfo.data")
    
    override init() {
        super.init()
//        tableName = "Member"
//        createTableSql = "CREATE TABLE IF NOT EXISTS Member (sid integer primary key AutoIncrement,uid integer,mobilephone varchar(11),name varchar(20), isLogin integer,isDefault integer,token varchar(50),recommCodes varchar(10))"
    }
    // MREK: - kvc
    init(dict: [String: AnyObject])
    {
        super.init()
        // KVC
        setValuesForKeys(dict)
//        tableName = "Member"
//        createTableSql = "CREATE TABLE IF NOT EXISTS Member (sid integer primary key AutoIncrement,uid integer,mobilephone varchar(11),name varchar(20), isLogin integer,isDefault integer,token varchar(50),recommCodes varchar(10))"
    }
//    convenience override init() {
//        super.init()
//    }
    override func setValue(_ value: Any?, forKey key: String)
    {
        
        super.setValue(value, forKey: key)

    }
    
    override func setNilValueForKey(_ key: String) {
        

    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    // MRAK: - 归档那的操作
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
    }
    // MRAK: - 解档的操作
    required init?(coder aDecoder: NSCoder ) {
        uid = aDecoder.decodeObject(forKey: "uid") as! Int
    }
 
    class func memberInfo(_ uid: String, success: ((_ result: Member) -> ()), failure: (_ error: NSError) -> ()) {
//        MemberApi(uid: uid).startWithCompletionBlockWithSuccess({ (request: YTKBaseRequest!) -> Void in
//                HLog(request.responseJSONObject)
//            let member = Member(dict: request.responseJSONObject["member"] as! [String: AnyObject])
//                member.saveMember()
//                success(result: member)
//            }) { (request: YTKBaseRequest!) -> Void in
//                let error = NSError(domain: "", code: 111, userInfo: nil)
//                failure(error: error)
//        }
    }
//    static func loginResult(loginId: String, password: String, success: ((result: LoginResult) -> ()), failure: (error: NSError) -> ()) {
////        LoginApi(phoneNo: loginId, passwd: password).startWithCompletionBlockWithSuccess({ (request: YTKBaseRequest!) -> Void in
////            let resultDict = request.responseJSONObject as? [String: AnyObject]
////            let loginResult = LoginResult(dict: resultDict!)
////            success(result: loginResult)
////            }) { (request: YTKBaseRequest!) -> Void in
////                let error = NSError(domain: "", code: 111, userInfo: nil)
////                failure(error: error)
////        }
//    }
//    func saveMember() {
//        NSKeyedArchiver.archiveRootObject(self, toFile: Member.filePath)
//    }
    
    class func member()->Member? {
//        let findResult = Member.shareInstance.condition("isDefault=1").find()
//        if let f = findResult {
//            if f.count > 0 {
//                if let a = f.lastObject {
//                    return Member(dict: a as! [String: AnyObject])
//                }
//            }
//        }
        return nil
    }
    class func isLogined() -> Bool {
//        let findResult = Member.shareInstance.condition("isLogin=1").find()
//        if let f = findResult {
//            if f.count > 0 {
//              return true
//            }
//        }
        return false
    }
    class func loyoutMember() {
//        Member.shareInstance.uid = 0
//       
//        
//        Member.shareInstance.condition("isLogin=1").save(["isLogin": 0])
//        
    }
}
