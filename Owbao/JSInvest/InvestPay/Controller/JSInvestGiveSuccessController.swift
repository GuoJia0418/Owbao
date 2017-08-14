//
//  JSInvestGiveSuccessController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/8.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  该控制器集成
//  一、充话费类型（开始）界面
//  二、正常投即送类型（开始）界面
//  三、地址上传成功后显示界面
//  四、完善信息界面(1.完善充话费类型界面（开始）2.完善正常投即送类型界面（开始））

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum InvestGiveControllerType: Int {
    case phoneFareBegin = 0      //充话费类型（开始）
    case normalBegin = 1         //正常投即送类型（开始）
    case actionEnd = 2           //操作结束（该界面是前面2个界面的后续）
}

class JSInvestGiveSuccessController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var inputAmount: Double? = 0.0                  //用户输入金额
    var productNameID: Int? = 0                    //产品ID
    var investId: Int = 0 //投资id
    
    //完善信息保存成功回调
    var saveSuccessCallbackWithProfectInfoType: (() -> ())?
    
    private var detailModel: ProductDetailsModel!  //上个控制器传过来的数据
    private var controllerType: InvestGiveControllerType = .phoneFareBegin //默认是充话费类型（开始）
    private var addressModel: GetAddressDetailModel = GetAddressDetailModel(dict: ["address":"" as AnyObject,"name":"" as AnyObject,"phone":"" as AnyObject]) //之前设置过的地址
    private var isProfectInfo: Bool = false                                //是否进来完善个人信息（完善各人信息没有投资金额section，如果用户输入金额为0表示进来完善资料的）
    
    //MARK: - 懒加载
    lazy var firstCell: JSInvestSuccessFirstCell? = {
        let cell: JSInvestSuccessFirstCell = Bundle.main.loadNibNamed("JSInvestSuccessFirstCell", owner: self, options: nil)?.first as! JSInvestSuccessFirstCell
        cell.selectionStyle = .none
        return cell
    }()
    
    //输入cell
    lazy var inputPhoneNumCell: JSInvestGiveInputPhoneNumCell? = {
        let cell = Bundle.main.loadNibNamed("JSInvestGiveInputPhoneNumCell", owner: self, options: nil)?.first as! JSInvestGiveInputPhoneNumCell
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var bottomFooterView: JSInvestGiveFooterView? = { //底部footerView
        let view: JSInvestGiveFooterView =  Bundle.main.loadNibNamed("JSInvestGiveFooterView", owner: self, options: nil)?.first as! JSInvestGiveFooterView
        return view
    }()
    
    //操作结束时候的footerView
    lazy var actionEndFooterView: JSInvestGiveFooterView? = { //底部footerView
        let view: JSInvestGiveFooterView =  Bundle.main.loadNibNamed("JSInvestGiveFooterView", owner: self, options: nil)?[1] as! JSInvestGiveFooterView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "投资成功"
        MobClick.event("0400065")
        
        //设置控制器类型
        self.handleDetailModel()
        //        self.loadAddressSettedBefore()
        self.loadData()
    }
    
    override func leftBarButtonItemAction() {
        super.leftBarButtonItemAction()
        MobClick.event("0400068")
    }
    
    override func loadData() {
        if self.productNameID > 0 {
            self.refreshData(uid: UserModel.shareInstance.uid ?? 0,pid: self.productNameID!)
        }
    }
    
    //MARK：下载地址
    func loadAddressSettedBefore(prizeType: Int) -> () {
        
        GetAddressApi(Uid: UserModel.shareInstance.uid ?? 0,
                      PrizeType: prizeType).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("投资成功页面的请求数据 \(resultDict)")
            let model = GetAddressModel(dictionary: resultDict!)
                        
            if model.map?.jsMemberInfo != nil {
                self.addressModel = (model.map?.jsMemberInfo)!   //保存下载的地址数据数据
            }
            
            self.tableView.reloadData()
            
        }) { (request:YTKBaseRequest!) in
            self.view.showTextHud("网络错误")
        }
    }
    
    //MARK: 刷新数据
    func refreshData(uid: Int,pid: Int) {
        
        view.showLoadingHud()
        ProductDetailsApi(Pid: pid, Uid: uid).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("产品详情 -- 内容\(resultDict)===pid =\(pid)")
            let productDetail = ProductDetailsModel(dict: resultDict!)
            self.view.hideHud()
            
            if productDetail.success == false {
                
                if productDetail.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                    return
                } else {
                    
                    if productDetail.errorCode == "1001" {
                        self.view.showTextHud("产品不存在或已下架")
                        self.navigationController?.popViewController(animated: true)
                        return
                    } else {
                        self.view.showTextHud("信息获取失败")
                        return
                    }
                }
                
            } else {
                
                self.detailModel = ProductDetailsModel(dict: resultDict!)
                self.handleDetailModel() //配置控制器类型
                self.tableView.reloadData()
                
                //下载之前设置过的地址
                if self.detailModel.map?.prize != nil {
                    self.loadAddressSettedBefore(prizeType: (self.detailModel.map?.prize?.prizeType)!)
                }
            }
            
        }) { (request: YTKBaseRequest!) in
            self.view.hideHud()
            self.view.showTextHud("网络错误，请稍候重试")
        }
    }
    
    //处理模型数据
    func handleDetailModel() -> () {
        
        if self.detailModel != nil {
            
            if self.detailModel.map != nil {
                self.detailModel.map?.inputAmount = self.inputAmount!  //赋值
                
                if self.detailModel.map?.prize?.prizeType == 1 { //50元话费
                    self.controllerType = .phoneFareBegin
                } else { //其他正常的投即送
                    self.controllerType = .normalBegin
                }
                
                if self.inputAmount == 0.0 { //表示从投即送投资界面进来
                    self.isProfectInfo = true
                    self.navigationItem.title = "完善资料"
                }
            }
        }
    }
    
    /**
     *   上传待充值的手机号码到服务器
     *   phoneString: 待上传的手机号码
     *   callback: 上传结果回调
     */
    func updatePhoneNumberForGiveTelephoneFare(callback: ((_ isSuccess: Bool) -> ())?,phoneString: String) -> () {
        
        view.showLoadingHud()
        
        //开始上传地址或者修改地址
        SaveAddressApi(Uid: UserModel.shareInstance.uid ?? 0,
                       Name: "",
                       Phone: phoneString,
                       Address: "",
                       InvestId: self.investId).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
                        
                        self.view.hideHud()
                        let resultDict = request.responseJSONObject as? [String: AnyObject]
                        print("修改或者上传收货地址 == \(resultDict)")
                        
                        let model = SaveAddressModel(dictionary: resultDict!)
                    
                        self.view.hideHud()
                        
                        if model.success == true {
                            self.view.showTextHud("保存成功")
                            
                            //保存成功
                            if callback != nil {
                                callback!(true)
                            }
                            
                        } else {
                            
                            if model.errorCode == "9999" {
                                self.view.showTextHud("系统错误")
                            } else if model.errorCode == "9998" {
                                //弹出登录控制器
                                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                            } else {
                                if model.errorMsg != "" {
                                    self.view.showTextHud(model.errorMsg)
                                } else {
                                    self.view.showTextHud("保存失败")
                                }
                            }
                            
                            //保存失败
                            if callback != nil {
                                callback!(false)
                            }
                        }
                        
                       }) { (request: YTKBaseRequest!) in
                        self.view.hideHud()
                        self.view.showTextHud("网络错误")
        }
    }
    
    /**
     *   上传地址到服务器
     *   addressDetailModel: 待上传的手机号码
     *   callback: 上传结果回调
     */
    func updateAddress(callback: ((_ isSuccess: Bool) -> ())?,addressDetailModel: GetAddressDetailModel) -> () {
        
        view.showLoadingHud()
        
        var address = ""
        
        //新加的逻辑，表示从服务器获取到了address地址，用户没有修改过地址
        if addressDetailModel.address != "" {
            address = addressDetailModel.address
        } else { //用户修改过地址了
            address = "\((addressDetailModel.chooseLocationAddress))\((addressDetailModel.detailAddress))"
        }
        
        //开始上传地址或者修改地址
        SaveAddressApi(Uid: UserModel.shareInstance.uid ?? 0,
                       Name: addressDetailModel.name,
                       Phone: addressDetailModel.phone,
                       Address: address,
                       InvestId: self.investId).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
                        
                        self.view.hideHud()
                        let resultDict = request.responseJSONObject as? [String: AnyObject]
                        print("修改或者上传收货地址 == \(resultDict)")
                        
                        let model = SaveAddressModel(dictionary: resultDict!)
                        
                        if model.success == true {
                            self.view.showTextHud("保存成功")
                            
                            //保存成功
                            if callback != nil {
                                callback!(true)
                            }
                            
                        } else {
                            
                            if model.errorCode == "9999" {
                                self.view.showTextHud("系统错误")
                            } else if model.errorCode == "9998" {
                                //弹出登录控制器
                                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                            } else {
                                if model.errorMsg != "" {
                                    self.view.showTextHud(model.errorMsg)
                                } else {
                                    self.view.showTextHud("保存失败")
                                }
                            }
                            
                            //保存失败
                            if callback != nil {
                                callback!(false)
                            }
                        }
                        
                       }) { (request: YTKBaseRequest!) in
                        self.view.hideHud()
                        self.view.showTextHud("网络错误")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if self.isProfectInfo { //完善资料没有投资金额section
                return 0
            }
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.controllerType == .phoneFareBegin {
            
            return 3
            
        } else if self.controllerType == .normalBegin {
            
            return 3
            
        } else {
            
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getTableViewCellAutomatic(indexPath: indexPath)
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.getTableViewCellHeight(indexPath: indexPath) //获取tableView高度
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.controllerType == .phoneFareBegin {
            
            if section == 2 {
                return JSInvestGiveFooterView.footerViewHeight_xib_0()
            }
            
        } else if self.controllerType == .normalBegin {
            
            if section == 2 {
                return JSInvestGiveFooterView.footerViewHeight_xib_0()
            }
            
        } else {
            
            if section == 5 { //只有最后一个section有footerView
                return JSInvestGiveFooterView.footerViewHeight_xib_1()
            }
        }
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.controllerType == .phoneFareBegin {
            
            if section == 2 {
                
                //点击回调,提交手机号码到服务器
                weak var weakSelf = self
                self.bottomFooterView?.conformClickCallback = {
                    //提交资料到服务器
                    weakSelf!.updatePhoneNumberForGiveTelephoneFare(callback: {
                        (isSuccess: Bool) in
                        
                        if isSuccess == true {
                            
                            if weakSelf!.isProfectInfo { //完善资料界面
                                
                                weakSelf?.view.showTextHud("资料提交成功")
                                delay(1, block: {
                                    weakSelf!.navigationController?.popToRootViewController(animated: true)
                                })
                                
                            } else {
                                weakSelf!.controllerType = .actionEnd
                                weakSelf!.tableView.reloadData()
                            }
                            
                        } else {
                            weakSelf!.view.showTextHud("资料提交失败")
                        }
                        
                    },phoneString: (weakSelf!.inputPhoneNumCell?.inputPhoneNumTextFiled.text)!)
                }
                self.bottomFooterView?.configureFooterViewStatus(self.isOpenPhoneFareBegin(addressModel: self.addressModel))
                return self.bottomFooterView
            }
            
        } else if self.controllerType == .normalBegin {
            
            if section == 2 {
                
                weak var weakSelf = self
                //点击回调,提交手机号、收货人、收货地址到服务器
                self.bottomFooterView?.conformClickCallback = {
                    
                    //提交资料到服务器
                    weakSelf!.updateAddress(callback: {
                        (isSuccess: Bool) in
                        
                        if isSuccess == true {
                            
                            if weakSelf!.isProfectInfo { //完善资料界面
                                
                                weakSelf!.view.showTextHud("资料提交成功")
                                
                                //保存成功回调
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SaveSuccessCallbackWithProfectInfoType), object: nil, userInfo: ["investId": weakSelf!.investId])
                                
                                delay(1, block: {
                                    weakSelf!.navigationController?.popToRootViewController(animated: true)
                                })
                                
                            } else {
                                weakSelf!.controllerType = .actionEnd
                                weakSelf!.tableView.reloadData()
                            }
                            
                        } else {
                            weakSelf!.view.showTextHud("资料提交失败")
                        }
                        
                    },addressDetailModel: weakSelf!.addressModel)
                    
                }
                //配置普通投即送底部按钮是否可以点击
                self.bottomFooterView?.configureFooterViewStatus(self.isOpenNormalBegin(addressModel: self.addressModel))
                return self.bottomFooterView
            }
            
        } else {
            
            if section == 5 { //
                
                weak var weakSelf = self
                //左边按钮点击回调
                self.actionEndFooterView?.leftButtonCallback = {
                    MobClick.event("0400066")
                    let myInvestVC = JSMyInvestViewController()
                    weakSelf!.navigationController?.pushViewController(myInvestVC, animated: true)
                    
                }
                //右边按钮点击回调
                self.actionEndFooterView?.rightButtonCallback = {
                    MobClick.event("0400067")
                    RootNavigationController.goToInvestList(controller: weakSelf!)
                }
                
                return self.actionEndFooterView
            }
            
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.controllerType == .actionEnd { //操作结束后，可以去查看礼品详情
            
            if indexPath.section == 1 { //点击礼品信息
                let giftDetailVC = JSGiftDetailViewController()
                giftDetailVC.investId = self.investId
                giftDetailVC.pid = self.productNameID!
                self.navigationController?.pushViewController(giftDetailVC, animated: true)
            }
        }
    }
    
    //Mark: 获取tableViewCell根据类型获取
    func getTableViewCellAutomatic(indexPath: IndexPath) -> UITableViewCell {
        
        if self.controllerType == .phoneFareBegin  {   //充话费(开始类型)
            
            return self.getPhoneFareBeginTableViewCell(indexPath: indexPath)
            
        } else if self.controllerType == .normalBegin { //正常投即送类型（开始）
            
            return self.getNormalBeginTableViewCell(indexPath: indexPath)
            
        } else { //操作结束
            
            return self.getActionEndTableViewCell(indexPath: indexPath)
        }
    }
    
    //MARK: 获取充话费（开始类型）
    func getPhoneFareBeginTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.detailModel != nil {
                self.firstCell?.configureCell((self.detailModel.map?.inputAmount)!)
            }
            
            return self.firstCell!
            
        } else if indexPath.section == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveDisplayGiftCell") as? JSInvestGiveDisplayGiftCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestGiveDisplayGiftCell", owner: self, options: nil)?.first as? JSInvestGiveDisplayGiftCell
            }
            
            if self.detailModel != nil && self.detailModel.map != nil { //开始配置cell
                cell?.configureCell(self.detailModel.map?.prize)
            }
            
            return cell!
            
        } else {
            
            //输入回调
            weak var weakSelf = self
            self.inputPhoneNumCell!.textChangeInput = {
                (numberString: String) in
                //刷新底部按钮显示
                weakSelf!.reloadBottomFooterViewPhoneFareBegin(isOpen: numberString.CheckPhoneNo())
            }
            //配置cell
            self.inputPhoneNumCell?.configureCell(self.addressModel)
            return self.inputPhoneNumCell!
        }
    }
    
    //MARK: 获取正常投即送tableViewCell类型（开始）
    func getNormalBeginTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.detailModel != nil {
                self.firstCell?.configureCell((self.detailModel.map?.inputAmount)!)
            }
            
            return self.firstCell!
            
        } else if indexPath.section == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveDisplayGiftCell") as? JSInvestGiveDisplayGiftCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestGiveDisplayGiftCell", owner: self, options: nil)?.first as? JSInvestGiveDisplayGiftCell
            }
            cell?.configureCell(self.detailModel.map?.prize) //开始配置cell
            return cell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveUpdateAddressCell") as? JSInvestGiveUpdateAddressCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestGiveUpdateAddressCell", owner: self, options: nil)?.first as? JSInvestGiveUpdateAddressCell
            }
            //配置收货地址、收货人、手机号码
            cell?.configureCell(addressDetailModel: self.addressModel)
            
            //点击收货人、联系号码、收货地址回调
            cell?.clickCallback = {
                (type: ClickActionType) in
                
                if type == .receiverName { //收货人
                    
                    let controller = JSChangeInformationController()
                    controller.controllerType = .nameUpdate
                    controller.lastSaveString = self.addressModel.name
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                    weak var weakSelf = self
                    //保存成功回调
                    controller.saveActionSuccessCallback = { (controllerType: ChangeInformationType,saveString: String) in
                        
                        weakSelf!.addressModel.name = saveString
                        weakSelf!.tableView.reloadData()
                    }
                    
                } else if type == .phoneNumber {//手机号码
                    
                    let controller = JSChangeInformationController()
                    controller.controllerType = .phoneUpdate
                    controller.lastSaveString = self.addressModel.phone
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                    weak var weakSelf = self
                    //保存成功回调
                    controller.saveActionSuccessCallback = { (controllerType: ChangeInformationType,saveString: String) in
                        weakSelf!.addressModel.phone = saveString
                        weakSelf!.tableView.reloadData()
                    }
                    
                } else if type == .address { //收货人地址
                    let controller = JSChooseAddressController()
                    controller.chooseAddress = self.addressModel.chooseLocationAddress
                    controller.detailAddress = self.addressModel.detailAddress
                    controller.addressString = self.addressModel.address //后加的
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                    weak var weakSelf = self
                    //保存成功回调
                    controller.saveActionSuccessCallback = {(chooseAddressString: String,detailAddress: String) in
                        
                        weakSelf!.addressModel.detailAddress = detailAddress
                        weakSelf!.addressModel.chooseLocationAddress = chooseAddressString
                        weakSelf!.addressModel.address = ""   //这里把地址置为空
                        
                        weakSelf!.tableView.reloadData()
                    }
                }
            }
            
            return cell!
        }
    }
    
    //MARK: 获取操作结束类型
    func getActionEndTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.detailModel != nil {
                self.firstCell?.configureCell((self.detailModel.map?.inputAmount)!)
            }
            
            return self.firstCell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveActionEndCell") as? JSInvestGiveActionEndCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestGiveActionEndCell", owner: self, options: nil)?.first as? JSInvestGiveActionEndCell
            }
            
            //配置模型
            cell?.configureCellWithDetailModel(self.detailModel, indexPath: indexPath)
            return cell!
        }
    }
    
    //Mark: 获取tableViewCell高度根据类型获取
    func getTableViewCellHeight(indexPath: IndexPath) -> CGFloat {
        
        if self.controllerType == .phoneFareBegin {
            
            if indexPath.section == 0 {
                
                return JSInvestSuccessFirstCell.cellHeight()
                
            } else if indexPath.section == 1 {
                
                return JSInvestGiveDisplayGiftCell.cellHeight()
                
            } else {
                
                return JSInvestGiveInputPhoneNumCell.cellHeight()
            }
            
        } else if self.controllerType == .normalBegin {
            
            if indexPath.section == 0 {
                
                return JSInvestSuccessFirstCell.cellHeight()
                
            } else if indexPath.section == 1 {
                
                return JSInvestGiveDisplayGiftCell.cellHeight()
                
            } else {
                
                return JSInvestGiveUpdateAddressCell.cellHeight()
            }
            
        } else {
            
            if indexPath.section == 0 {
                return JSInvestGiveDisplayGiftCell.cellHeight()
            } else {
                return JSInvestGiveActionEndCell.cellHeight()
            }
        }
    }
    
    //MARK: 刷新底部footerView显示
    func reloadBottomFooterViewPhoneFareBegin(isOpen: Bool) -> () {
        self.bottomFooterView?.configureFooterViewStatus(isOpen)
    }
    
    func isOpenNormalBegin(addressModel: GetAddressDetailModel?) -> Bool {
        
        if addressModel != nil {
            
            if addressModel?.address != "" { //新加的逻辑，表示从服务器下载获取到了地址
                
                if addressModel?.name != "" &&
                    addressModel?.address != "" &&
                    addressModel?.phone != "" {
                    return true
                }
                
            } else { //表示用户修改过地址(修改过地址address会置为"")
                
                if addressModel?.name != "" &&
                    addressModel?.chooseLocationAddress != "" &&
                    addressModel?.phone != "" {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isOpenPhoneFareBegin(addressModel: GetAddressDetailModel?) -> Bool {
        if addressModel != nil {
            
            if addressModel?.phone != "" {
                return true
            }
        }
        
        return false
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvestGiveSuccessController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
