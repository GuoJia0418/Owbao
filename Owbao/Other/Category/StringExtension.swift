//
//  StringExtension.swift
//  Owbao
//
//  Created by lufeng on 16/2/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation
//处理字符串
extension String {
    //检测银行卡
    func verifyBankCard() -> Bool {
        let pattern = "^([0-9]{16}|[0-9]{19}|[0-9]{17}|[0-9]{18}|[0-9]{20}|[0-9]{21})$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    //检测姓名
    func verifyUserName() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fa5}]{2,12}$)|(^[A-Za-z0-9_-]{4,12}$)"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    //MARK: - 验证身份证
    func verifyId() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    
    
    
    //MARK:处理手机号
    func phoneNoAddAsterisk() -> String {
        return (self as NSString).replacingCharacters(in: NSMakeRange(3,4), with: "****")
    }
    
    //MARK:处理手机号
    func phoneNoHide() -> String {
        return (self as NSString).replacingCharacters(in: NSMakeRange(2,7), with: "*******")
    }
    //MARK:处理银行卡号
    func bankCardAddAsterisk() -> String {
        if self.characters.count  == 0 {
            return self
        }
        return (self as NSString).replacingCharacters(in: NSMakeRange(4,10), with: "***********")
    }
    //MARK:获取字符串个数(去空格)
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    // 检测密码
    func isPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"//"^[@A-Za-z0-9!#\\$%\\^&*\\.~_]{6,20}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            return true
        }
        return false
    }
    //MARK: - 验证手机号
    func isPhoneNo() -> Bool {
        if let _ = self.range(of: "^1[3|4|5|7|8][0-9]{9}$", options: .regularExpression) {
            return true
        }
        return false
    }
    //MARK: - 验证是否是纯数字
    func isNumber() -> Bool {
        let pattern = "^[0-9]+$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
//        let a = "aaaa"
    
//        a.trimOptional()
        return false
    }
    //
    //MARK: - 验证是否是6位纯数字
    func isNumberSix() -> Bool {
        let pattern = "^\\d{6}$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
//        let a = "aaaa"
//        a.trimOptional()
        return false
    }
    //MARK: - 验证是否是是有效提现金额
    func verifyNumberTwo() -> Bool {
        let pattern = "^\\d+(\\.\\d{1,2})?$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var objcLength: Int {
        return self.utf16.count
    }
    
    //MARK: - Linguistics
    
    /**
     Returns the langauge of a String
     
     NOTE: String has to be at least 4 characters, otherwise the method will return nil.
     
     - returns: String! Returns a string representing the langague of the string (e.g. en, fr, or und for undefined).
     */
    func detectLanguage() -> String? {
        if self.length > 4 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeLanguage], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
     Returns the script of a String
     
     - returns: String! returns a string representing the script of the String (e.g. Latn, Hans).
     */
    func detectScript() -> String? {
        if self.length > 1 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeScript], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeScript, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
     Check the text direction of a given String.
     
     NOTE: String has to be at least 4 characters, otherwise the method will return false.
     
     - returns: Bool The Bool will return true if the string was writting in a right to left langague (e.g. Arabic, Hebrew)
     
     */
    var isRightToLeft : Bool {
        let language = self.detectLanguage()
        return (language == "ar" || language == "he")
    }
    
    
    //MARK: - Usablity & Social
    
    /**
     Check that a String is only made of white spaces, and new line characters.
     
     - returns: Bool
     */
    func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0
    }
    
    /**
     Checks if a string is an email address using NSDataDetector.
     
     - returns: Bool
     */
    var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length))
        
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /**
     Check that a String is 'tweetable' can be used in a tweet.
     
     - returns: Bool
     */
    func isTweetable() -> Bool {
        let tweetLength = 140,
        // Each link takes 23 characters in a tweet (assuming all links are https).
        linksLength = self.getLinks().count * 23,
        remaining = tweetLength - linksLength
        
        if linksLength != 0 {
            return remaining < 0
        } else {
            return !(self.utf16.count > tweetLength || self.utf16.count == 0 || self.isOnlyEmptySpacesAndNewLineCharacters())
        }
    }
    
    /**
     Gets an array of Strings for all links found in a String
     
     - returns: [String]
     */
    func getLinks() -> [String] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> String in
                return link.url!.absoluteString
        }
    }
    
    /**
     Gets an array of URLs for all links found in a String
     
     - returns: [NSURL]
     */
    func getURLs() -> [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> URL in
                return link.url!
        }
    }
    
    
    /**
     Gets an array of dates for all dates found in a String
     
     - returns: [NSDate]
     */
    func getDates() -> [Date] {
        let error: NSErrorPointer = nil
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        } catch let error1 as NSError {
            error?.pointee = error1
            detector = nil
        }
        let dates = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.utf16.count)) .map {$0 }
        
        return dates!.filter { date in
            return date.date != nil
            }.map { link -> Date in
                return link.date!
        }
    }
    
    /**
     Gets an array of strings (hashtags #acme) for all links found in a String
     
     - returns: [String]
     */
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
    
    /**
     Gets an array of distinct strings (hashtags #acme) for all hashtags found in a String
     
     - returns: [String]
     */
    func getUniqueHashtags() -> [String]? {
        return Array(Set(getHashtags()!))
    }
    
    
    
    /**
     Gets an array of strings (mentions @apple) for all mentions found in a String
     
     - returns: [String]
     */
    func getMentions() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
    
    /**
     Check if a String contains a Date in it.
     
     - returns: Bool with true value if it does
     */
    func getUniqueMentions() -> [String]? {
        return Array(Set(getMentions()!))
    }
    
    
    /**
     Check if a String contains a link in it.
     
     - returns: Bool with true value if it does
     */
    func containsLink() -> Bool {
        return self.getLinks().count > 0
    }
    
    /**
     Check if a String contains a date in it.
     
     - returns: Bool with true value if it does
     */
    func containsDate() -> Bool {
        return self.getDates().count > 0
    }
    
    /**
     - returns: Base64 encoded string
     */
    func encodeToBase64Encoding() -> String {
        let utf8str = self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    /**
     - returns: Decoded Base64 string
     */
    func decodeFromBase64Encoding() -> String {
        let base64data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return NSString(data: base64data!, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    
    
    // MARK: Subscript Methods
    
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        var start = characters.index(startIndex, offsetBy: r.lowerBound),
        end = characters.index(startIndex, offsetBy: r.upperBound)
        
        return substring(with: (start ..< end))
    }
    
    subscript (range: NSRange) -> String {
        let end = range.location + range.length
        return self[(range.location ..< end)]
    }
    
    subscript (substring: String) -> Range<String.Index>? {
        return range(of: substring, options: NSString.CompareOptions.literal, range: (startIndex ..< endIndex), locale: Locale.current)
    }
    
}

