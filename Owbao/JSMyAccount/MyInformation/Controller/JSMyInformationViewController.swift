//
//  JSMyInformationViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInformationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    let DEFAULT_CELL_GRAY =  UIColorFromRGB(148, green: 148, blue: 148)
    @IBOutlet weak var listView: UITableView!
    
    var informationModel: MyInformationModel?            //账户信息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "安全中心"
        self.setupViews()
        self.loadData()
        //监听存管操作成功发送的通知
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - 设置views
    func setupViews()
    {
        listView.delegate = self
        listView.dataSource = self
        listView.backgroundColor = DEFAULT_BGCOLOR
//        listView.separatorStyle = .none
        listView.tableFooterView = createTableHeader()
    }

    //MARK: - 创建footerview
    func createTableHeader() -> UIView {
        let header = UIView(frame:CGRect( x: 0, y: 0, width: SCREEN_WIDTH, height: 100 * SCREEN_WIDTH / 320))
        header.backgroundColor = DEFAULT_GRAYCOLOR
        let exitButton = UIButton(frame:CGRect(x: 16, y: 30 * SCREEN_WIDTH / 320, width: SCREEN_WIDTH - 32, height: 40 * SCREEN_WIDTH / 320))
        exitButton.backgroundColor = DEFAULT_REDCOLOR
        exitButton.setTitle("安全退出", for: UIControlState())
        exitButton.setTitleColor(UIColor.white, for: UIControlState())
        exitButton.addTarget(self, action: #selector(JSMyInformationViewController.exitButtonClick), for: UIControlEvents.touchUpInside)
        exitButton.layer.cornerRadius = 5
        exitButton.clipsToBounds = true
        header.addSubview(exitButton)
        return header
        
    }
    
    //MARK: - 安全退出按钮事件
    func exitButtonClick() {
        
        self.showAlertView()
    }
    
    func showAlertView()
    {
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "您确认要退出吗?"
        alertView.addButton(withTitle: "取消")
        alertView.addButton(withTitle: "确定")
        alertView.show()
        
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            UserModel.shareInstance.logout()
            self.view.showTextHud("退出成功")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginOutInvest"), object: "nil")
            
            delay(1, block: { () -> () in
                RootNavigationController.goToHomeController(controller: self)
            })
        }
    }

    
    //MARK: - 下载数据
    override func loadData()
    {
        view.showLoadingHud()
        weak var weakSelf = self
        MyInformationApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let info = MyInformationModel(dict: resultDict!)
            print("输出安全中心的数据\(resultDict)")
            self.informationModel = info
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            if !info.success {
                weakSelf!.view.showTextHud("信息获取失败")
                return
            } else {
                
                UserModel.shareInstance.tpwdFlag = info.map?.tpwdFlag
                weakSelf!.informationModel = info
                weakSelf!.listView.reloadData()
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
        }
    }

    //MARK: -  tableView 的代理及数据
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 4
        }
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 * SCREEN_WIDTH / 320
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 * SCREEN_WIDTH / 320
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInformationFirstCell") as? JSInformationFirstCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInformationFirstCell", owner: self, options: nil)?.last as? JSInformationFirstCell
            }
            cell?.configureCell(informationModel: self.informationModel)
            return cell!
            
        } else if indexPath.section == 1 {
            
            var cell_repeat = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
            
            if cell_repeat == nil {
                cell_repeat = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "TableViewCell")
            }
            
            cell_repeat!.accessoryType = UITableViewCellAccessoryType.none
            cell_repeat!.selectionStyle = UITableViewCellSelectionStyle.none
            cell_repeat!.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell_repeat!.textLabel?.textColor = UIColor.lightGray
            cell_repeat!.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell_repeat!.detailTextLabel?.textColor = UIColor.darkGray
            
            if indexPath.row == 0 {
                cell_repeat!.textLabel?.text = "手机号"
                cell_repeat!.isUserInteractionEnabled = false
                
                if UserModel.shareInstance.mobilephone != nil {
                    cell_repeat!.detailTextLabel?.text = UserModel.shareInstance.mobilephone
                }
                
                return cell_repeat!
                
            } else if indexPath.row == 1 {
                
                cell_repeat!.textLabel?.text = "姓名"
                
                if self.informationModel?.map?.realVerify == 1 {
                    cell_repeat!.detailTextLabel?.text = self.informationModel?.map?.realName
                    cell_repeat!.isUserInteractionEnabled = false
                } else {
                    if self.informationModel?.map?.isFuiou == 1 {
                        cell_repeat!.detailTextLabel?.text = self.informationModel?.map?.realName
                        cell_repeat!.isUserInteractionEnabled = false
                    } else {
                        cell_repeat?.detailTextLabel?.text = "未认证"
                        cell_repeat?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    }
                }

                return cell_repeat!
                
            } else if indexPath.row == 2 {
                
                cell_repeat!.textLabel?.text = "身份证号"
                
                if self.informationModel?.map?.realVerify == 1 {
                    cell_repeat!.detailTextLabel?.text = self.informationModel?.map?.idCards
                    cell_repeat!.isUserInteractionEnabled = false
                } else {
                    if self.informationModel?.map?.isFuiou == 1 {
                        cell_repeat!.detailTextLabel?.text = self.informationModel?.map?.idCards
                        cell_repeat!.isUserInteractionEnabled = false
                    } else { //点击去开户
                        cell_repeat?.detailTextLabel?.text = "未认证"
                        cell_repeat?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    }
                }
                
                return cell_repeat!
                
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "MyInformationCell") as? MyInformationCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("MyInformationCell", owner: self, options: nil)?.last as? MyInformationCell
                }
                
                cell?.titleLabel.text = "银行卡"
                cell?.titleLabel.textColor = UIColor.lightGray
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                
                if self.informationModel?.map?.realVerify == 1 {
                    cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//                    cell?.isUserInteractionEnabled = false
                    
                    cell?.displayimageView.image = UIImage(named: "\((self.informationModel?.map?.bankId)!)")
                    cell?.rightLabel.isHidden = true
                } else {
                    if self.informationModel?.map?.isFuiou == 1 { //进入存管界面
                        cell?.accessoryType = UITableViewCellAccessoryType.none
                        cell?.isUserInteractionEnabled = false
                        cell?.displayimageView.image = UIImage(named: "\((self.informationModel?.map?.bankIdFuiou)!)")
                        cell?.rightLabel.isHidden = true
                        
                    } else { //去开通存管
                        cell?.isUserInteractionEnabled = true
                        cell?.rightLabel.isHidden = false
                        cell?.rightLabel.text = "未认证"
                    }
                }

                return cell!
            }
            
        } else {
            
            var cell_repeat = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
            
            if cell_repeat == nil {
                cell_repeat = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "TableViewCell")
            }
            
            cell_repeat!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell_repeat!.selectionStyle = UITableViewCellSelectionStyle.none
            cell_repeat!.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell_repeat!.textLabel?.textColor = UIColorFromRGB(144, green: 144, blue: 144)
            cell_repeat!.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell_repeat!.detailTextLabel?.textColor = UIColorFromRGB(68, green: 68, blue: 68)
            
            if indexPath.row == 0 {
                
                cell_repeat!.textLabel?.text = "重置登录密码"
                return cell_repeat!
                
            } else if indexPath.row == 1 {
                
                cell_repeat!.textLabel?.text = "重置平台交易密码"
                return cell_repeat!
                
            } else {
                
                //设置手势密码
                var cell = tableView.dequeueReusableCell(withIdentifier: "GesturesPasswordCell") as! GesturesPasswordCell!
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("GesturesPasswordCell", owner: self, options: nil)?.last as? GesturesPasswordCell
                }
                
                cell?.accessoryType = UITableViewCellAccessoryType.none
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.OpenGesturesSwitch.isOn = UserModel.shareInstance.isSetGestureUnlock == 1
                cell?.gestureOpen = {(isOn: Bool) -> () in
                    
                    if isOn == true {
                        let gestureView = GestureUnlockViewController()
                        gestureView.createView()
                        gestureView.state = GestureUnlockState.set
                        
                        gestureView.setSuc = {
                            (psw) in
                            Defaults.setValue(psw, forKeyPath: "GesturePassword")
                            UserModel.shareInstance.gestureUnlock = 1
                            UserModel.shareInstance.isSetGestureUnlock = 1
                            self.view.showTextHud("设置手势密码成功")
                        }
                        
                        gestureView.transitorilyNotSet = { //暂时不设置
                            //验证
                            UserModel.shareInstance.isSetGestureUnlock = 0
                            self.view.showTextHud("手势密码已关闭")
                            self.listView.reloadData()
                        }
                        
                        self.present(gestureView, animated: true, completion: nil)
                        
                    } else {
                        //验证
                        UserModel.shareInstance.isSetGestureUnlock = 0
                        self.view.showTextHud("手势密码已关闭")
                    }
                }
                
                return cell!
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //cell的跳转事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        
        if indexPath.section == 0 {
            
            if self.informationModel != nil {
                if self.informationModel?.map?.isFuiou == 0 { //未开通
                    let controller = JSOpenAccountFuiouViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                } else { //已经开通,去展示
                    
                    let accountDetailVC = JSSaveManagerAccountDetailViewController()
                    accountDetailVC.informationModel = self.informationModel
                    accountDetailVC.barType = .white
                    self.navigationController?.pushViewController(accountDetailVC, animated: true)
                }
            }
            
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 3
            {
                if self.informationModel != nil && self.informationModel?.map != nil {
                    if self.informationModel?.map?.realVerify == 1 {
                        let MyBankCard = MyBankCardController()
                        navigationController?.pushViewController(MyBankCard, animated: true)
                    } else {
                        if self.informationModel?.map?.isFuiou == 0 {
                            let controller = JSOpenAccountFuiouViewController()
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
                
            }else{
            
                if self.informationModel != nil && self.informationModel?.map != nil {
                    
                    if self.informationModel?.map?.isFuiou != 1 {
                        let controller = JSOpenAccountFuiouViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
            
        } else {
            
            if indexPath.row == 0 {
                
                let findVC = FindPasswordViewController()
                findVC.type = 1
                findVC.phoneNo = UserModel.shareInstance.mobilephone!
                self.navigationController?.pushViewController(findVC, animated: true)
                
            } else if indexPath.row == 1 {
                
                self.navigationController?.pushViewController(JYPassWordController(), animated: true)
                
            } else {
                
            }
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
        let nibNameOrNil = String?("JSMyInformationViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
}
