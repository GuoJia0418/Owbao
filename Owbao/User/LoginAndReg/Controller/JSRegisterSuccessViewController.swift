//
//  JSRegisterSuccessViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  非CPS用户点击button后跳转到体验标详情页，cps注册用户点击button后跳转到理财列表页面

import UIKit

class JSRegisterSuccessViewController: BaseViewController {

    @IBOutlet weak var regSuccessMessageLabel: UILabel! //注册成功消息
    @IBOutlet weak var regMsgLabel: UILabel!    //发放到你的账户
    @IBOutlet weak var gotoVerifyBtn: UIButton!
    
    var regiseter: Register? //从注册界面传过来的模型
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.configUI()
         NotificationCenter.default.post(name: Notification.Name(rawValue: "REGISTER_SUCCESS_NOTIFICATION"), object: true)
    }
    override func leftBarButtonItemAction() {
        super.leftBarButtonItemAction()
        MobClick.event("0100011")
    }
    //MARK: 设置UI
    func configUI() {
        navigationItem.title = "注册"
        
        self.gotoVerifyBtn.layer.cornerRadius = 5.0
        self.gotoVerifyBtn.layer.masksToBounds = true

        if self.regiseter != nil {
            
            if self.regiseter!.isCps == 0 {
                gotoVerifyBtn.setTitle("立即激活", for: UIControlState())
            } else {
                gotoVerifyBtn.setTitle("去赚钱", for: UIControlState())
            }
            
            if self.regiseter!.regSendLabel == "" {
                self.regMsgLabel.isHidden = true
                self.regSuccessMessageLabel.isHidden = true
            } else {
                
                self.regMsgLabel.isHidden = false
                self.regSuccessMessageLabel.isHidden = false
                let rootString = self.regiseter!.regSendLabel
                let array = rootString.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
                let array_oc = NSMutableArray(array: array)
                array_oc.remove("")
                
                let attriString = NSMutableAttributedString(string: rootString)
                
                for i in 0...array_oc.count - 1 {
                    let string = array_oc[i] as! String
                    let rangeString = NSString(string: string)
                    let rangeString_root = NSString(string: rootString)
                    
                    attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: rangeString_root.range(of: rangeString as String))
                }
                
                self.regSuccessMessageLabel.attributedText = attriString
            }
        }
    }
    
    //MARK: - 确认
    @IBAction func confirmClick(_ sender: UIButton) {
        
        if self.regiseter != nil {
            MobClick.event("0100010")
            RootNavigationController.goToInvestList(controller: self)
        }
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSRegisterSuccessViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
