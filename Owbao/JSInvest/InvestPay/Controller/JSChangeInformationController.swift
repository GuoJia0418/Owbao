//
//  JSChangeInformationController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/9.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum ChangeInformationType: Int {
    case phoneUpdate = 0
    case nameUpdate  = 1
}

class JSChangeInformationController: BaseViewController,UITextFieldDelegate {
    var controllerType: ChangeInformationType = .phoneUpdate
    var lastSaveString: String = ""             //用来显示之前设置过的
    
    @IBOutlet weak var textField: UITextField!
    //保存成功后的回调
    var saveActionSuccessCallback: ((_ controllerType: ChangeInformationType,_ saveString: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.text = lastSaveString
        self.configureUIWithControllerType()
    }
    
    //配置UI界面
    func configureUIWithControllerType() -> () {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveAction))
        //取消键盘的手势
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditAction))
        self.view.addGestureRecognizer(gesture)
        
        //设置代码
        self.textField.delegate = self
        
        if self.controllerType == .phoneUpdate {
            self.title = "联系电话"
            self.textField.placeholder = "请输入手机号码"
            self.textField.keyboardType = UIKeyboardType.numberPad
        } else {
            self.title = "收货人"
            self.textField.placeholder = "请输入收货人名字"
            self.textField.keyboardType = UIKeyboardType.default
        }
    }

    func endEditAction() -> () {
        self.view.endEditing(true)
    }
    
    //保存操作
    func saveAction() -> () {
        
        self.view.endEditing(true)
        var saveString = ""
        
        if self.controllerType == .phoneUpdate {
            saveString = self.textField!.text!
            
            if self.textField.text == "" || self.textField.text == nil {
                self.view.showTextHud("请完善收货人手机号码")
                return
            }
            
            if self.textField.text?.CheckPhoneNo() == false {
                self.view.showTextHud("请输入正确的手机号码")
                return
            }
            
        } else {
            saveString = self.textField.text!
            if self.textField.text == "" || self.textField.text == nil {
                self.view.showTextHud("请完善收货人名字")
                return
            }
        }
        
        if self.saveActionSuccessCallback != nil {
            self.saveActionSuccessCallback!(self.controllerType,saveString)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if self.controllerType == .phoneUpdate { //如果是修改手机号码，需要加入限制
            if range.location >= 11 {
                return false
            }
        }

        if string.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            return true
        }
        return true
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSChangeInformationController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
