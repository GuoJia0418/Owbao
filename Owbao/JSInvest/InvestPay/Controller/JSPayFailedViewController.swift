//
//  JSPayFailedViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSPayFailedViewController: BaseViewController,UIAlertViewDelegate {

    @IBOutlet weak var alertLabel: UILabel!     //支付失败
    @IBOutlet weak var failedLabel: UILabel!    //失败原因
    @IBOutlet weak var repayButton: UIButton!   //重新支付
    
    var payModel: JSPayModel? //预支付数据模型
    var paymentModel: InvestModel?  //支付后模型
    var detailModel: ProductDetailsModel! //传给支付成功界面
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repayButton.layer.cornerRadius = 5.0
        repayButton.layer.masksToBounds = true
        navigationItem.title = "支付失败"
        
        //刷新视图
        if paymentModel != nil {
            
            self.configureView(paymentModel?.errorMsg,errorCode:paymentModel?.errorCode)
        }
    }
    
    //MARK: - 重新支付按钮
    @IBAction func repayClick(_ sender: UIButton) {
        
//        if self.paymentModel != nil && self.payModel != nil {
//            
//            if self.paymentModel?.errorCode == "2001" { //三次支付失败，点击底部按钮，去主界面
//                
//               self.popType = .dismissGoHome
//                
//               let navigationController = self.navigationController as? RootNavigationController
//               navigationController?.popAction(true, popController: self)
//                
//            } else {
//                
//                self.view.showLoadingHud()
//                
//                //开始支付
//                let manager = JSInvestDetailPayManager()
//                manager.beginPayAction(self.payModel!)
//                
//                manager.investPayCallback  = {
//                    (model: InvestModel?,isConnect: Bool) in
//                    
//                    if isConnect {
//                        self.view.hideHud()
//                        if model != nil {
//                            
//                            if model?.success == false { //支付失败
//                                self.view.showTextHud("支付失败")
//                                self.configureView(model?.errorMsg,errorCode: model?.errorCode) //刷新view
//                                
//                            } else { //支付成功
//                                
//                                //更换数据(因为可能这次支付正好满标，到期时间会加一天)
//                                self.detailModel.map?.info?.expireDate = (model?.map?.expireDate)!
//                                
//                                let investSuccessVC = JSInvestSuccessViewController()
//                                investSuccessVC.detailModel = self.detailModel
//                                self.navigationController?.pushViewController(investSuccessVC, animated: true)
//                            }
//                        }
//                        
//                    } else {
//                        self.view.hideHud()
//                        self.view.showTextHud("网络错误")
//                    }
//                }
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //errorCode 必须是以下字典的key
    func configureView(_ errorMsg: String?,errorCode: String?) -> () {
        
        if errorCode != "" {
            
            //错误字典
            let dict = ["1001":"交易密码错误!","1002":"产品已募集完!","1003":"项目可投资金额不足!","1004":"小于起投金额!","1005":"非递增金额整数倍!","1006":"投资金额不能大于产品可投金额!","1007":"账户可用余额不足!","1008":"已投资过产品，不能投资新手产品!","1009":"用户不存在!","1010":"优惠券不可用!","2001":"连续输错三次，您的交易密码已被锁定！请一小时后再试"]
            
            if dict[errorCode!] != nil {
                self.failedLabel.text = dict[errorCode!]! //显示失败原因
            } else if errorMsg != "" {
                self.failedLabel.text = errorMsg
            }else{
                self.failedLabel.text = "支付失败"
            }
            
            if errorCode == "2001" {
                self.repayButton.setTitle("请稍后再试", for: UIControlState())
                return
            }
        }else{
        
            if errorMsg != ""
            {
                self.failedLabel.text = errorMsg
            }
            else
            {
                self.failedLabel.text = "支付失败"
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
        let nibNameOrNil = String?("JSPayFailedViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
