//
//  ConfirmPassWordController.swift
//  Owbao
//
//  Created by lufeng on 16/2/26.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

// 原始值的隐式赋值
//enum JumpToTarget: Int {
//    case HomeNoviceBit = 1, HomeRegisterGift, InvestmentNoviceBit, InvestmentPiaoAn, InvestmentPiaoYou
//}

class ConfirmPassWordController: BaseViewController,UIAlertViewDelegate {
    var phoneNo: String = ""
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var phoneNoLB: UILabel!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var eyebtn: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience  init() {
        
        let nibNameOrNil = String?("ConfirmPassWordController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "登录"

        phoneNoLB.text = phoneNo.phoneNoAddAsterisk()
        
        //  如果不是 导航过来的 设置返回按钮
        // 判断，如果是 从 登录的第一个页面过来，那么，是 pop 出去
//        if navigationController?.childViewControllers.first?.classForCoder != LoginController.classForCoder(){
//            let navBackBtn = UIButton(type: .Custom)
//            let navImage = UIImage(named: "icon_arrows")
//            navBackBtn.setImage(navImage, forState: .Normal)
//            navBackBtn.frame.size = navImage!.size;
//            navBackBtn.addTarget(self, action: #selector(ConfirmPassWordController.backToLastVCAction(_:)), forControlEvents: .TouchUpInside)
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBackBtn)
//            
//        }
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "切换手机号", style: UIBarButtonItemStyle.Plain, target: self, action: "switchPhoneNo")
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dismiss), name: "setDismiss", object: nil)

    }
//    func setupRac() {
//        RAC(confirmBtn, "enabled") <= RACSignal.combineLatest([passWordTF.rac_textSignal()], reduce: { () -> AnyObject! in
//            return (self.passWordTF.text?.characters.count > 0)
//        })
//        
//        //             显示 明文 或者显示 暗文
//        eyebtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) -> Void in
//            self.passWordTF.secureTextEntry = self.eyebtn.selected
//            self.eyebtn.selected = !self.eyebtn.selected
//        }
//        
//        confirmBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) -> Void in
//            
//            // 正则 手机
//            if !self.passWordTF.text!.stringByReplacingOccurrencesOfString(" ", withString: "").isPassword() {
//                self.view.showTextHud("密码格式不正确")
//                return
//            }
//
//            self.view.showLoadingHud()     //加密 
//            Login.login(self.phoneNo, password: jm().sbjm(self.passWordTF.text!) , success: { (result: Login) -> () in
//                    self.view.hideHud()
//                
//                if result.success == 1 {
//                    self.view.showTextHud("登录成功")
//                    dump(result)
//                    let mem = result.member
//                    
//                    UserModel.shareInstance.uid = mem!.uid
//                    UserModel.shareInstance.realVerify = mem!.realVerify
//                    UserModel.shareInstance.tpwdFlag = mem!.tpwdSetting
//                    UserModel.shareInstance.mobilephone = mem!.mobilephone
//                    UserModel.shareInstance.idCards = mem!.idCards
//                    UserModel.shareInstance.token = mem!.token
//                    UserModel.shareInstance.isLogin = 1
//                    UserModel.shareInstance.recommCodes = mem!.recommCodes
//                    UserModel.shareInstance.saveData()
//                    
//                    
//                    
//                    self.dismissViewControllerAnimated(true,completion: {
//                    NSNotificationCenter.defaultCenter().postNotificationName("LOGIN_SUCCESS_NOTIFICATION", object: false)
//                    })
//
//                } else {
//                    self.view.showTextHud(result.msg!)
//                }
//                }, failure: { (error) -> () in
//                    self.view.hideHud()
//                    self.view.showTextHud("网络错误")
//            })
//        }
//        forgetPwdBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (btn:AnyObject!) -> Void in
//            let findVC = FindPasswordViewController()
//            findVC.phoneNo = self.phoneNo
//            findVC.type = 2
//            self.navigationController?.pushViewController(findVC, animated: true)
//        }
//    }
    /**
     切换手机号 方法
     */
//    func switchPhoneNo() {
//        // 判断，如果是 从 登录的第一个页面过来，那么，是 pop 出去
//        if navigationController?.childViewControllers.first?.classForCoder == LoginController.classForCoder(){
//            self.navigationController?.popToRootViewControllerAnimated(true)
//            return ;
//        }
//        let loginVC = LoginController()
//        navigationController?.pushViewController(loginVC, animated: true)
//        
////        // 否则是dismiss掉
////        // 先销毁
////        self.dismissViewControllerAnimated(true, completion: nil)
////        // 1.3. 没有保存手机号，也就是第一次登录的时候，那么就跳转到第一个界面
////        let nvc = BaseNavigationController(rootViewController:LoginController())
//////        nvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
////        self.parentViewController!.presentingViewController?.presentViewController(nvc, animated: true, completion: nil)
//    }
    func backToLastVCAction(_ btn: UIButton) {
    
        RootNavigationController.goToHomeController(controller: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //手势密码
    func showAlertView()
    {
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "登录成功！"
        alertView.message = "是否立即设置手势密码?"
        alertView.addButton(withTitle: "暂不设置")
        alertView.addButton(withTitle: "立即设置")
        alertView.show()
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        
        if buttonIndex == 1 {
            let vc = GestureUnlockViewController()
            vc.createView()
            vc.state = GestureUnlockState.set
            vc.setSuc = {
                psw in
                Defaults.setValue(psw, forKeyPath: "GesturePassword")
                UserModel.shareInstance.isSetGestureUnlock = 1
                self.view.showTextHud("设置手势密码成功")
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.showLoadingHud()
            self.view.showLongTextHud("可以在我的信息-手势密码 中进行修改")
            delay(1.5, block: {
                self.dismiss(animated: true, completion: nil)
            })
        }
       
        
//        if buttonIndex == 1
//        {
//            CLLockVC.showSettingLockVCInVC(self, successBlock: { [weak self] (lockVC: CLLockVC! , PWD: String!) -> Void  in
////                lockVC.vcType = 0
//                lockVC.dismiss(0.0)
//                if let strongSelf = self {
//                    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                    //                        Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
//                    //                    })
//                }
//                
//                })
//        }
//        else
//        {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }

    func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /**
    方法待用
    
    - parameter btn:
    */
//    func backToLastVCAction(btn: UIButton) {
//        if (Defaults["JumpToTarget"].intValue == JumpToTarget.MyAccountVC.rawValue) || (Defaults["JumpToTarget"].intValue == JumpToTarget.QianKunDaiList.rawValue) || (Defaults["JumpToTarget"].intValue == JumpToTarget.HomeNoviceBit.rawValue) || (Defaults["JumpToTarget"].intValue == JumpToTarget.ChiTuBaoDetail.rawValue)  {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        } else {
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//    }
    
    /**
     登录
     
     - parameter sender: 按钮
     */
    @IBAction func loginAction(_ sender: AnyObject) {
        if !self.passWordTF.text!.replacingOccurrences(of: " ", with: "").isPassword() {
            self.view.showTextHud("密码格式不正确")
            return
        }
        self.view.showLoadingHud()     //加密
        
        //MARK: - 待确定
        JSLoginModel.login(self.phoneNo, password: jm().sbjm(self.passWordTF.text!), PicCode: "",success: { (result: JSLoginModel) -> () in
            self.view.hideHud()
            
            if result.success == 1 {
                if Defaults.object(forKey: "IsNewHeadExpire") != nil {
                    Defaults.remove("IsNewHeadExpire")
                }
                
                self.view.showTextHud("登录成功")
               
                let mem = result.map?.member
                
                UserModel.shareInstance.uid = mem!.uid
                UserModel.shareInstance.realVerify = mem!.realVerify
                UserModel.shareInstance.tpwdFlag = mem!.tpwdSetting
                UserModel.shareInstance.mobilephone = mem!.mobilephone
                
                if mem!.idCards != nil {
                    UserModel.shareInstance.idCards = mem!.idCards
                }
//                UserModel.shareInstance.token = mem!.token
                UserModel.shareInstance.token = result.map?.token
                UserModel.shareInstance.isLogin = 1
                UserModel.shareInstance.recommCodes = mem!.recommCodes
                NotificationCenter.default.post(name: Notification.Name(rawValue: "LOGIN_SUCCESS_NOTIFICATION"), object: false)

               
                /*
                 MARK: 登录成功跳出提示是否设置手势密码
                 */
                if UserModel.shareInstance.isPromptGesturePassword == 0 && UserModel.shareInstance.isSetGestureUnlock == 0 && UserModel.shareInstance.realVerify == 1 {
                    //跳出提示，是否设置手势密码
                    UserModel.shareInstance.isPromptGesturePassword = 1        //第一次跳出提示
                    self.showAlertView()
                }else {
                    self.dismiss(animated: true,completion: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOGIN_SUCCESS_NOTIFICATION"), object: false)
                    })
                }
                
            } else {
                self.view.showTextHud(result.msg!)
            }
            }, failure: { (error) -> () in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
        })

    }


    /**
     忘记密码
     
     - parameter sender: 按钮
     */
    @IBAction func forgetAction(_ sender: AnyObject) {
        
        let findVC = FindPasswordViewController()
        findVC.phoneNo = self.phoneNo
        findVC.type = 2
        self.navigationController?.pushViewController(findVC, animated: true)
   
    }
    
    /**
     切换密码显示方式
     
     - parameter sender: 按钮
     */
    @IBAction func eyeAction(_ sender: AnyObject) {
        self.passWordTF.isSecureTextEntry = self.eyebtn.isSelected
        self.eyebtn.isSelected = !self.eyebtn.isSelected

    }
}
