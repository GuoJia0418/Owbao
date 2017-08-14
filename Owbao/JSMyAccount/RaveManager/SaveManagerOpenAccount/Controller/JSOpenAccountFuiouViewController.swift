//
//  JSOpenAccountFuiouViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOpenAccountFuiouViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    var detailModel: ProductDetailsModel?           //从投资详情传过来的数据
    
    fileprivate var info_isOpen: Bool = true
    fileprivate var bank_isOpen: Bool = true
    fileprivate var password_isOpen: Bool = true 
    fileprivate var infoModel = JSOpenAccountInputModel()
    
    var phoneNumberInput: JSInputTableViewCell = { //输入手机号码
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "手机号码"
        cell.inputTextField.text = UserModel.shareInstance.mobilephone
        cell.isAllowEditor = false
        cell.inputTextField.keyboardType = .numberPad
        cell.inputTextField.tag = 103
        return cell
    }()
    
    var realNameInput: JSInputTableViewCell = {
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "真实姓名"
        cell.inputTextField.placeholder = "请输入真实姓名"
        cell.inputTextField.tag = 104
        return cell 
    }()
    
    var certifIdInput: JSInputTableViewCell = { //身份证号码输入cell
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "身份证号"
        cell.inputTextField.placeholder = "请输入身份证号"
        cell.inputTextField.tag = 101
        return cell
    }()
    
    var openBankInput: JSInputTableViewCell = { //开户行
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "开户行"
        cell.inputTextField.text = "请选择开户"
        cell.isAllowEditor = false
        cell.clickButton.isHidden = false
        cell.arrowImageView.isHidden = false
        return cell
    }()
    
    var bankIdInput: JSInputTableViewCell = { //银行卡号
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "卡号"
        cell.inputTextField.placeholder = "请输入银行卡号"
        cell.inputTextField.keyboardType = .numberPad
        cell.inputTextField.tag = 102
        return cell
    }()
    
    var openBankAdressInput: JSInputTableViewCell = { //开户行所在地
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "开户行所在地"
        cell.inputTextField.text = "请选择开户所在地"
        cell.isAllowEditor = false
        cell.clickButton.isHidden = false
        cell.arrowImageView.isHidden = false
        return cell
    }()
    
    var passwordInput: JSInputTableViewCell = { //设置支付密码
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "设置支付密码"
        cell.inputTextField.placeholder = "8-16位数字与字母组合"
        cell.inputTextField.isSecureTextEntry = true
        cell.inputTextField.tag = 105
        return cell
    }()
    
    var conformPasswordInput: JSInputTableViewCell = { //确认设置支付密码
        let cell = Bundle.main.loadNibNamed("JSInputTableViewCell", owner: self, options: nil)?.last as! JSInputTableViewCell
        cell.leftTitleLabel.text = "确认支付密码"
        cell.inputTextField.placeholder = "请再次输入支付密码"
        cell.inputTextField.isSecureTextEntry = true
        cell.inputTextField.tag = 106
        return cell
    }()
    
    var headerView: JSOpenAccountHeaderView = {
        let view = Bundle.main.loadNibNamed("JSOpenAccountHeaderView", owner: self, options: nil)?.last as! JSOpenAccountHeaderView
        return view
    }()
    
    var footerView: JSOpenAccountFooterView = {
        let view = Bundle.main.loadNibNamed("JSOpenAccountFooterView", owner: self, options: nil)?.last as! JSOpenAccountFooterView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("0200001")
        navigationItem.title = "存管账户"
        self.bottomButton.layer.cornerRadius = 5
        self.bottomButton.layer.masksToBounds = true
        self.loadData()
    }
    
    //MARK: 连接API获取数据
    override func loadData(){
        
        if self.errorView != nil {
            self.errorView.isHidden = true
        }
        
        weak var weakSelf = self
        
        if UserModel.shareInstance.uid! > 0 && UserModel.shareInstance.isLogin == 1 {
            weakSelf!.view.showLoadingHud()
            MyInformationApi(Uid: UserModel.shareInstance.uid!).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("我要提现 -》我的信息首页\(resultDict)")
                let myInfo = MyInformationModel(dict: resultDict!)
                weakSelf!.view.hideHud()
                
                if !myInfo.success {
                    weakSelf!.view.showTextHud("信息获取失败")
                    weakSelf!.loadDataError()
                    return
                } else {
                    
                    if myInfo.map?.realName != "" {
                        self.infoModel.realName = (myInfo.map?.realName)!
                        self.infoModel.realNameNeedVerification = false //不需要校验
                        self.realNameInput.isAllowEditor = false //姓名不容许更改
                    }
                    
                    if myInfo.map?.idCards != "" {
                        self.infoModel.certif_id = (myInfo.map?.idCards)!
                        self.infoModel.certif_idNeedVerification = false //不需要校验
                        self.certifIdInput.isAllowEditor = false //如果身份证存在不容许编辑
                    }
                    
                    if myInfo.map?.bankNum != "" {
                        self.infoModel.cardNumber = (myInfo.map?.bankNum)!
                    }
                    
                    UserModel.shareInstance.tpwdFlag = myInfo.map?.tpwdFlag
                    self.tableView.reloadData()
                }
                
            }, failure: { (request: YTKBaseRequest!) -> Void in
                weakSelf!.view.showTextHud("信息获取失败")
                weakSelf!.loadDataError()
            })
        } else {
            weakSelf!.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        MobClick.event("0200009")
        if self.infoModel.realNameNeedVerification == true && self.infoModel.realName.verifyUserName() == false {
            self.view.showTextHud("请输入正确的姓名")
            return
        } else if self.infoModel.certif_idNeedVerification == true && self.infoModel.certif_id.verifyId() == false {
            self.view.showTextHud("请输入正确的身份证号")
            return
        } else if self.infoModel.cardNumber.characters.count == 0 {
            self.view.showTextHud("银行卡号不能为空")
            return
        } else if self.infoModel.cardNumber.characters.count > 0 &&  self.infoModel.cardNumber.characters.count < 8 {
            self.view.showTextHud("银行卡位数不正确")
            return
        }
//        else if self.infoModel.cardNumber.CheckBankCard() == false {
//            self.view.showTextHud("银行卡号不正确")
//            return
//        }
        
        else if self.infoModel.phoneNumber.isPhoneNo() == false {
            self.view.showTextHud("请输入正确的手机号")
            return
        } else if self.infoModel.bankCode == "" {
            self.view.showTextHud("请选择开户行")
            return
        } else if self.infoModel.OpenBankAddressCode == "" {
            self.view.showTextHud("请选择开户行所在地")
            return
        } else if self.infoModel.password == "" {
            self.view.showTextHud("请输入支付密码")
            return
        } else if self.infoModel.password == "" {
            self.view.showTextHud("请输入确认支付密码")
            return
        } else if self.infoModel.password.characters.count < 8 || self.infoModel.password.characters.count > 16 {
            self.view.showTextHud("支付密码位数不正确")
            return
        } else if self.infoModel.confirmPassword.characters.count < 8 || self.infoModel.confirmPassword.characters.count > 16 {
            self.view.showTextHud("确认支付密码位数不正确")
            return
        } else if self.infoModel.password != self.infoModel.confirmPassword {
            self.view.showTextHud("两次输入的密码不相同")
            return
        } else if self.infoModel.password.checkPasswordSecond() == false {
            self.view.showTextHud("支付密码格式不正确")
            return
        } else if self.infoModel.confirmPassword.checkPasswordSecond() == false {
            self.view.showTextHud("确认支付密码格式不正确")
            return
        }
        
        let viewModel = JSOpenAccountViewModel()
        self.view.showLoadingHud()
        viewModel.requestServer(JSOpenAccountApi(uid: UserModel.shareInstance.uid ?? 0,
                                                      cust_nm: self.infoModel.realName,
                                                      certif_id: self.infoModel.certif_id,
                                                      mobile_no: self.infoModel.phoneNumber,
                                                      city_id: self.infoModel.OpenBankAddressCode,
                                                      parent_bank: self.infoModel.bankCode,
                                                      capAcntNo: self.infoModel.cardNumber,
                                                      password: jm().getMd5_32Bit(self.infoModel.password),
                                                      conformPassword: jm().getMd5_32Bit(self.infoModel.password)),
                                                      modelName: "JSOpenAccountModel",
                                                      callback: { (baseModel) in
                                                        
                                                        self.view.hideHud()
                                                        
                                                        if baseModel.success {
                                                            
                                                            let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,
                                                                                                     viewTpye: .third)
                                                            //开始写标题
                                                            popView.titleLabel_first.text = "开户成功"
                                                            
                                                            popView.titleLabel_first.textColor = UIColor.black
                                                            popView.titleLabel_second.text = "您已经成功开通四川天府银行资金"
                                                            popView.titleLabel_second.textColor = UIColor.darkGray
                                                            
                                                            popView.titleLabel_third.text = "存管账户，快去充值投资赚收益吧!"
                                                            popView.titleLabel_third.textColor = UIColor.darkGray
                                                            
                                                            popView.leftButton.setTitle("暂不充值", for: UIControlState())
                                                            popView.rightButton.setTitle("充值", for: UIControlState())
                                                            
                                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
                                                            
                                                            //右面按钮
                                                            popView.conformCallback = {
                                                                MobClick.event("0200010")
                                                                let rechargeVC = JSSaveRechargeViewController()
                                                                rechargeVC.barType = .red
                                                                rechargeVC.popType = .popToRoot
                                                                rechargeVC.detailModel = self.detailModel
                                                                self.navigationController?.pushViewController(rechargeVC, animated: true)
                                                            }
                                                            
                                                            //左边按钮
                                                            popView.leftCallback = {
                                                                MobClick.event("0200011")
                                                            self.navigationController?.popViewController(animated: true)                                                         }
                                                            
                                                        } else {
                                                            
                                                            if baseModel.errorMsg != "" { //测试
                                                                
                                                                self.view.showTextHud(baseModel.errorMsg)
                                                                
                                                            } else {
                                                                let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,viewTpye: .third)
                                                                
                                                                //开始写标题
                                                                popView.titleLabel_first.text = "开户失败"
                                                                
                                                                popView.titleLabel_first.textColor = UIColor.black
                                                                popView.titleLabel_second.text = "开户遇到问题,"
                                                                popView.titleLabel_second.textColor = UIColor.darkGray
                                                                
                                                                popView.titleLabel_third.text = "请核对您填写的信息是否正确!"
                                                                popView.titleLabel_third.textColor = UIColor.darkGray
                                                                
                                                                popView.rightButton.setTitle("重新开户", for: UIControlState())
                                                                popView.setBottomButtonNumber(bottomNumber: 1)
                                                                
                                                                //右面按钮
                                                                popView.conformCallback = {
                                                                    
                                                                }
                                                            }
                                                        }
         
        }) { (errorString) in
            self.view.showTextHud(errorString)
            self.view.hideHud()
        }
    }
    
    //MARK: UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if self.info_isOpen {
                return 4
            }
        } else if section == 1 {
            if self.bank_isOpen {
                return 4
            }
        } else if section == 2 {
            if self.password_isOpen {
                return 3
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSTitleTableViewCell") as! JSTitleTableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSTitleTableViewCell", owner: self, options: nil)?.first as! JSTitleTableViewCell!
                }
                cell?.tittleLabel.text = "用户信息"
                cell?.configureCell(isOpen: self.info_isOpen)
                
                cell?.tapCallback = {(isOpen) in
                    self.info_isOpen = isOpen
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                    self.view.endEditing(true)
                }
                
                return cell!
                
            } else if indexPath.row == 1 {
                
                //手机号码改变
                self.phoneNumberInput.changeCallback = {(text: String?)in
                    if text != nil {
                        self.infoModel.phoneNumber = text!
                    }
                }
                self.infoModel.phoneNumber = UserModel.shareInstance.mobilephone!
                return self.phoneNumberInput
            } else if indexPath.row == 2 {
                
                //姓名改变
                self.realNameInput.changeCallback = {(text: String?)in
                    if text != nil {
                        self.infoModel.realName = text!
                    }
                }
                self.realNameInput.inputTextField.text = self.infoModel.realName
                return self.realNameInput
            } else {
                
                //身份证号码改变
                self.certifIdInput.changeCallback = {(text: String?)in
                    if text != nil {
                        self.infoModel.certif_id = text!
                    }
                }
                self.certifIdInput.inputTextField.text = self.infoModel.certif_id
                return self.certifIdInput
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSTitleTableViewCell") as! JSTitleTableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSTitleTableViewCell", owner: self, options: nil)?.first as! JSTitleTableViewCell!
                }
                cell?.tittleLabel.text = "银行卡信息"
                cell?.configureCell(isOpen: self.bank_isOpen)
                
                cell?.tapCallback = { (isOpen) in
                    self.bank_isOpen = isOpen
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                    self.view.endEditing(true)
                }
                
                return cell!
                
            } else if indexPath.row == 1 {
                
                //开户行名称
                self.openBankInput.clickButtonCallback = {
                    self.view.endEditing(true)
                    
                    let view = JSChoosePickView.animateWindowsAddSubView(dataArray: JSProinvceCodeManager.sharedInstance.bankModelArray)
                    view.reloadView(1)
                    
                    //点击回调
                    view.pickViewCallback = {
                        (provinceModel: JSProvinceModel?,cityModel: JSCityModel?,districtModel: JSDistrictModel?) in
                        
                        if provinceModel != nil {
                            MobClick.event("0200004")
                            self.infoModel.bankCode = (provinceModel?.provinceCode)!
                            self.openBankInput.inputTextField.text = provinceModel?.name
                        }
                    }
                }
                
                return self.openBankInput
            } else if indexPath.row == 2 {
                
                //银行卡号改变
                self.bankIdInput.changeCallback = { (text: String?) in
                    if text != nil {
                        self.infoModel.cardNumber = text!
                    }
                }
                self.bankIdInput.inputTextField.text = self.infoModel.cardNumber
                return self.bankIdInput
            } else {
                
                //开户行所在地
                self.openBankAdressInput.clickButtonCallback = {
                    
                    self.view.endEditing(true)
                    
                    let view = JSChoosePickView.animateWindowsAddSubView(dataArray: JSProinvceCodeManager.sharedInstance.provinceArray)
                    view.reloadView(2)
                    
                    //点击回调
                    view.pickViewCallback = {
                        (provinceModel: JSProvinceModel?,cityModel: JSCityModel?,districtModel: JSDistrictModel?) in
                        
                        if provinceModel != nil && cityModel != nil {
                            MobClick.event("0200006")
                            self.infoModel.OpenBankAddressCode = (cityModel?.cityCode)!
                            self.openBankAdressInput.inputTextField.text = "\((provinceModel?.name)!)\((cityModel?.name)!)"
                        }
                    }
                }
                
                return self.openBankAdressInput
            }
            
        } else {
            
            if indexPath.row == 0 {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSTitleTableViewCell") as! JSTitleTableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSTitleTableViewCell", owner: self, options: nil)?.first as! JSTitleTableViewCell!
                }
                cell?.tittleLabel.text = "支付密码设置"
                cell?.configureCell(isOpen: self.password_isOpen)
                cell?.middLabel.isHidden = false
                
                cell?.tapCallback = {(isOpen) in
                    self.password_isOpen = isOpen
                    self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
                    self.view.endEditing(true)
                }
                
                return cell!
                
            } else if indexPath.row == 1 {
                //密码改变
                self.passwordInput.changeCallback = { (text: String?) in
                    if text != nil {
                        self.infoModel.password = text!
                    }
                }
                return self.passwordInput
            } else {
                //确认密码改变
                self.conformPasswordInput.changeCallback = { (text: String?) in
                    if text != nil {
                        self.infoModel.confirmPassword = text!
                    }
                }
                return self.conformPasswordInput
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44.0
        }
        return 10.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 120.0
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?  {
        
        if section == 0 {
            return self.headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?  {
        if section == 2 {
            
            self.footerView.bottomTapCallback = { //底部协议地址点击回调
                let controller = LocationController()
                controller.model = HomeBannerModel.init(dict: ["location": PROTOCOL_URL + FuiouProtect as AnyObject,"title":"四川天府银行资金存管系统专用簿记服务协议" as AnyObject])
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return self.footerView
        }
        return UIView()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSOpenAccountFuiouViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
