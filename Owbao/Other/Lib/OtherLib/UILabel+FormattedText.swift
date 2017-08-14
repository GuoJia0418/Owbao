//
//  UILabel+FormattedText.swift
//  UILabel+FormattedText
//
//  Created by João Costa on 16/09/15.
//
//

import Foundation
import UIKit

extension UILabel {
    
    func fullRange() -> NSRange {
        return NSMakeRange(0, (text ?? "").characters.count)
    }

    // MARK: Range Formatter
    
    func setTextColor(_ color: UIColor, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        attributedText = text
    }
    
    func setFont(_ font: UIFont, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.addAttribute(NSFontAttributeName, value: font, range: range)
        attributedText = text
    }
    
    func setTextUnderline(_ color: UIColor, range: NSRange?) {
        setTextUnderline(color, range: range, byWord: false)
    }

    func setTextUnderline(_ color: UIColor, range: NSRange?, byWord: Bool) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        var style = NSUnderlineStyle.styleSingle.rawValue
        if byWord { style = style | NSUnderlineStyle.byWord.rawValue }
        text.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: style as Int), range: range)
        text.addAttribute(NSUnderlineColorAttributeName, value: color, range: range)
        attributedText = text
    }
    
    func setTextWithoutUnderline(range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.removeAttribute(NSUnderlineStyleAttributeName, range: range)
        attributedText = text
    }
    
    // MARK: String Formatter
    
    func rangeOf(_ string: String) -> NSRange? {
        let range = NSString(string: text ?? "").range(of: string)
        return range.location != NSNotFound ? range : nil
    }
    
    func setTextColor(_ color: UIColor, string: String) {
        setTextColor(color, range: rangeOf(string))
    }
    
    func setFont(_ font: UIFont, string: String) {
        setFont(font, range: rangeOf(string))
    }
    
    func setTextUnderline(_ color: UIColor, string: String) {
        setTextUnderline(color, range: rangeOf(string))
    }
    
    func setTextUnderline(_ color: UIColor, string: String, byWord: Bool) {
        setTextUnderline(color, range: rangeOf(string), byWord: byWord)
    }
    
    func setTextWithoutUnderline(string: String) {
        setTextWithoutUnderline(range: rangeOf(string))
    }
    
    // MARK: After Formatter
    
    func rangeAfter(_ string: String) -> NSRange? {
        guard var range = rangeOf(string) else { return nil }
        
        range.location = range.location + range.length
        range.length = text!.characters.count - range.location
        return range
    }
    
    func setTextColor(_ color: UIColor, after: String) {
        setTextColor(color, range: rangeAfter(after))
    }
    
    func setFont(_ font: UIFont, after: String) {
        setFont(font, range: rangeAfter(after))
    }
    
    func setTextUnderline(_ color: UIColor, after: String) {
        setTextUnderline(color, range: rangeAfter(after))
    }
    
    func setTextUnderline(_ color: UIColor, after: String, byWord: Bool) {
        setTextUnderline(color, range: rangeAfter(after), byWord: byWord)
    }
    
    func setTextWithoutUnderline(after: String) {
        setTextWithoutUnderline(range: rangeAfter(after))
    }
    
    // MARK: Before Formatter
    
    func rangeBefore(_ string: String) -> NSRange? {
        guard var range = rangeOf(string) else { return nil }
        
        range.length = range.location
        range.location = 0
        return range
    }
    
    func setTextColor(_ color: UIColor, before: String) {
        setTextColor(color, range: rangeBefore(before))
    }
    
    func setFont(_ font: UIFont, before: String) {
        setFont(font, range: rangeBefore(before))
    }
    
    func setTextUnderline(_ color: UIColor, before: String) {
        setTextUnderline(color, range: rangeBefore(before))
    }
    
    func setTextUnderline(_ color: UIColor, before: String, byWord: Bool) {
        setTextUnderline(color, range: rangeBefore(before), byWord: byWord)
    }
    
    func setTextWithoutUnderline(before: String) {
        setTextWithoutUnderline(range: rangeBefore(before))
    }
    
    // MARK: After & Before Formatter
    
    func rangeAfter(_ after: String, before: String) -> NSRange? {
        guard let rAfter = rangeAfter(after) else { return nil }
        guard let rBefore = rangeBefore(before) else { return nil }
        
        if rAfter.location < rBefore.length {
            return NSMakeRange(rAfter.location, rBefore.length - rAfter.location)
        }
        
        return nil
    }
    
    func setTextColor(_ color: UIColor, after: String, before: String) {
        setTextColor(color, range: rangeAfter(after, before: before))
    }
    
    func setFont(_ font: UIFont, after: String, before: String) {
        setFont(font, range: rangeAfter(after, before: before))
    }
    
    func setTextUnderline(_ color: UIColor, after: String, before: String) {
        setTextUnderline(color, range: rangeAfter(after, before: before))
    }
    
    func setTextUnderline(_ color: UIColor, after: String, before: String, byWord: Bool) {
        setTextUnderline(color, range: rangeAfter(after, before: before), byWord: byWord)
    }
    
    func setTextWithoutUnderline(after: String, before: String) {
        setTextWithoutUnderline(range: rangeAfter(after, before: before))
    }
    
    // MARK: From Formatter
    
    func rangeFrom(_ string: String) -> NSRange? {
        guard var range = rangeOf(string) else { return nil }
        
        range.length = text!.characters.count - range.location
        return range
    }
    
    func setTextColor(_ color: UIColor, from: String) {
        setTextColor(color, range: rangeFrom(from))
    }
    
    func setFont(_ font: UIFont, from: String) {
        setFont(font, range: rangeFrom(from))
    }
    
    func setTextUnderline(_ color: UIColor, from: String) {
        setTextUnderline(color, range: rangeFrom(from))
    }
    
    func setTextUnderline(_ color: UIColor, from: String, byWord: Bool) {
        setTextUnderline(color, range: rangeFrom(from), byWord: byWord)
    }
    
    func setTextWithoutUnderline(from: String) {
        setTextWithoutUnderline(range: rangeFrom(from))
    }
    
    // MARK: To Formatter
    
    func rangeTo(_ string: String) -> NSRange? {
        guard var range = rangeOf(string) else { return nil }
        
        range.length = range.location + range.length
        range.location = 0
        return range
    }
    
    func setTextColor(_ color: UIColor, to: String) {
        setTextColor(color, range: rangeTo(to))
    }
    
    func setFont(_ font: UIFont, to: String) {
        setFont(font, range: rangeTo(to))
    }
    
    func setTextUnderline(_ color: UIColor, to: String) {
        setTextUnderline(color, range: rangeTo(to))
    }
    
    func setTextUnderline(_ color: UIColor, to: String, byWord: Bool) {
        setTextUnderline(color, range: rangeTo(to), byWord: byWord)
    }
    
    func setTextWithoutUnderline(to: String) {
        setTextWithoutUnderline(range: rangeTo(to))
    }
    
    // MARK: From & To Formatter
    
    func rangeFrom(_ from: String, to: String) -> NSRange? {
        guard let rFrom = rangeFrom(from) else { return nil }
        guard let rTo = rangeTo(to) else { return nil }
        
        if rFrom.location < rTo.length {
            return NSMakeRange(rFrom.location, rTo.length - rFrom.location)
        }
        
        return nil
    }
    
    func setTextColor(_ color: UIColor, from: String, to: String) {
        setTextColor(color, range: rangeFrom(from, to: to))
    }
    
    func setFont(_ font: UIFont, from: String, to: String) {
        setFont(font, range: rangeFrom(from, to: to))
    }
    
    func setTextUnderline(_ color: UIColor, from: String, to: String) {
        setTextUnderline(color, range: rangeFrom(from, to: to))
    }
    
    func setTextUnderline(_ color: UIColor, from: String, to: String, byWord: Bool) {
        setTextUnderline(color, range: rangeFrom(from, to: to), byWord: byWord)
    }
    
    func setTextWithoutUnderline(from: String, to: String) {
        setTextWithoutUnderline(range: rangeFrom(from, to: to))
    }

    // MARK: Helpers
    
    fileprivate func mutableAttributedString() -> NSMutableAttributedString {
        if attributedText != nil {
            return NSMutableAttributedString(attributedString: attributedText!)
        } else {
            return NSMutableAttributedString(string: text ?? "")
        }
    }
}
