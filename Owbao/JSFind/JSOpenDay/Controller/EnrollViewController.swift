//
//  EnrollViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/14.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  在线报名控制器

import UIKit

class EnrollViewController: BaseViewController {
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var displayProvinceLabel: UILabel! //显示省label
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    var openDayId: Int = 0 //获取到的活动id
    
    fileprivate var province: String = "" //保存省名字
    fileprivate var gender: Int = 2       //默认没有选择 ,0：男，1：女的

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "在线报名"
        self.bottomButton.layer.cornerRadius = 6
        self.bottomButton.layer.masksToBounds = true
        
        //配置底部按钮是否可用
        self.configureBottomButton()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.nameTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.loadData()
    }
    
    override func loadData() {
        
        self.view.showLoadingHud()
        EnrollGetPicture(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            self.view.hideHud()
            let resultDict = request.responseJSONObject as? [String:AnyObject]
            print("sdfsdfsdf---\(resultDict)")
            
            let dataModel = EnrollGetPictureModel(dictionary: resultDict!)
            
            //预处理数据
//            if self.handleDownloadedData(dataModel, isShowLoginCtrl: true) {
//                
//                //显示图片
//                self.displayImageView.sd_setImage(with: URL(string: (dataModel.map?.jsSpecial?.h5TopBanner)!), placeholderImage: Common.image(with: UIColorFromRGB(237, green: 237, blue: 237)), options: SDWebImageOptions.refreshCached)
//            }
            
            if dataModel.success {
                //显示图片
                self.displayImageView.sd_setImage(with: URL(string: (dataModel.map?.jsSpecial?.h5TopBanner)!), placeholderImage: Common.image(with: UIColorFromRGB(237, green: 237, blue: 237)), options: SDWebImageOptions.refreshCached)
            } else {
                
                if dataModel.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if dataModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    if dataModel.errorMsg != "" {
                        self.view.showTextHud(dataModel.errorMsg)
                    } else {
                        self.view.showTextHud("发生了未知错误")
                    }
                }
            }
            
        }) { (request:YTKBaseRequest!) in
            self.view.showTextHud("网络错误,请稍后重试")
            self.view.hideHud()
        }
    }
    
    //监听通知
    func textFieldTextDidChange() -> () {
        //配置底部按钮是否可用
        self.configureBottomButton()
    }
    
    @IBAction func chooseButtonAction(_ sender: AnyObject) {
        
        let view = JSChooseAddressPickView.animateWindowsAddSubView()
        view.reloadView(1)
        
        //点击回调
        view.pickViewCallback = {
        (provinceName: String?,cityName: String?,districtName: String?) in
           self.province = provinceName!
           self.displayProvinceLabel.text = "\(provinceName!)"
            
           //配置底部按钮是否可用
           self.configureBottomButton()
        }
    }
    
    func configureBottomButton() -> () {
        
        if self.gender == 2 || self.province == "" || self.nameTextField.text == "" || self.nameTextField.text == nil {
            self.bottomButton.backgroundColor = UIColorFromRGB(173, green: 173, blue: 173)
            self.bottomButton.isEnabled = false
        } else {
            self.bottomButton.backgroundColor = UIColorFromRGB(223, green: 40, blue: 40)
            self.bottomButton.isEnabled = true
        }
    }
    
    @IBAction func bottomButtonAction(_ sender: AnyObject) {
        //开始报名参加
        self.view.showLoadingHud()
        
        EnrollApi(Uid: UserModel.shareInstance.uid ?? 0, Sex: self.gender, City: self.province, UserName: self.nameTextField.text!, OpenDayId: self.openDayId).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            self.view.hideHud()
            
            let resultDict = request.responseJSONObject as? [String:AnyObject]
            let dataModel = EnrollModel(dictionary: resultDict!)
            
//            if self.handleDownloadedData(dataModel, isShowLoginCtrl: true) {
//                
//                if dataModel.success == true {
//                    
//                    self.view.showTextHud("报名成功")
//                    delay(1, block: {
//                        
//                        //跳到开放日控制器
//                        self.navigationController?.popViewController(animated: true)
//                    })
//                    
//                } else {
//                    
//                    self.view.showTextHud("报名失败")
//                }
//            }
            
            if dataModel.success {
                
                self.view.showTextHud("报名成功")
                delay(1, block: {
                    //跳到开放日控制器
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                
                if dataModel.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if dataModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    if dataModel.errorMsg != "" {
                        self.view.showTextHud(dataModel.errorMsg)
                    } else {
                        self.view.showTextHud("报名失败")
                    }
                }
            }
            
        }) { (request:YTKBaseRequest!) in
            self.view.showTextHud("网络错误,请稍后重试")
            self.view.hideHud()
        }
    }
    
    @IBAction func ChooseGenderAction(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        
        if button.tag == 0 { //男的
            self.manButton.setImage(UIImage(named: "已选中.png"), for: UIControlState())
            self.womenButton.setImage(UIImage(named: "未选中.png"), for: UIControlState())
            self.gender = 0
        } else if button.tag == 1 { //女的
            self.manButton.setImage(UIImage(named: "未选中.png"), for: UIControlState())
            self.womenButton.setImage(UIImage(named: "已选中.png"), for: UIControlState())
            self.gender = 1
        }
        //配置底部按钮是否可用
        self.configureBottomButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("EnrollViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
