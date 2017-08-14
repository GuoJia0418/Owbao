//
//  RegularExpression(正则表达式).swift
//  Owbao
//
//  Created by lufeng on 16/2/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

//正则表达式
struct RegexHelper {
    let regex: NSRegularExpression
    init(pattern:String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    func match(_ input:String) ->Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}

//正则检测字符串
extension String {
    //MARK:检测用户名
    func CheckUserName() -> Bool {
        let patten = "(^[\u{4e00}-\u{9fa5}]{2,12}$)|(^[A-Za-z0-9_-]{4,12}$)"
        let regex = try! NSRegularExpression(pattern: patten, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    //MARK:检测非法字符
    func CheckInvalid() -> Bool {
        let pattern = "[`~!@#\\$%\\^&*\\(\\)\\+<>\\?:\\\"{},\\./\\;'\\[\\]]"
        _ = "[`~!@#%&*()<>:,;']"
        _ = "^([a-z0-9_\\.-])@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    
    //MARK:检测密码
    func CheckPassword() -> Bool {
        let pattern = "^[@A-Za-z0-9!#\\$%\\^&*\\.~_]{6,20}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    
    //MARK: - 是否是8-16位数字与字母组密码
    func checkPasswordSecond() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    
    //MARK:检测手机号
    func CheckPhoneNo() -> Bool {
        if let _ = self.range(of: "^1[3|4|5|7|8][0-9]{9}$", options: .regularExpression) {
            return true
        }
        return false
    }
    //MARK:检测身份证
    func CheckId() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    //MARK:检测是否是纯数字
    func CheckNumber() -> Bool {
        let pattern = "^[0-9]+$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    func CheckNumberTwo() -> Bool {
        let pattern = "^\\d+(\\.\\d{1,2})?$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    //MARK:检测是否是银行卡号
    func CheckBankCard() -> Bool {
        let pattern = "^([0-9]{16}|[0-9]{19})$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    
    
}
