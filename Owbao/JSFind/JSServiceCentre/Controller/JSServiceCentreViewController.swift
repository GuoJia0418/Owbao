//
//  JSServiceCentreViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSServiceCentreViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var listView: UITableView!
    var dataModel = JSServiceCentreHotProblemModel(modelType: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "客服中心"
        self.barType = .red //红色
        self.view.backgroundColor = UIColorFromRGB(240, green: 240, blue: 240)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else if section == 1 {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            return UIView()
            
        } else if section == 1 {
            
            return Bundle.main.loadNibNamed("JSServiceCentreHeaderView", owner: self , options:  nil)![0] as? UIView
            
        } else {
            
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JSServiceCentreHeaderView") as? JSServiceCentreHeaderView
            if view == nil {
                
                view = Bundle.main.loadNibNamed("JSServiceCentreHeaderView", owner: self , options:  nil)![1] as? JSServiceCentreHeaderView
                view?.backgroundColor = UIColor.white
            }
            //配置模型
            view?.configureHeaderView(dataModel.modelArray[section - 2])
            //回调
            view?.tapCallBack = { (handleModel: JSServiceCentreHotProblemDetailModel) in
                self.dataModel.modelArray[section - 2] = handleModel
                self.listView.reloadData()
            }
            
            return view!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return  0.01
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section  == 0 {
            return 1
        } else if section == 1 {
            return 0
        } else {
            
            if dataModel.modelArray[section - 2] .isOpen {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + 1 + dataModel.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
           return JSServiceCentreTableViewCell.cellHeight()
        } else {
           return JSServiceCentreDisplayTitleTableViewCell.getHeigth(dataModel.modelArray[indexPath.section - 2 ].detailTitle)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSServiceCentreTableViewCell") as? JSServiceCentreTableViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSServiceCentreTableViewCell", owner: self, options: nil)![0] as? JSServiceCentreTableViewCell
            }
            
            cell?.tapCallback = {  (callbackType: ServiceCentreTapCallback) in
                print("点击index = \(callbackType)")
                //开始点击事件
                let controller = JSServiceCentreDisplayProblemController()
                controller.hidesBottomBarWhenPushed = true
                
                if callbackType == ServiceCentreTapCallback.certificationRegistration {
                    controller.titleString = "银行存管"
                    controller.type = 1
                } else if callbackType == ServiceCentreTapCallback.safeguard {
                    controller.titleString = "安全保障"
                    controller.type = 2
                } else if callbackType == ServiceCentreTapCallback.rechargeWithdrawals {
                    controller.titleString = "充值提现"
                    controller.type = 3
                } else if callbackType == ServiceCentreTapCallback.investWelfare {
                    controller.titleString = "投资福利"
                    controller.type = 4
                } else if callbackType == ServiceCentreTapCallback.productRecommend {
                    controller.titleString = "产品介绍"
                    controller.type = 5
                } else if callbackType == ServiceCentreTapCallback.otherProblem {
                    controller.titleString = "其他问题"
                    controller.type = 6
                }
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            //左边按钮点击回调
            cell?.leftButtonCallback = {
                let controller = JSSuggestionViewController()
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            //右边按钮点击回调
            cell?.rightButtonCallback = {
                let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,
                                                         viewTpye: .forth)
                //开始写标题
                popView.titleLabel_first.text = "拨打客服电话"
                popView.titleLabel_second.text = "400-671-7711"
                popView.titleLabel_second.textColor = UIColor.black
                
                popView.titleLabel_first.font = UIFont.systemFont(ofSize: 17)
                popView.titleLabel_second.font = UIFont.systemFont(ofSize: 19)
                
                popView.titleLabel_third.text = "热线服务时间：09:00~21:00"
                popView.titleLabel_forth.text = "周末节假日：09:00~18:00"
                popView.leftButton.setTitle("取消", for: UIControlState())
                popView.rightButton.setTitle("拨打", for: UIControlState())
                
                popView.conformCallback = {
                    UIApplication.shared.openURL(URL(string: "tel://4006717711")!)
                }
            }
            
            return cell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSServiceCentreDisplayTitleTableViewCell") as? JSServiceCentreDisplayTitleTableViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSServiceCentreDisplayTitleTableViewCell", owner: self, options: nil)![0] as? JSServiceCentreDisplayTitleTableViewCell
            }
            
            cell?.displayTitle.text = dataModel.modelArray[indexPath.section - 2 ].detailTitle
            
            return cell!
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
        let nibNameOrNil = String?("JSServiceCentreViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
