//
//  JSInvestDetailViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  该控制器集成新手标、正常的标、iPhone7活动标，投即送四种，只需要传productNameID过来，会根据数据自动判断控制器类型

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


enum InvestDetailControllerType: Int { //控制器类型
    case novice = 0       //新手标
    case normal = 1       //正常的标
    case iphone7 = 2      //iphone7活动标
    case investGive = 3   //投即送活动
}

class JSInvestDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    //****************  数据  *********//
    var productNameID: Int? = 0          //产品ID
    
    //从投资详情传过来，需要更换当前模型里的数据去显示
    var establish: Double = 0.00     //计息日期 也是成立日期
    var expireDate: Double = 0.00
    var productStatus: Int = 0       //产品状态  3：已还款
    
    fileprivate var productType: Int = 2              //产品详情
    fileprivate var model: DetailsListModle!          //项目介绍
    fileprivate var detailModel: ProductDetailsModel! //第一个tableView数据
    fileprivate var controllerType: InvestDetailControllerType = .normal //默认是普通标
    
    //****************  控件view  *********//
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var bottomBackgroundView: UIView! //底部按钮背景view
    @IBOutlet weak var exprerienceBackgroundView: UIView!   //显示体验金的背景view
    @IBOutlet weak var bottomBackgroundViewHeightConstains: NSLayoutConstraint! //底部按钮背景view高度约束
    
    @IBOutlet weak var buttonBottomIndicatorView: UIView! //按钮下面视图(显示富友视图)
    @IBOutlet weak var buttonBottomIndicatorHeightConstrans: NSLayoutConstraint! //按钮下面视图(显示富友视图)高度约束
    
    fileprivate var listView: UITableView!        //顶部控制器
    fileprivate var subTableView: UITableView!    //底部控制器
    fileprivate var showGroupIndex: Int = 0       //显示的分组下标 0为项目介绍 1为产品说明 2为投资记录
    fileprivate var lineView: UIView!             //黄线
    fileprivate var bottomWindow: UIWindow?                 //显示弹窗的window
    fileprivate var currentDisplayTableViewIndex: Int = 0    //当前显示第几个tableView，默认0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewControllers()
        setListViewRefreshFooter()
        setSubTableViewRefreshHeader()

        weak var weakSelf = self
        //MJRefresh刷新
        listView.mj_header = MJRefreshNormalHeader {
            if weakSelf!.productNameID > 0 {
                weakSelf!.refreshData(UserModel.shareInstance.uid ?? 0,pid: weakSelf!.productNameID!)
            }
        }
        
        listView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.barType = .red //红色的导航栏
    }
    
    deinit {
        print("内存释放")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if self.currentDisplayTableViewIndex == 0 {
            let naviController = self.navigationController as? RootNavigationController
            naviController?.setRedNavigationBar(self)
        } else {
            let naviController = self.navigationController as? RootNavigationController
            naviController?.setWhiteNavigationBar(self)
        }
        
        self.loadData()
    }
    
    //MARK: - 数据
    override func loadData() {
        
        if self.productNameID > 0 {
            self.refreshData(UserModel.shareInstance.uid ?? 0,pid: self.productNameID!)
        }
        
        if self.productNameID > 0 {
            self.refreshPicData(self.productNameID!, type: self.productType)
        }
    }
    
    //MARK: 刷新数据
    func refreshData(_ uid: Int,pid: Int) {
        
        view.showLoadingHud()
        
        let viewModel = JSInvestDetailViewModel()
        viewModel.startLoadingData(ProductDetailsApi(Pid: pid, Uid: uid), controller: self, modelName: "ProductDetailsModel", callback: { (baseModel: JSBaseModel) in
            
            let productDetail = baseModel as! ProductDetailsModel
            self.listView.mj_header.endRefreshing()
            
            if productDetail.success == false {
                
                if productDetail.errorCode == "1001"
                {
                    self.view.showTextHud("产品不存在或已下架")
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.view.showTextHud("信息获取失败")
                    return
                }
                
            } else {
                
                if self.detailModel != nil { //表示再次进入该界面
                    self.detailModel.map?.balanceFuiou = (productDetail.map?.balanceFuiou)! //刷新存管账户余额
                    self.detailModel.map?.isFuiou = (productDetail.map?.isFuiou)! //刷新用户是否开通存管
                    self.detailModel.map?.tpwdFlag = (productDetail.map?.tpwdFlag)! //刷新是否设置交易密码
                    self.detailModel.map?.realVerify = (productDetail.map?.realVerify)! //刷新是否认证
                    self.detailModel.map?.couponList = (productDetail.map?.couponList)! //刷新红包数组
                    self.detailModel.map?.isNewUser = (productDetail.map?.isNewUser)! //刷新是否是新用户
                    self.detailModel.map?.fuiouNewHandInvested = (productDetail.map?.fuiouNewHandInvested)! //刷新是否投资过存管新手标
                    
                } else {
                    self.detailModel = productDetail //第一次进入界面,保存模型
                }
                
                //下面的逻辑是根据获取的数据自动设置控制的类型
                if self.detailModel?.map?.info?.isPrize != 0 { //表示是iPhone7标
                    self.controllerType = .iphone7
                    
                } else if self.detailModel?.map?.prize != nil { //表示是投即送标
                    self.controllerType = .investGive
                    self.detailModel.map?.inputAmount = (self.detailModel.map?.prize?.amount)! //保存
                    
                } else if self.detailModel?.map?.info?.type == 3 { //表示是新手标
                    self.controllerType = .novice
                }
                
                //吧控制器类型保存进模型里，以便接下来一系列操作
                self.detailModel.map?.controllerType = self.controllerType
                
                //如果establish、expireDate字段存在，表示从投资详情过来的，需要刷新这两个字段
                if self.expireDate > 0.0 {
                    self.detailModel.map?.info?.expireDate = self.expireDate
                }
                
                if self.establish > 0.0 {
                    self.detailModel.map?.nowTime = self.establish
                }
                
                self.listView.reloadData()
                
                self.showSubmitButtonRightButton() //配置下面按钮显示状态
            }
            
        }) { (errorMsg: AnyObject) in
            self.view.showTextHud(errorMsg as! String)
            self.listView.mj_header.endRefreshing()
        }
    }
    
    //MARK: - 项目详情
    func refreshPicData(_ pid: Int,type: Int) {
    
        DetailsListApi(Pid: pid, Type: type).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("输出产品资料--图片内容\(resultDict)==\(pid)==\(type)")
            
            self.model = DetailsListModle(dict: resultDict!)
            self.subTableView.reloadData()

        }) { (request: YTKBaseRequest!) -> Void in
            self.view.showTextHud("网络错误，请稍候重试")
        }
    }

    //MARK: 设置底部button、button上view
    func showSubmitButtonRightButton() {
        //名字
        self.title = detailModel.map?.info?.fullName
        
        //设置协议新手标没有协议
        if self.productStatus != 3 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "协议", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonClick))
        }
        
        if detailModel.map?.info?.status != 5  {
            
            self.buyButton.isEnabled = false
            self.buyButton.backgroundColor = UIColorFromRGB(160, green: 160, blue: 160)
            
            if detailModel.map?.info?.status == 6 {
                self.buyButton.setTitle("抢完了", for: UIControlState())
            } else if detailModel.map?.info?.status == 7 {
                self.buyButton.setTitle("募集失败", for: UIControlState())
            } else if detailModel.map?.info?.status == 8 {
                self.buyButton.setTitle("待还款", for: UIControlState())
            } else if detailModel.map?.info?.status == 9 {
                self.buyButton.setTitle("已还款", for: UIControlState())
                
                if self.navigationItem.rightBarButtonItem != nil {
                    self.navigationItem.rightBarButtonItem = nil
                }
                
            } else {
                self.buyButton.setTitle("已结束", for: UIControlState())
                
                if self.navigationItem.rightBarButtonItem != nil {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
            
            self.setTableViewsFrame(constant: 90)
            _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //在下
            
        } else if detailModel.map?.info?.status == 5 {
            
            if UserModel.shareInstance.isLogin == 1 { //这里分登录和未登录两种状态
                self.buyButton.isEnabled = true
                self.buyButton.setTitle("立即抢购", for: UIControlState())
                
                //如果有100000注册体验金未使用，那么底部按钮显示
                if detailModel.map?.controllerType == .normal {
                    
                    if detailModel?.map?.isShowLabel  == true {
                        
                        _ = JSExperienceMoneyIndicatorView.creatIndicatorView(superView: self.exprerienceBackgroundView) //上
                        _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //下
                        self.setTableViewsFrame(constant: 105)
                        
                    } else {
                        _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //在下
                        self.setTableViewsFrame(constant: 90)
                    }
                    
                } else if detailModel.map?.controllerType == .novice {
                    
                    if detailModel.map?.isNewUser == 1 {  //新用户
                        
                        if detailModel.map?.fuiouNewHandInvested == 1 { //投过了
                            self.setTableViewsFrame(constant: 105)
                            
                            //创建indicator视图
                            let indicatorview = JSNoviceIndicatorView.creatIndicatorView(superView: self.exprerienceBackgroundView)
                            indicatorview.titleLabel.text = "您已投资新手标,每个用户仅可购买一次"
                            self.buyButton.setTitle("关注其他项目", for: UIControlState()) //点击后去投资列表
                            
                            _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //富友标识view下
                            
                        } else { //没有投过
                            _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //富友标识view下
                            self.setTableViewsFrame(constant: 90)
                        }
                        
                    } else { //不是新的用户
                        self.setTableViewsFrame(constant: 105)
                        
                        //创建indicator视图
                        let indicatorview = JSNoviceIndicatorView.creatIndicatorView(superView: self.exprerienceBackgroundView)
                        indicatorview.titleLabel.text = "您不满足新手标的投资条件"
                        self.buyButton.setTitle("关注其他项目", for: UIControlState()) //点击后去投资列表
                        
                        _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //富友标识view下
                    }
                    
                } else {
                    _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //富友标识view在上
                    self.setTableViewsFrame(constant: 90)
                }
                
            } else {
                self.buyButton.isEnabled = true
                _ = JSFuiouIndicatorView.creatIndicatorView(superView: self.buttonBottomIndicatorView) //富友标识view在上
                self.setTableViewsFrame(constant: 90)
            }
        }
    }
    
    //右部按钮点击事件
    func rightBarButtonClick() -> () {
        
        if controllerType == .normal {
            MobClick.event("0400006")
        } else if controllerType == .iphone7 {
            MobClick.event("0400032")
        } else if controllerType == .investGive {
            MobClick.event("0400051")
        }
        
        let controller = LocationController()
        controller.model = HomeBannerModel(dict: ["location": PROTOCOL_URL + LoanProtocol_Api as AnyObject,"title":"借款协议" as AnyObject])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //设置上下2个tableView的frame和底部按钮父视图的高度约束
    func setTableViewsFrame(constant: CGFloat) {
        
        if constant == 65 { //表示抢完了
            self.buttonBottomIndicatorHeightConstrans.constant = 10
        }
        
        self.bottomBackgroundViewHeightConstains.constant = constant
        self.listView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - constant)
        self.subTableView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - constant)
    }
    
    //MARK: 存管提示开户弹窗
    func gotoOpenCustodyAccount() {
        
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
            let controller = JSOpenAccountFuiouViewController()
            controller.detailModel = self.detailModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        //关闭弹窗
        custodyAccountView.closeBtnBlock = {
            self.bottomWindow?.isHidden = true
            self.bottomWindow = nil
        }
    }
    
    //MARK: 去存管充值
    func beginToRechargeFuiou() {
        MobClick.event("0300002")
        
        if controllerType == .normal{
            MobClick.event("0400018")
        } else if controllerType == .iphone7 {
            MobClick.event("0400040")
        } else if controllerType == .investGive {
            MobClick.event("0400059")
        }
        
        let rechargeVC = JSSaveRechargeViewController()
        rechargeVC.barType = .red
        rechargeVC.detailModel = self.detailModel
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    //MARK: - 立即抢购按钮事件
    @IBAction func buyClick(_ sender: UIButton) {
        
        if controllerType == .normal {
           MobClick.event("0400017")
        } else if controllerType == .iphone7 {
           MobClick.event("0400039")
        } else if controllerType == .investGive {
            MobClick.event("0400058")
        }

        //1.判断是否登录
        if UserModel.shareInstance.isLogin == 0 {
            //弹出登录控制器
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
            return
        }
        
        //2.判断是否开通账户了
        if self.detailModel != nil && self.detailModel.map != nil {
            if self.detailModel.map?.isFuiou == 0 { //没有开通
                self.gotoOpenCustodyAccount()
                return
            }
        }
        
        //1.新用户且投资了新手标 2.非新用户  都要去投资列表界面
        if (detailModel.map?.controllerType == .novice && detailModel.map?.isNewUser == 1 && detailModel.map?.fuiouNewHandInvested == 1) || (detailModel.map?.controllerType == .novice && detailModel.map?.isNewUser == 0 ) {
            
            RootNavigationController.goToInvestList(controller: self)
            return
        }
        
        //4.必须输入金额
        if self.detailModel.map?.inputAmount == 0 {
            self.view.showTextHud("请输入投资金额!")
            return
        }
        
        //输入金额不能超过最大限制
        if self.detailModel.map?.inputAmount > self.detailModel.map?.info?.maxAmount {
            self.view.showTextHud("资金额不能大于限投金额")
            return
        }

        //5.投资金额
        if self.detailModel.map?.inputAmount < (self.detailModel.map?.info?.leastaAmount)! {
            let leastaAmountStr = PD_NumDisplayStandard.numDisplayStandard(String((self.detailModel.map?.info?.leastaAmount)!), decimalPointType: 0, numVerification: false)
            self.view.showTextHud("投资金额最少为\((leastaAmountStr)!)元!")
            return
        }
        
        //6.输入金额不能超过项目可投金额
        if self.detailModel.map?.info?.surplusAmount < self.detailModel.map?.inputAmount {
            self.view.showTextHud("投资金额不能超过标剩余可投")
            return
        }

        //7.投资金额需为倍数
        if (Int((self.detailModel.map?.inputAmount)!) - Int((self.detailModel.map?.info?.leastaAmount)!)) % Int( (self.detailModel.map?.info?.increasAmount)!) > 0 {
            self.view.showTextHud("投资金额需为\(Int( (self.detailModel.map?.info?.increasAmount)!))的倍数!")
            return
        }
        
        //8.余额是否充足
        if (self.detailModel.map?.balanceFuiou)! < self.detailModel.map?.inputAmount {
            
            let view = JSChooseViewSencond.animateWindowsAddSubView(status: 0)
            view.titleLabel_1.text = "(账户余额：" + PD_NumDisplayStandard.numDisplayStandard("\((self.detailModel?.map?.balanceFuiou)!)", decimalPointType: 1, numVerification: false) + ")"
            
            view.rightBottomButtonCallback = { //继续提现
                //去充值界面
                self.beginToRechargeFuiou()
            }
            
            return
            
        } else {
            
            //表示有红包没有选择
            if JSPayModel.getFid(self.detailModel) == 0 && self.detailModel.map?.couponList.count > 0 && self.controllerType == .normal {
                
                let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,
                                                         viewTpye: .second)
                //开始写标题
                popView.titleLabel_first.text = "温馨提示"
                popView.titleLabel_first.textColor = UIColor.black
                popView.titleLabel_second.text = "您有\((self.detailModel.map?.couponList.count)!)张优惠券未使用，是否现在使用?"
                popView.leftButton.setTitle("暂不使用", for: UIControlState())
                popView.rightButton.setTitle("立即使用", for: UIControlState())
                
                if IS_PHONE_WIDTH_320 {
                    popView.titleLabel_first.font = UIFont.systemFont(ofSize: 17.0)
                    popView.titleLabel_second.font = UIFont.systemFont(ofSize: 15.0)
                    popView.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
                    popView.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
                }
                
                popView.conformCallback = {
                    MobClick.event("0400020")
                    self.displayChooseCounponView()
                }
                
                popView.leftCallback = {//进行下一步操作
                    MobClick.event("0400019")
                    if self.isSetPassword() {
                        self.beginPayWithBalancePaymentView()
                    }
                }
                
                return
                
            } else { //红包已经使用了，可以进行下一步
                
                if self.isSetPassword() {
                    self.beginPayWithBalancePaymentView()
                }
            }
        }
    }
    
    /** 
     * 弹出选择红包界面
     *
     */
    func displayChooseCounponView() {
        
        //有红包才能点击
        if (self.detailModel.map?.couponList.count)! > 0 {
            MobClick.event("0400012")
            //选优惠券
            let couponView = CouponListView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            couponView.selectCouponModel = self.detailModel.map?.selectCouponModel //传入上次选中的
            couponView.showCouponView(UIApplication.shared.keyWindow!)
            
            //从服务器下载红包模型数据
            couponView.loadDataFromServers(self.productNameID!, amount: Double((self.detailModel.map?.inputAmount)!))
            
            //选中红包的回调
            couponView.tapCallback = {
                (selectCouponModel: MyCouponsListModel) in
                //类型:1：返现券  2：加息券 3：体验金 4：翻倍券
                if selectCouponModel.type == 1{
                    MobClick.event("0400013")
                }else if selectCouponModel.type == 2{
                    MobClick.event("0400014")
                }else if selectCouponModel.type == 4{
                    MobClick.event("0400015")
                }
                self.detailModel.map!.selectCouponModel = selectCouponModel //保存选中的红包
                self.listView.reloadData() //刷新视图
            }
            
            //查看优惠券解释
            couponView.checkCallback = {
                let controller = JSCouponExplainViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    /** 
     * 弹出余额支付界面
     *
     */
    func beginPayWithBalancePaymentView() {
        
        let balancePayView = BalancePaymentView()
        balancePayView.controllerType = self.controllerType.rawValue
        balancePayView.showView(UIApplication.shared.keyWindow!)
        
        //显示余额
        balancePayView.accountBalanceLabel.text = "存管账户支付(账户余额:\((self.detailModel.map?.balanceFuiou)!))"
        balancePayView.payButton.setTitle("去支付", for: UIControlState())
        
        //点击回调
        balancePayView.tapActionCallback = {
            
            if self.controllerType == .normal {
                MobClick.event("0400021")
            } else if self.controllerType == .iphone7 {
                MobClick.event("0400041")
            } else if self.controllerType == .investGive {
                MobClick.event("0400060")
            }
            balancePayView.dismissView()
            //开始支付
            self.beginPayAction()
        }
    }
    
    /**
     *  判断是否设置过交易密码并去设置
     *  true设置过交易密码 false没有设置过
     */
    func isSetPassword() -> Bool {
        if self.detailModel.map?.tpwdFlag == false { //没有设置交易密码
            let setpwdView = JSSetTradePasswordView()
            setpwdView.showView(UIApplication.shared.keyWindow!)
            
            setpwdView.completeCallback = {
                (isSuccess: Bool,
                password: String) in
                setpwdView.dismissView()
                
                if isSuccess {  //设置成功后回调
                    self.invokePayInvestInterface(psWord: password, payAlertView: nil)
                }
            }
            return false
        } else {
            return true
        }
    }

    /** 
     * 跳出交易密码弹出窗,开始投资
     *
     */
    func beginPayAction() {
        //弹出输入密码视图
        let payAlertView = JSTradePasswordView()
        payAlertView.showView(UIApplication.shared.keyWindow!)
        payAlertView.investAmountLabel.text = "\((self.detailModel.map?.inputAmount)!)" //显示金额
        payAlertView.controllerType = self.controllerType.rawValue  //传过去是因为要做友盟统计
        
        //点击忘记密码回调
        payAlertView.forgetPassword = { ()->() in
            
            if self.controllerType == .normal {
                MobClick.event("0400023")
            } else if self.controllerType == .iphone7 {
                MobClick.event("0400043")
            } else if self.controllerType == .investGive {
                MobClick.event("0400062")
            }
            
            payAlertView.dismissView(animate: false)
            let forgetPasswordVC = JYPassWordController()
            self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
        }
        
        payAlertView.completeBlock = {(psWord: String) -> Void in
            if self.controllerType == .normal {
                MobClick.event("0400022")
            } else if self.controllerType == .iphone7 {
                MobClick.event("0400042")
            } else if self.controllerType == .investGive {
                MobClick.event("0400061")
            }
           
           self.invokePayInvestInterface(psWord: psWord, payAlertView: payAlertView) //调用支付接口
        }
    }
    
    /**
     * 去调用支付接口
     * psWord:交易密码 payAlertView: 密码输入视图
     * 
     */
    func invokePayInvestInterface(psWord: String,
                                  payAlertView: JSTradePasswordView?) {
        //开始支付
        //创建支付模型
        UIApplication.shared.keyWindow!.showLoadingHud()
        
        let payModel = JSPayModel(passWord: jm().sbjm(psWord), inputAmount: (self.detailModel.map?.inputAmount)!, productNameID: self.productNameID!, fid: JSPayModel.getFid(self.detailModel))
        
        //创建支付manager
        let manager = JSInvestDetailPayManager()
        manager.beginPayAction(payModel)
        
        //支付接口回调
        manager.investPayCallback = {
            (model: InvestModel?,isConnect: Bool) in
            
            if isConnect {
                UIApplication.shared.keyWindow!.hideHud()
                
                if model != nil {
                    
                    if model!.success == false { //支付失败需要特殊处理
                        
                        if model!.errorCode == "1001" {   //交易密码错误（特殊处理，当前界面显示）
                            
                            payAlertView?.displayErrorMessage("支付密码错误")
                            
                        } else if model!.errorCode == "2001" {
                            
                            payAlertView?.displayErrorMessage("连续输错三次，您的交易密码已被锁定！请一小时后再试")
                            
                        } else if model!.errorCode == "XTWH" {
                            payAlertView?.dismissView(animate: false)
                        } else {
                            
                            payAlertView?.dismissView(animate: false)
                            let failController = JSPayFailedViewController()
                            failController.payModel = payModel  //支付数据模型（用来重新支付）
                            failController.paymentModel = model //支付后的模型（显示错误信息）
                            failController.detailModel = self.detailModel  //用来支付成功后传给支付成功界面
                            self.navigationController?.pushViewController(failController, animated: true)
                        }
                        
                    } else { //支付成功
                        
                        //发送通知刷新列表
                        //刷新到期日期(因为可能这次支付正好满标，到期时间会加一天)
                        if (model?.map?.expireDate)! > 0.0 {
                            self.detailModel.map?.info?.expireDate = (model?.map?.expireDate)!
                        }
                        
                        //设置投资id
                        if model?.map?.investId > 0 {
                            self.detailModel.map?.investId = (model?.map?.investId)!
                        }
                        
                        if self.controllerType == .investGive { //投即送的成功界面
                            payAlertView?.dismissView(animate: false)
                            
                            let controller = JSInvestGiveSuccessController()
                            controller.inputAmount = self.detailModel.map?.inputAmount  //用户输入金额
                            controller.productNameID = self.productNameID   //商品id
                            controller.popType = .reloadApp //刷新app
                            controller.investId = (self.detailModel.map?.investId)!  //投资id
                            self.navigationController?.pushViewController(controller, animated: true)
                            
                        } else if self.controllerType == .novice {
                            
                            payAlertView?.dismissView(animate: false)
                            let vc = JSInvestSuccessViewController()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "newHandSuccess"), object: nil)
                            vc.detailModel = self.detailModel
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else { //非投即送标的成功界面
                            
                            payAlertView?.dismissView(animate: false)
                            let investSuccessVC = JSInvestSuccessViewController()
                            investSuccessVC.detailModel = self.detailModel
                            self.navigationController?.pushViewController(investSuccessVC, animated: true)
                        }
                    }
                }
                
            } else {
                UIApplication.shared.keyWindow!.hideHud()
                UIApplication.shared.keyWindow!.showTextHud("网络错误")
                payAlertView?.dismissView(animate: false)
            }
        }
    }
    
    //MARK: - UITableViewDelegate,UITableDataSource
    internal func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == listView {
            return 8
        }
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == listView {    //top的tableView
            
            if section == 1 {         
                
                return JSProductAcountCell.numberRowForCell(self.controllerType)
                
            } else if section == 3 {  //如果标不可投、控制器为新手标类型，不显示红包section
                
                return ProductDetailThirdCell.numberRowForCell(self.detailModel)
                
            } else if section == 4 {  //如果控制器是iPhone7标显示2个row，反之0个
                
               return JSIPhone7TableViewCell.numberRowForIPhone7Section(self.detailModel)
                
            } else if section == 5 {  //如果控制器是投即送标显示2个row，反之0个
                
                return JSInvestGiveTableViewCell.numberRowForInvestGiveSection(self.detailModel)
                
            } else if section == 6 { //如果控制器是新手标显示1个row，反之0
                
                return JSInvestNoviceIntroduceCell.numberRowForNoviceSection(self.detailModel)
            }

            return 1
            
        } else { //bottom的tableView
            
            if self.showGroupIndex == 0 { //0为项目信息
                return 6
            } else if self.showGroupIndex == 1 { //1为资金保障
                return 4
            } else { //2为投资记录
                
                if self.model?.map != nil {
                    return (self.model?.map?.investList.count)! + 1
                }
                
                return 0
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == listView {
            
            switch indexPath.section {
            case 0:
                return ProductDetailFirstCell.cellHeight()
            case 1:
                return JSProductAcountCell.cellHeight(self.detailModel)
            case 2:
                return ProductDetailSecondCell.cellHeight(self.detailModel)
            case 3:
                return ProductDetailThirdCell.cellHeight(self.detailModel)
            case 4:
                return JSIPhone7TableViewCell.cellHeight(self.detailModel)
            case 5:
                return JSInvestGiveTableViewCell.cellHeight(self.detailModel)
            case 6:
                return JSInvestNoviceIntroduceCell.cellHeight(self.detailModel)
            case 7:
                return ProductDetailAlertCell.cellHeight(self.detailModel) //为了显示和谐该cell需自适应高度
            default:
                return 0
            }
            
        } else {
            
            return self.getTableViewHeight(indexPath)
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == listView { //顶部listView
            
            return self.getListTableViewCell(indexPath, tableView: tableView)
            
        } else { //底部的tableView
            
            return self.getTableViewCell(indexPath, tableView: tableView, selectIndex: self.showGroupIndex)
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == listView {
            
            if indexPath.section == 3 {
                
                if self.detailModel != nil {
                    
                    //1.若未登录先登录
                    if UserModel.shareInstance.isLogin == 0 {
                        //弹出登录控制器
                        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                        return
                    }
                    
                    if self.detailModel.map?.inputAmount == 0 { //必须输入金额才能弹出优惠券列表
                        self.view.showTextHud("请输入投资金额!")
                        return
                    }
                    
                    //有红包才能点击
                    self.displayChooseCounponView()
                }
                
            } else if indexPath.section == 4 { //iPhone7活动标的点击cell
                
                if indexPath.row == 0 { //活动详情,HTML5界面
                    
                    MobClick.event("0400038")
                    let controller = LocationController()
                    controller.homeBtnIndex = 5
                    controller.linkURL = self.detailModel.map?.linkURL
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if indexPath.row == 1 { //中奖者信息
                    
                    if JSIPhone7TableViewCell.cellIsCanClick(self.detailModel) { //表示cell可以被点击
                        let prizePerson = WinningPersonController()
                        prizePerson.pid = self.productNameID!
                        self.navigationController?.pushViewController(prizePerson, animated: true)
                    }
                }
                
            } else if indexPath.section == 5 { //投即送活动标点击cell
                
                if indexPath.row == 0 { //活动详情
                    MobClick.event("0400052")
                    let controller = LocationController()
//                    controller.homeBtnIndex = 1
//                    controller.linkURL = (self.detailModel.map?.prize?.investSendUrl)!
//                    self.navigationController?.pushViewController(controller, animated: true)
                    
                    controller.model = HomeBannerModel(dict: ["location":(self.detailModel.map?.prize?.investSendUrl)! as AnyObject,"title":"活动详情" as AnyObject])
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if indexPath.row == 1 { //礼品详情
                    
                    MobClick.event("0400053")
                    let controller = InvestActivityPrizeDetailViewController()
                    controller.productNameID = self.productNameID
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            } else if indexPath.section == 6 { //新手标产品详情点击cell
                let controller = JSNoviceDetailViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == subTableView {
            return 50.0
        }
        return 0.00001
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == subTableView {
            
            weak var weakSelf = self
            self.selectItemHeadView?.tapCallback = { (index: Int) in
                weakSelf!.showGroupIndex = index
                weakSelf!.subTableView.reloadData()
            }
            
            self.selectItemHeadView?.configureView("投资记录\(self.getListString())")
            
            return self.selectItemHeadView
            
        } else {
            return UIView()
        }
    }

//********************************* 获取投资记录个数字符串 ***************//
    //MARK: 获取投资记录个数字符串
    func getListString() -> String {
        
        if self.model != nil {
            if self.model?.map?.investList.count > 0 {
                
                return "(\(self.getStandardNumber((self.model?.map?.investList.count)!)))"
            }
        }
        
        return ""
    }
    
    //例子：number < 100 返回"20",number > 100 ,返回"99+"
    func getStandardNumber(_ number: Int) -> String {
        
        if number < 100 && number > 0 {
            return "\(number)"
        } else if number >= 100 {
            return "99+"
        }
        return ""
    }
    
//********************************* 获取tableView代理需要的数据 ***************//
    //MARK: - 获取iPhone7、正常标、投即送标tableView高度
    func getTableViewHeight(_ indexPath: IndexPath) -> CGFloat {
        
        //显示的分组下标 0为项目信息 1为资金保障 2为投资记录
        if self.showGroupIndex == 0 {
            
            if indexPath.row == 0 {
                return ProductMessageCell.cellHeigth() //产品周期
            } else if indexPath.row == 1 { //企业介绍
                return EnterpriseInformationCell.cellHeight(self.detailModel?.map?.info?.introduce)
            } else if indexPath.row == 2 { //产品原理
                return JSProductDetailDisplayPictureCell.cellHeight(self.detailModel?.map?.info?.principleH5)
            } else if indexPath.row == 3 { //企业资料
                return ProductDetailAgreementCell.cellHeight(self.model,type: 0)
            } else if indexPath.row == 4 { //借款用途
                return EnterpriseInformationCell.cellHeight(self.detailModel?.map?.info?.borrower)
            } else { //委托合同
                return ProductDetailAgreementCell.cellHeight(self.model,type: 1)
            }
            
        } else if self.showGroupIndex == 1 {
            
            if indexPath.row == 0 {
                return EnterpriseInformationCell.cellHeight("还款方式")
            } else if indexPath.row == 1 { //还款保障
                return EnterpriseInformationCell.cellHeight(self.detailModel?.map?.info?.windMeasure)
            } else if indexPath.row == 2 {
                return EnterpriseInformationCell.cellHeight(self.detailModel?.map?.info?.repaySource)
            } else {
                return EnterpriseInformationCell.cellHeight("\(TimeStampToString((self.detailModel?.map?.info?.expireDate)!, isHMS: false))")
            }
            
        } else {
            
            return indexPath.row == 0 ? 45 : 60
        }
        
    }

    //MARK: - 获取listView里面的tableViewCell
    func getListTableViewCell(_ indexPath: IndexPath,
                              tableView: UITableView) -> UITableViewCell {
        
        if indexPath.section == 0 { //头部红色
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFirstCell") as! ProductDetailFirstCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ProductDetailFirstCell", owner: self, options: nil)?.first as! ProductDetailFirstCell!
            }
            
            cell?.configModel(self.detailModel)
            return cell!
            
        } else if indexPath.section == 1 { //项目总额，剩余可投
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSProductAcountCell") as! JSProductAcountCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSProductAcountCell", owner: self, options: nil)?.first as! JSProductAcountCell!
            }
            
            cell?.configModel(self.detailModel)
            return cell!
            
        } else if indexPath.section == 2 { //输入框
            weak var weakSelf = self
            
            //刷新cell,计算收益
            self.productDetailSecondCell!.configureCell(self.detailModel)
            
            //结束输入回调
            self.productDetailSecondCell!.endInput = {
                (abc: String) in
                
                if self.controllerType == .normal{
                    MobClick.event("0400011")
                }else if self.controllerType == .iphone7{
                    MobClick.event("0400037")
                }
                
                weakSelf!.detailModel.map?.inputAmount = (abc as NSString).doubleValue
                weakSelf!.listView.reloadData()
            }
            
            //开始输入回调
            self.productDetailSecondCell!.changeInput = {
                (abc: String) in
                
                //保存输入金额
                
                weakSelf!.detailModel.map?.inputAmount = (abc as NSString).doubleValue
                
                if weakSelf!.detailModel != nil { //表示用户输入金额不符合上次红包的最低使用金额
                    
                    if weakSelf!.detailModel.map?.selectCouponModel != nil {
                        
                        if Double((weakSelf!.detailModel.map?.selectCouponModel?.enableAmount)!) > weakSelf!.detailModel.map?.inputAmount {
                            weakSelf!.detailModel.map?.selectCouponModel = nil
                            weakSelf!.listView.reloadData()
                        }
                    }
                }
            }
            
            //新手标输入超过最大限制的回调
            self.productDetailSecondCell!.noviceExceedingMaxLimit = {(maxLimitString: String) in
                weakSelf!.view.showTextHud("输入金额不能大于\(maxLimitString)")
            }
            
            return self.productDetailSecondCell!
            
        } else if indexPath.section == 3 { //红包section
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailThirdCell") as! ProductDetailThirdCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ProductDetailThirdCell", owner: self, options: nil)?.first as! ProductDetailThirdCell!
            }
            
            //刷新cell,显示选择的红包
            if self.detailModel != nil && self.detailModel.map != nil {
                cell?.configureCell(self.detailModel, maxCoupon: (self.detailModel.map?.couponList.count)!)
            }
            
            return cell!
            
        } else if indexPath.section == 4 { //活动详情 + 中奖者信息
            
            if indexPath.row == 0 { // 活动详情
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSIPhone7TableViewCell_0") as! JSIPhone7TableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSIPhone7TableViewCell", owner: self, options: nil)?[0] as! JSIPhone7TableViewCell!
                }
                return cell!
                
            } else { //中奖者信息
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSIPhone7TableViewCell_0") as! JSIPhone7TableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSIPhone7TableViewCell", owner: self, options: nil)?[1] as! JSIPhone7TableViewCell!
                }
                cell?.configureCell_1(self.detailModel)
                return cell!
            }
            
        } else if indexPath.section == 5 { //投即送，需要显示的cell
            
            if indexPath.row == 0 { //活动详情
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveTableViewCell") as! JSInvestGiveTableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSInvestGiveTableViewCell", owner: self, options: nil)?[0] as! JSInvestGiveTableViewCell!
                }
                cell?.configureCell(indexPath.row)
                return cell!
                
            } else { //礼品详情
                
      
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestGiveTableViewCell") as! JSInvestGiveTableViewCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSInvestGiveTableViewCell", owner: self, options: nil)?[0] as! JSInvestGiveTableViewCell!
                }
                cell?.configureCell(indexPath.row)
                return cell!
            }
            
        } else if indexPath.section == 6 { //新手标需要显示一个cell
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestNoviceIntroduceCell") as! JSInvestNoviceIntroduceCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestNoviceIntroduceCell", owner: self, options: nil)?[0] as! JSInvestNoviceIntroduceCell!
            }
            cell?.configureCell(detailModel: self.detailModel)
            return cell!
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailAlertCell") as! ProductDetailAlertCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ProductDetailAlertCell", owner: self, options: nil)?.first as! ProductDetailAlertCell!
            }
            return cell!
        }
    }
    
    
    //MARK:- 获取普通标、iPhone7标、投即送标、新手标tableViewCell
    //selectIndex:表示选中的哪个按钮（0：项目信息、1：资金保障、2：投资记录）
    func getTableViewCell(_ indexPath: IndexPath,
                          tableView: UITableView,
                          selectIndex: Int) -> UITableViewCell {
        
        if selectIndex == 0 {
            
            if self.controllerType == .normal{
                MobClick.event("0400008")
            }else if self.controllerType == .iphone7{
                MobClick.event("0400034")
            }else if self.controllerType == .investGive{
                MobClick.event("0400055")
            }
            
            if indexPath.row == 0 { //产品周期
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "ProductMessageCell") as! ProductMessageCell!
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("ProductMessageCell", owner: self, options: nil)?.first as? ProductMessageCell
                }
                cell?.configureCell(self.detailModel)
                return cell!
                
            } else if indexPath.row == 1 { //产品介绍
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseInformationCell") as! EnterpriseInformationCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("EnterpriseInformationCell", owner: self, options: nil)?.first as? EnterpriseInformationCell
                }
                cell?.setupModel(self.detailModel?.map?.info?.introduce)
                cell?.titleLabel.text = "项目介绍"
                return cell!
                
            } else if indexPath.row == 2 { //产品原理
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSProductDetailDisplayPictureCell") as! JSProductDetailDisplayPictureCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSProductDetailDisplayPictureCell", owner: self, options: nil)?.first as? JSProductDetailDisplayPictureCell
                }
                cell?.configureCell(self.detailModel?.map?.info?.principleH5)
                return cell!
                
            } else if indexPath.row == 3 { //图片显示
                var cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailAgreementCell") as! ProductDetailAgreementCell!
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("ProductDetailAgreementCell", owner: self, options: nil)?.first as? ProductDetailAgreementCell
                }
                cell?.configureCell(self.model,type: 0)
                cell?.delegate = self //保存代理
                cell?.titleLabel.text = "原债方企业资料"
                return cell!
            } else if indexPath.row == 4 {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseInformationCell") as! EnterpriseInformationCell!
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("EnterpriseInformationCell", owner: self, options: nil)?.first as? EnterpriseInformationCell
                }
                cell?.setupModel(self.detailModel?.map?.info?.borrower)
                cell?.titleLabel.text = "借款用途"
                return cell!
                
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailAgreementCell") as! ProductDetailAgreementCell!
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("ProductDetailAgreementCell", owner: self, options: nil)?.first as? ProductDetailAgreementCell
                }
                cell?.configureCell(self.model,type: 1)
                
                cell?.delegate = self  //保存代理
                cell?.titleLabel.text = "第三方委托合同"
                return cell!
            }
            
        } else if selectIndex == 1 {
            if self.controllerType == .normal{
                MobClick.event("0400009")
            }else if self.controllerType == .iphone7{
                MobClick.event("0400035")
            }else if self.controllerType == .investGive{
                MobClick.event("0400056")
            }

            
            var cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseInformationCell") as! EnterpriseInformationCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("EnterpriseInformationCell", owner: self, options: nil)?.first as? EnterpriseInformationCell
            }
            
            if indexPath.row == 0 { //还款方式
                
                if self.detailModel != nil {
                    
                    var string = ""
                    if self.detailModel?.map?.info?.repayType == 1 {
                        string = "到期付息还本"
                    } else if self.detailModel?.map?.info?.repayType == 2 {
                        string = "每月付息到期还本"
                    }
                    
                    cell?.setupModel(string)
                    cell?.titleLabel.text = "还款方式"
                }
                
            } else if indexPath.row == 1 { //还款保障
                cell?.setupModel(self.detailModel?.map?.info?.windMeasure)
                cell?.titleLabel.text = "还款保障"
            } else if indexPath.row == 2 { //还款来源
                cell?.setupModel(self.detailModel?.map?.info?.repaySource)
                cell?.titleLabel.text = "还款来源"
            } else { //还款开始日期
                cell?.setupModel("\(TimeStampToString((self.detailModel?.map?.info?.expireDate)!, isHMS: false))")
                cell?.titleLabel.text = "还款开始日期"
            }
            return cell!
            
        } else {  //投资记录
            if self.controllerType == .normal{
                MobClick.event("0400010")
            }else if self.controllerType == .iphone7{
                MobClick.event("0400036")
            }else if self.controllerType == .investGive{
                MobClick.event("0400057")
            }
            
            if indexPath.row == 0 {
                
                var cell = tableView.cellForRow(at: indexPath) as? JSInvestmentRecordgCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSInvestmentRecordgCell", owner: self, options: nil)?[1] as? JSInvestmentRecordgCell
                }
                return cell!
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestmentRecordgCell") as! JSInvestmentRecordgCell!
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSInvestmentRecordgCell", owner: self, options: nil)?[0] as? JSInvestmentRecordgCell
                }
                
                if self.model?.map != nil {
                    cell?.configureCell(self.model?.map?.investList[indexPath.row - 1])
                    
                    if indexPath.row == self.model?.map?.investList.count {
                        cell?.lineBottomView.isHidden = true
                    }
                }
                
                return cell!
            }
        }
    }
    
    //MARK: 懒加载
    lazy var productDetailFirstCell:ProductDetailFirstCell? = {
        let cell:ProductDetailFirstCell = Bundle.main.loadNibNamed("ProductDetailFirstCell", owner: self, options: nil)?.first as! ProductDetailFirstCell!
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var productDetailSecondCell:ProductDetailSecondCell? = {
        let cell:ProductDetailSecondCell = Bundle.main.loadNibNamed("ProductDetailSecondCell", owner: self, options: nil)?.first as! ProductDetailSecondCell!
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var productDetailThirdCell:ProductDetailThirdCell? = {
        let cell:ProductDetailThirdCell = Bundle.main.loadNibNamed("ProductDetailThirdCell", owner: self, options: nil)?.first as! ProductDetailThirdCell!
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var productDetailAlertCell:ProductDetailAlertCell? = {
        let cell:ProductDetailAlertCell = Bundle.main.loadNibNamed("ProductDetailAlertCell", owner: self, options: nil)?.first as! ProductDetailAlertCell!
        cell.selectionStyle = .none
        return cell
    }()
    
    
    lazy var selectItemHeadView: JSSelectButtonHeadView? = {
        let view: JSSelectButtonHeadView = Bundle.main.loadNibNamed("JSSelectButtonHeadView", owner: self, options: nil)?.last as! JSSelectButtonHeadView!
        return view
    }()
    
    //MARK:-  初始化控件
    func setupChildViewControllers() {
        self.view.backgroundColor = DEFAULT_BGCOLOR
        //底层scrollView必须scrollEnabled = NO
        bgScrollView!.isScrollEnabled = false
        bgScrollView.backgroundColor = DEFAULT_BGCOLOR
        bgScrollView!.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 2)
        
        listView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 65), style: .plain)
        listView?.tableFooterView = UIView()
        listView?.separatorStyle = .none
        listView.backgroundColor = DEFAULT_BGCOLOR
        listView?.dataSource = self
        listView?.delegate = self
        
        subTableView = UITableView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 65), style: .plain)
        subTableView?.tableFooterView = UIView()
        subTableView?.separatorStyle = .none
        subTableView.backgroundColor = DEFAULT_BGCOLOR
        subTableView?.delegate = self
        subTableView?.dataSource = self
        
        self.bgScrollView?.addSubview(listView!)
        self.bgScrollView?.addSubview(subTableView!)
        
        buyButton.layer.cornerRadius = 5
        buyButton.layer.masksToBounds = true
        
        if self.controllerType == .novice { //新手专项标
            self.title = "新手专享标"
        }
    }
    
    //MARK: - 设置Footer & Header
    func setListViewRefreshFooter() {
        weak var weakSelf = self
        let refreshFooter: MJRefreshBackNormalFooter = MJRefreshBackNormalFooter {
            if weakSelf?.controllerType == .normal{
                MobClick.event("0400007")
            }else if weakSelf?.controllerType == .iphone7{
                MobClick.event("0400033")
            }else if weakSelf?.controllerType == .investGive{
                MobClick.event("0400054")
            }
            
            weakSelf?.bgScrollView?.scrollRectToVisible(CGRect(x: 0, y: (weakSelf!.subTableView?.y)! - 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), animated: true)
            weakSelf?.listView?.mj_footer.endRefreshing()
            weakSelf?.subTableView?.reloadData()
 
            let naviController = weakSelf!.navigationController as? RootNavigationController
            naviController?.setWhiteNavigationBar(weakSelf!)
            weakSelf!.currentDisplayTableViewIndex = 1
            
        }
        //        refreshFooter.arrowView.image = nil
        refreshFooter.setTitle("向上滑动 查看详情", for:.idle)  /** 普通闲置状态 */
        refreshFooter.setTitle("释放到达详情页", for: .pulling)
        refreshFooter.setTitle("释放到达详情页", for: .refreshing)
        refreshFooter.setTitle("释放到达详情页", for: .willRefresh)
        refreshFooter.setTitle("向上滑动 查看详情", for: .noMoreData)
        self.listView?.mj_footer = refreshFooter
    }
    
    func setSubTableViewRefreshHeader() {
        
        weak var weakSelf = self
        let refreshHeader:MJRefreshNormalHeader = MJRefreshNormalHeader {
            weakSelf?.bgScrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), animated: true)
            weakSelf?.subTableView?.mj_header.endRefreshing()
            
            let naviController = weakSelf!.navigationController as? RootNavigationController
            naviController?.setRedNavigationBar(weakSelf!)
            weakSelf!.currentDisplayTableViewIndex = 0
        }
        
        refreshHeader.lastUpdatedTimeLabel.isHidden = true
        refreshHeader.setTitle("下拉返回详情首页", for:.idle)  /** 普通闲置状态 */
        refreshHeader.setTitle("释放返回详情首页", for: .pulling)
        refreshHeader.setTitle("释放返回详情首页", for: .refreshing)
        refreshHeader.setTitle("释放返回详情首页", for: .willRefresh)
        refreshHeader.setTitle("下拉返回详情首页", for: .noMoreData)
        self.subTableView?.mj_header = refreshHeader
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvestDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
