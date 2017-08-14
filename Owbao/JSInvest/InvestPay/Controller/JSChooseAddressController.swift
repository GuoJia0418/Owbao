//
//  JSChooseAddressController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/9.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSChooseAddressController: BaseViewController,UITextViewDelegate {
    
    var chooseAddress: String = ""
    var detailAddress: String = ""
    var addressString: String = ""    //后加的，初始请求获取的地址
    
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var textView: GJTextView!
    
    /** 
     * 保存成功后的回调
     * addressString：省市区地址
     * detailAddress：用户填写的详细地址
     */
    var saveActionSuccessCallback: ((_ chooseAddressString: String,_ detailAddress: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.placeholder = "请填写详细地址,以防物品不能及时送达"
        self.textView.placeholderColor = UIColor.darkGray
        self.textView.font = UIFont.systemFont(ofSize: 15.0)
        self.textView.delegate = self
        
        //设置上次选择的
        if addressString != "" { //新加的逻辑，如果该字段存在，详细地址需要显示该字段
            self.textView.text = self.addressString
        } else {
            if detailAddress != "" {
                self.textView.text = self.detailAddress
            }
        }
        
        if chooseAddress != "" {
            self.rightTextLabel.text = self.chooseAddress
        }
        
        self.bottomButton.layer.cornerRadius = 4
        self.bottomButton.layer.masksToBounds = true
        //配置底部按钮显示
        self.configureBottomButtonDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //配置底部按钮显示
    func configureBottomButtonDisplay() -> () {
        
        if self.rightTextLabel.text == "请选择" || self.textView.text == nil || self.textView.text == "" {
            self.bottomButton.isEnabled = false
            self.bottomButton.backgroundColor = UIColorFromRGB(181, green: 181, blue: 181)
        } else {
            self.bottomButton.isEnabled = true
            self.bottomButton.backgroundColor = UIColorFromRGB(233, green: 48, blue: 57)
        }
    }
    
    //顶部按钮点击
    @IBAction func topButtonClickAction(_ sender: AnyObject) {
       let view = JSChooseAddressPickView.animateWindowsAddSubView()
       self.view.endEditing(true)
        
        //回调
       view.pickViewCallback = {
            (provinceName: String?,cityName: String?,districtName: String?) in
            self.rightTextLabel.text = "\(provinceName!)\(cityName!)\(districtName!)"
            self.chooseAddress = "\(provinceName!)\(cityName!)\(districtName!)"
        
            //配置底部按钮显示
            self.configureBottomButtonDisplay()
        }
    }
    
    //底部按钮点击
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        
        if self.textView.text == "" || self.textView.text == nil {
            self.view.showTextHud("请填写详细地址")
            return
        }
        
        if self.chooseAddress == "" {
            self.view.showTextHud("请选择地址")
            return
        }
        
        if self.saveActionSuccessCallback != nil {
            self.saveActionSuccessCallback!(self.chooseAddress,((self.textView.text)!))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        //配置底部按钮显示
        self.configureBottomButtonDisplay()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSChooseAddressController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
