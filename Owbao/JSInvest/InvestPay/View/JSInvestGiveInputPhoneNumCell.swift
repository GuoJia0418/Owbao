//
//  JSInvestGiveInputPhoneNumCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/8.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  输入用户手机号码

import UIKit

class JSInvestGiveInputPhoneNumCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var inputPhoneNumTextFiled: UITextField! //输入
    var textChangeInput: ((_ numberString: String) -> ())? //输入
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.inputPhoneNumTextFiled.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.inputPhoneNumTextFiled)
    }
    
    //配置cell
    func configureCell(_ addressDetailModel: GetAddressDetailModel?) -> () {
        
        if addressDetailModel != nil  {
            self.inputPhoneNumTextFiled.text = addressDetailModel?.phone
        }
    }
    
    //MAKR: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location >= 11 { //
            return false
        }
        
        if string.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            return true
        }
        return true
    }
    
    //MARK: 通知
    func textFieldDidChange(_ textField: UITextField) {
        
        if self.textChangeInput != nil {
            self.textChangeInput!(inputPhoneNumTextFiled.text!)
        }
    }
    
    
    class func cellHeight() -> CGFloat {
        return 140.0
    }
    
}
