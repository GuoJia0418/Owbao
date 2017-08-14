//
//  ExperienceInvestViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  体验标详情界面

import UIKit

class ExperienceInvestViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    var bottomWindow: UIWindow?              //显示弹窗的window
    
    fileprivate var exprienceModel: ExperienceInvestModel?  //体验标详情模型
    var isFromAuthentication: Int = 0                   //来自信息验证
    fileprivate var informationModel: MyInformationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "体验标"
        
        if isFromAuthentication == 1 {
            
            self.popType = .reloadApp
        }
        
        self.bottomButton.layer.cornerRadius = 3
        self.bottomButton.layer.masksToBounds = true
        
        //监听存管操作成功发送的通知
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUserInfo()
    }
    
    override func loadData() {
        self.loadDataFromServer()
    }
    
    //MARK: - 连接API,获取用户个人信息
    func loadUserInfo(){
        weak var weakSelf = self
        print("获取用户个人信息= \(UserModel.shareInstance.uid)")
        MyInformationApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let myInfo = MyInformationModel(dict: resultDict!)
            self.informationModel = myInfo
            
            if myInfo.success {
                UserModel.shareInstance.realName = myInfo.map?.realName
                UserModel.shareInstance.bankId = myInfo.map?.bankId
                UserModel.shareInstance.bankName = myInfo.map?.bankName
                UserModel.shareInstance.realVerify = myInfo.map?.realVerify
                UserModel.shareInstance.tpwdFlag = myInfo.map?.tpwdFlag
                weakSelf?.loadData()
                
            } else if myInfo.errorCode == "9998"{
                //弹出登录控制器
                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
            } else {
                weakSelf!.view.showTextHud("信息获取失败")
            }
            
        }) {(request: YTKBaseRequest!) -> Void in
            weakSelf!.view.showTextHud("网络错误")
        }
    }
    
    //下载数据
    func loadDataFromServer() -> () {
        self.view.showLoadingHud()
        
        ExperienceInvestApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("可以的 ---- : \(resultDict)")
            
            let model = ExperienceInvestModel(dictionary: resultDict!)
            self.exprienceModel = model
            
            self.view.hideHud()
            //预处理数据
//            if self.handleDownloadedData(model, isShowLoginCtrl: true) {
//                self.tableView.reloadData()
//            }
            
            if model.success {
                
                self.tableView.reloadData()
                
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
                        self.view.showTextHud("发生了未知错误")
                    }
                }
            }
            

        }) {(request: YTKBaseRequest!) -> Void in
            self.view.showTextHud("网络错误")
            self.view.hideHud()
        }
    }
    
    //MARK: - 存管,提示开户弹窗
    func gotoOpenCustodyAccount() {
        
//        let custodyAccountView: JSIndicateDespositoryInvestPopView = Bundle.main.loadNibNamed("JSIndicateDespositoryInvestPopView", owner: self, options:nil)?.first as! JSIndicateDespositoryInvestPopView
//        custodyAccountView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//        custodyAccountView.isUserInteractionEnabled = true
//        
//        let wd = UIWindow(frame: UIScreen.main.bounds)
//        wd.windowLevel = UIWindowLevelAlert
//        wd.addSubview(custodyAccountView)
//        wd.makeKeyAndVisible()
//        
//        self.bottomWindow = wd
        
        let custodyAccountView: JSIndicateDepositoryPopView = Bundle.main.loadNibNamed("JSIndicateDepositoryPopView", owner: self, options:nil)?.first as! JSIndicateDepositoryPopView
        custodyAccountView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        custodyAccountView.isUserInteractionEnabled = true
        
        let wd = UIWindow(frame: UIScreen.main.bounds)
        wd.windowLevel = UIWindowLevelAlert
        wd.addSubview(custodyAccountView)
        wd.makeKeyAndVisible()
        
        self.bottomWindow = wd
        
        //立即开通
        custodyAccountView.openCustodyAccountBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
            self.openCustodyAccount()
        }
        
        //关闭弹窗
        custodyAccountView.closeBtnBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
        }
    }
    
    //MARK: 存管开户
    func openCustodyAccount() {
        let controller = JSOpenAccountFuiouViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func bottomButtonAction(_ sender: AnyObject) {
        
        if self.exprienceModel == nil {
            self.view.showTextHud("体验标数据下载失败")
            return
        }
        
        if self.exprienceModel?.map == nil {
            self.view.showTextHud("体验标数据下载失败")
            return
        }
        
        if self.exprienceModel?.map?.info == nil {
            self.view.showTextHud("体验标数据下载失败")
            return
        }
        
        if self.informationModel != nil && self.informationModel?.map != nil {
            
            if self.informationModel?.map?.isFuiou != 1 { //去开户
                self.gotoOpenCustodyAccount()
                return
            }
        }

        if self.exprienceModel?.map?.experienceAmount == nil {
            self.view.showTextHud("当前无可用体验金")
            return
        }
        
        let pushView = ExperienceInvestPopDisplayView.animateWindowsAddSubView()
        
        if self.exprienceModel != nil {
            if self.exprienceModel?.map != nil {
                
                if self.exprienceModel?.map?.experienceAmount != nil {
                    pushView.configureViewWithExperienceAmount((self.exprienceModel?.map?.experienceAmount?.experAmount)!)
                }
            }
        }
        
        //投资体验标
        pushView.conformButtonCallback = {
            
            if self.exprienceModel == nil {
                self.view.showTextHud("体验标数据下载失败")
                return;
            }
            
            if self.exprienceModel?.map == nil {
                self.view.showTextHud("体验标数据下载失败")
                return;
            }
            
            if self.exprienceModel?.map?.info == nil {
                self.view.showTextHud("体验标数据下载失败")
                return;
            }
            
            if self.exprienceModel?.map?.experienceAmount == nil {
                self.view.showTextHud("当前无可用体验金")
                return;
            }
            
            //投资体验标
            ExperienceInvestingApi(Uid: UserModel.shareInstance.uid ?? 0,Ids: (self.exprienceModel?.map?.experienceAmount?.ids)!,Pid: (self.exprienceModel?.map?.info!.id)!).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
                
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("可以的 ---- : \(resultDict)")
                
                let model = ExperienceInvestingModel(dictionary: resultDict!)
                //隐藏
                ExperienceInvestPopDisplayView.animateRemoveFromSuperView(pushView)
                
                if model.success == false { //失败
                    
                    //处理数据模型
                    if model.errorCode == "1003" {
                        self.view.showTextHud("体验标不存在")
                        return
                    } else if model.errorCode == "1004" {
                        self.view.showTextHud("体验标已关闭")
                        return
                    } else if model.errorCode == "1005" {
                        self.view.showTextHud("系统繁忙")
                        return
                    } else if model.errorCode == "9999" {
                        self.view.showTextHud("系统错误")
                        return
                    } else if model.errorCode == "9998" {
                        JSLoginViewController.presentLoginControllerDismissGoHomeType(self) //弹出登录控制器
                        return
                    } else {
                        
                        if model.errorCode != "" {
                            
                            if model.errorCode == "XTWH" {
                                SystemUpdateViewController.presentSystemUpdateController("")//开始弹出维护页
                            } else {
                                
                                let dict = ["1003":"体验标不存在","1004":"体验标已关闭","1005":"系统繁忙"]
                                let msg = dict[model.errorCode]
                                
                                if msg != nil {
                                    self.view.showTextHud(msg!)
                                }
                            }
                            
                        } else {
                            
                            if model.errorMsg != ""{
                                self.view.showTextHud(model.errorMsg)
                            }
                            else{
                                self.view.showTextHud("投资失败")
                            }
                        }
                    }
                    
                } else { //成功
                    let controller = ExperienceInestSuccessController()
                    controller.investingModel = model //赋值
                    controller.exprienceModel = self.exprienceModel
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }) {(request: YTKBaseRequest!) -> Void in
                self.view.showTextHud("网络错误")
                //隐藏
                ExperienceInvestPopDisplayView.animateRemoveFromSuperView(pushView)
            }
        }
    }
    
    // MARK: - UITableView / UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceInvestTableViewCell") as? ExperienceInvestTableViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ExperienceInvestTableViewCell", owner: nil, options: nil)?.first as? ExperienceInvestTableViewCell
            }
            
            //根据模型设置数据
            if self.exprienceModel != nil {
                if self.exprienceModel?.map != nil {
                    cell?.configureCellWithData((self.exprienceModel?.map)!)
                }
            }
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceInvestTableViewCell") as? ExperienceInvestTableViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ExperienceInvestTableViewCell", owner: nil, options: nil)?.last as? ExperienceInvestTableViewCell
            }
            cell?.configureCellWithModel(ExperienceDictionaryModel())
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return ExperienceInvestTableViewCell.cellHeight_firstXib()
        } else {
            return ExperienceInvestTableViewCell.cellHeight_secondXib(ExperienceDictionaryModel())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("ExperienceInvestViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
