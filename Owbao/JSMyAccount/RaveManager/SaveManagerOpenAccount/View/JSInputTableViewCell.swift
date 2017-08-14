//
//  JSInputTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInputTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var clickButton: UIButton! //这个默认是隐藏的
    
    var isAllowEditor: Bool = true //默认容许编辑
    var changeCallback: ((_ text: String?) -> ())?
    var clickButtonCallback: (() -> ())?
    
    @IBOutlet weak var leftConstrainsMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.inputTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.inputTextField)
        
        self.leftConstrainsMargin.constant = (170.0/414.0) * UIScreen.main.bounds.size.width
    }
    
    @IBAction func buttonClickAction(_ sender: Any) {
        if self.clickButtonCallback != nil {
            self.clickButtonCallback!()
        }
    }
    
    func textDidChange() {
        if changeCallback != nil {
            self.changeCallback!(self.inputTextField.text)
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 104: //姓名
            MobClick.event("0200002")
            break
        case 101: //身份证号
            MobClick.event("0200003")
            break
        case 102: //银行卡号
            MobClick.event("0200005")
            break
        case 105: //支付密码
            MobClick.event("0200007")
            break
        case 106: //确认支付密码
            MobClick.event("0200008")
            break
        default:
            break
        }
        return self.isAllowEditor
    }
    
    //MARK: - 输入限制
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var res = true
        //身份证输入限制
        if textField.tag == 101 {
            let tmSet = CharacterSet(charactersIn:"0123456789Xx")
            var i = 0
            
            while i < string.characters.count {
                let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
                let range = string1.rangeOfCharacter(from: tmSet)
                if (range.length == 0) {
                    res = false
                    break;
                }
                i += 1
            }
            
            if range.location >= 18 {
                res = false
            }
            return res
        }
        
        //银行卡号输入限制
        if textField.tag == 102 {
            
            let tmSet = CharacterSet(charactersIn:"0123456789")
            var i = 0
            
            while i < string.characters.count {
                let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
                let range = string1.rangeOfCharacter(from: tmSet)
                if (range.length == 0) {
                    res = false
                    break;
                }
                i += 1
            }
            
            if range.location >= 10 {
                res = true
            }
            
            return res
        }
    
        //手机号输入限制
        if textField.tag == 103 {
            
            let tmSet = CharacterSet(charactersIn:"0123456789")
            var i = 0
            
            while i < string.characters.count {
                let string1:NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
                let range = string1.rangeOfCharacter(from: tmSet)
                if (range.length == 0) {
                    res = false
                    break;
                }
                i += 1
            }
            //            if textField.text?.characters.count > 12 {
            //                res = false  //会引起删不掉的情况
            //            }
            if range.location >= 11 {
                res = false
            }
            return res
        }
        
        //验证码输入限制
//        if textField.tag == 104 {
//            let tmSet = CharacterSet(charactersIn:"0123456789")
//            var i = 0
//            while i < string.characters.count {
//                let string1: NSString = (string as NSString).substring(with: NSMakeRange(i, 1)) as NSString
//                let range = string1.rangeOfCharacter(from: tmSet)
//                if (range.length == 0) {
//                    res = false
//                    break;
//                }
//                i += 1
//            }
//            
//            if range.location >= 4 {
//                res = false
//            }
//            
//            return res
//        }
        
        return res
    }
}
