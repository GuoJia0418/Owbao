//
//  JSPaySuccessViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSPaySuccessViewController: BaseViewController {

    @IBOutlet weak var successMsgLabel: UILabel!    //显示充值还是提现成功
    @IBOutlet weak var processingImgView: UIImageView!      //进度
    @IBOutlet weak var rechargeAmountLabel: UILabel!    //充值金额
    @IBOutlet weak var firstTimeLabel: UILabel!     //充值第一个时间
    @IBOutlet weak var secondStatusLabel: UILabel!     //第二个状态
    @IBOutlet weak var secondTimeLabel: UILabel!       //第二个时间
    @IBOutlet weak var thirdStatusLabel: UILabel!       //第三个状态
    @IBOutlet weak var thirdTimeLabel: UILabel!     //第三个时间
    @IBOutlet weak var backMyAccountButton: UIButton!   //返回账户
    @IBOutlet weak var investButton: UIButton!      //立即投资
    @IBOutlet weak var withdrawBackAccount: UIButton!       //提现返回我的账户
    
    var toFrom:Int = 0   //1:充值  2:提现
    var processStatus:Int = 0  //1:进行中  2:完成
    var withdrawAmount:Double = 0.00  //提现金额
    
    var rechargeModel:GoPayModel?                   //充值model
    var withdrawModel:WithdrawalsGoModel?           //提现model
    var isFromProduct:Int = 0                       //0:跳到投资列表  1:返回到原先的投资详情
    var detailModel: ProductDetailsModel?           //从投资详情传过来的数据
    var fuiouRechargeModel: JSRechargeModel?        //存管充值
    var fuiouRechargeAmount: String = ""            //存管充值金额
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildViews()
        self.popType = .reloadApp //刷新app
        self.barType = .red //红色
        
        if toFrom == 1
        {
            navigationItem.title = "充值成功"
            MobClick.event("0300011")
            backMyAccountButton.isHidden = false
            investButton.isHidden = false
            withdrawBackAccount.isHidden = true
            if self.fuiouRechargeModel != nil && self.fuiouRechargeModel?.map != nil
            {
                setupFuiouRecharge()
            }
        }
        else
        {
            navigationItem.title = "提现成功"
            MobClick.event("0500015")
            backMyAccountButton.isHidden = true
            investButton.isHidden = true
            withdrawBackAccount.isHidden = false
            //MARK: 接口待确定
            if self.withdrawModel != nil && self.withdrawModel!.map != nil
            {
                setupWithdraw()
            }
        }

    }
    override func leftBarButtonItemAction() {
        super.leftBarButtonItemAction()
        if toFrom != 1 {
            MobClick.event("0500017")
        }
    }
    //MARK: - 设置fuiou充值
    func setupFuiouRecharge()
    {
        successMsgLabel.text = processStatus == 1 ? "充值成功" : "充值成功"
        processingImgView.image = processStatus == 2 ? UIImage(named: "js_recharge_done") : UIImage(named: "js_recharge_processing")
        
        rechargeAmountLabel.text = "充值" + fuiouRechargeAmount + "元"
        firstTimeLabel.text = TimeStampToStringTypeSuccess((self.fuiouRechargeModel!.map!.payTime))
        
        secondStatusLabel.text = "充值成功"
        secondTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.fuiouRechargeModel!.map!.confirmTime)) : TimeStampToStringTypeSuccess((self.fuiouRechargeModel!.map!.confirmTime))
        
        thirdStatusLabel.text = "充值到账"
        thirdStatusLabel.textColor = processStatus == 2 ? DEFAULT_REDCOLOR : UIColorFromRGB(102, green: 102, blue: 102)
        thirdTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.fuiouRechargeModel!.map!.paySuccessTime)) : "预计将在10分钟之内到账，请耐心等待！"
    }
    
    //MARK: - 设置充值
    func setupRecharge()
    {
        successMsgLabel.text = processStatus == 1 ? "充值处理中" : "充值成功"
        processingImgView.image = processStatus == 2 ? UIImage(named: "js_recharge_done") : UIImage(named: "js_recharge_processing")
        
        rechargeAmountLabel.text = "充值" + PD_NumDisplayStandard.numDisplayStandard("\(self.rechargeModel!.map!.amount)", decimalPointType: 2, numVerification: false) + "元"
        firstTimeLabel.text = TimeStampToStringTypeSuccess((self.rechargeModel!.map!.payTime))
        
        secondStatusLabel.text = "第三方支付结果确认中"
        secondTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.rechargeModel!.map!.confirmTime)) : "预计5~10分钟到账"

        thirdStatusLabel.text = "充值成功"
        thirdStatusLabel.textColor = processStatus == 2 ? DEFAULT_REDCOLOR : UIColorFromRGB(102, green: 102, blue: 102)
        thirdTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.rechargeModel!.map!.paySuccessTime)) : ""
        
    }
    
    //MARK: - 设置提现
    func setupWithdraw()
    {
        successMsgLabel.text = processStatus == 2 ? "提现成功" : "提现申请成功"
        processingImgView.image = processStatus == 2 ? UIImage(named: "js_recharge_done") : UIImage(named: "js_recharge_processing")
        
        rechargeAmountLabel.text = "申请提现" + PD_NumDisplayStandard.numDisplayStandard("\(self.withdrawAmount)", decimalPointType: 2, numVerification: false) + "元"
        firstTimeLabel.text = TimeStampToStringTypeSuccess((self.withdrawModel!.map!.withdrawalsTime))
        
        secondStatusLabel.text = "银行处理中"
        secondTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.withdrawModel!.map!.confirmTime)) : "预计1个工作日到账，如遇节假日顺延"
        
        thirdStatusLabel.text = "提现成功"
        thirdStatusLabel.textColor = processStatus == 2 ? DEFAULT_REDCOLOR : UIColorFromRGB(102, green: 102, blue: 102)
        
        thirdTimeLabel.text = processStatus == 2 ? TimeStampToStringTypeSuccess((self.withdrawModel!.map!.withdrawalsSuccessTime)) : ""
        
    }
    
    
    func configModel(_ toFrom:Int,processStatus:Int,amount:String,firstTime:String,secondTime:String,thirdTime:String)
    {
        //MARK: - 接口处修改提现model
        successMsgLabel.text = toFrom == 1 ? "充值成功":"提现成功"
        processingImgView.image = processStatus == 2 ? UIImage(named: "js_recharge_done") : UIImage(named: "js_recharge_processing")
        
        rechargeAmountLabel.text = amount
        firstTimeLabel.text = firstTime
        
        secondStatusLabel.text = toFrom == 1 ? "第三方支付结果确认中" : "银行处理中"
        secondTimeLabel.text = secondTime
        
        thirdStatusLabel.text = toFrom == 1 ? "充值成功":"提现成功"
        thirdTimeLabel.text = thirdTime
        thirdTimeLabel.textColor = processStatus == 2 ? DEFAULT_REDCOLOR : UIColorFromRGB(102, green: 102, blue: 102)
    }
    
    //MARK: - 初始化数据
    func setupChildViews()
    {
        backMyAccountButton.layer.cornerRadius = 5.0
        backMyAccountButton.layer.masksToBounds = true
        backMyAccountButton.layer.borderColor = DEFAULT_GRAYCOLOR.cgColor
        backMyAccountButton.layer.borderWidth = 1.0
    
        investButton.layer.cornerRadius = 5.0
        investButton.layer.masksToBounds = true
        
        withdrawBackAccount.layer.cornerRadius = 5.0
        withdrawBackAccount.layer.masksToBounds = true
        withdrawBackAccount.layer.borderColor = DEFAULT_GRAYCOLOR.cgColor
        withdrawBackAccount.layer.borderWidth = 1.0
    }
    
    //MARK: - 返回我的账户
    @IBAction func backMyAccountClick(_ sender: UIButton) {
        if toFrom == 1 {
            MobClick.event("0300012")
        } else {
            MobClick.event("0500016")
        }
        RootNavigationController.goToMyAccount(controller: self)
    }
    
    //MARK: - 立即投资
    @IBAction func investClick(_ sender: UIButton) {
        MobClick.event("0300013")
        if detailModel != nil && detailModel?.map != nil && detailModel?.map?.info != nil
        {
            for vc in (self.navigationController?.viewControllers)! {
                print("打印出\(vc)==\(self.navigationController?.viewControllers[1])")
                print("输出的class == \(type(of: vc.self)))==\(vc.self)")
                if "\(type(of: vc.self))" == "JSInvestDetailViewController"
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        else
        {
            RootNavigationController.goToInvestList(controller: self)
        }
        
    }
    
    @IBAction func withdrawBackAccountClick(_ sender: UIButton) {
        RootNavigationController.goToMyAccount(controller: self)
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSPaySuccessViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
