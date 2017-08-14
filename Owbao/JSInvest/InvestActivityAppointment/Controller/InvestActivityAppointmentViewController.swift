//
//  InvestActivityAppointmentViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/27.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityAppointmentViewController: BaseViewController {

    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var getPrizeModel: GetPrizeModel!            //产品数据model
    var productNameID: Int?         = 0          //产品ID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.title = "礼品预约"
        self.loadData()
        
        self.bottomButton.setBackgroundImage(Common.image(with: UIColor.lightGray), for: UIControlState.disabled)
        self.bottomButton.setBackgroundImage(Common.image(with: UIColor.red), for: UIControlState())
    }
    
    //MARK: 请求数据
    override func loadData() {
        loadProductDetailData(UserModel.shareInstance.uid ?? 0 ,Id: self.productNameID!)
    }
    
    //MARK: 刷新产品信息
    func loadProductDetailData(_ uid:Int,
                               Id:Int) {
        
        view.showLoadingHud()
        self.bottomButton.isEnabled = false
        
        GetPrizeApi(Uid: uid,Id: Id).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            self.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("确认投资页面的请求数据 \(resultDict)")
            self.getPrizeModel = GetPrizeModel(dictionary: resultDict!)
            self.bottomButton.isEnabled = true
            
//            if self.handleDownloadedData(self.getPrizeModel, isShowLoginCtrl: true) {
//                self.tableView?.reloadData()
//            }
            
            if self.getPrizeModel.success {
                
                self.tableView?.reloadData()
                
            } else {
                
                if self.getPrizeModel.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if self.getPrizeModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    if self.getPrizeModel.errorMsg != "" {
                        self.view.showTextHud(self.getPrizeModel.errorMsg)
                    } else {
                        self.view.showTextHud("报名失败")
                    }
                }
            }
            
        }) {(request:YTKBaseRequest!) -> Void in
            self.view.hideHud()
            self.view.showTextHud("网络错误")
            self.bottomButton.isEnabled = true
        }
    }
    
    //预约按钮
    @IBAction func appointmentAction(_ sender: AnyObject) {
        
        if self.getPrizeModel != nil && self.getPrizeModel.map != nil && self.getPrizeModel.map?.prize != nil {
            view.showLoadingHud()
            //开始预约
            InvestAppointmentApi(Uid: UserModel.shareInstance.uid ?? 0, Ppid: (self.getPrizeModel?.map?.prize?.id)!).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
                
                self.view.hideHud()
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("确认投资页面的请求数据 \(resultDict)")
                let model = InvestAppointmentModel(dictionary: resultDict!)
                
                //处理下载数据
//                if self.handleDownloadedData(model, isShowLoginCtrl: true) {
//                    self.view.showTextHud("预约成功")
//                }
                
                if model.success {
                    
                    self.view.showTextHud("预约成功")
                    
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
                
            }) {(request:YTKBaseRequest!) -> Void in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "First") as? InvestActivityAppointmentTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvestActivityAppointmentTableViewCell", owner: nil, options: nil)?.first as? InvestActivityAppointmentTableViewCell
            }
            //设置cell
            if self.getPrizeModel != nil && self.getPrizeModel.map != nil && self.getPrizeModel.map?.prize != nil
            {
                cell?.configureCellWithPrizeModel_firstCell((self.getPrizeModel.map?.prize)!)
            }

            return cell!
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "Second") as? InvestActivityAppointmentTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvestActivityAppointmentTableViewCell", owner: nil, options: nil)?.last as? InvestActivityAppointmentTableViewCell
            }
            //设置cell
            if self.getPrizeModel != nil && self.getPrizeModel.map != nil && self.getPrizeModel.map?.prize != nil {
                //算出收益
                let profitValue = (self.getPrizeModel.map?.prize?.amount)! * (((self.getPrizeModel.map?.prize?.rate)! + (self.getPrizeModel.map?.prize?.activityRate)!) / 360) * Double((self.getPrizeModel.map?.prize?.deadline)!) / 100
                
                cell?.configureCellWithPrizeModel_secondCell((self.getPrizeModel.map?.prize)!, profitNumber: profitValue)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return InvestActivityAppointmentTableViewCell.getCellHeight_firstCell()
        }  else {
            return InvestActivityAppointmentTableViewCell.getCellHeight_secondCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 5.0
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }
    

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("InvestActivityAppointmentViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
