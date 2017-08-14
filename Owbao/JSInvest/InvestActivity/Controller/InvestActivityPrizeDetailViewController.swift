//
//  InvestActivityPrizeDetailViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//  奖品的详情

import UIKit

class InvestActivityPrizeDetailViewController: BaseViewController {
    
    var productModel: ProductDetailsModel!       //产品数据model
    var productNameID: Int?         = 0          //产品ID
    @IBOutlet weak var indicatorView: UIView! //小图标
    @IBOutlet weak var flagView: UIView!  //用来显示的flag
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var appointmentButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    
    var cellImageSize: CGSize = CGSize(width: SCREEN_WIDTH, height: 1)
    
    //懒加载
    var headerView: InvestActivityPrizeDetailSecondHeaderView = {
        let view = Bundle.main.loadNibNamed("InvestActivityPrizeDetailSecondHeaderView", owner: nil, options: nil)?.last as? InvestActivityPrizeDetailSecondHeaderView
        return view!
    }()
    
    var cell_second: InvestActivityPrizeDetailTableViewCell = {
       
        let cell = Bundle.main.loadNibNamed("InvestActivityPrizeDetailTableViewCell", owner: nil, options: nil)?.last as? InvestActivityPrizeDetailTableViewCell
        
        return cell!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.layer.cornerRadius = 13
        self.indicatorView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.title = "礼品详情"
        self.appointmentButton.isEnabled = false //先不可用
        self.loadData()
    }
    
    //MARK: 请求数据
    override func loadData() {
        loadProductDetailData(UserModel.shareInstance.uid ?? 0, pid: self.productNameID!)
    }
    
    //MARK: 刷新产品信息
    func loadProductDetailData(_ uid:Int,
                               pid:Int) {
        view.showLoadingHud()
        
        ProductDetailsApi(Pid: pid, Uid: uid).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            self.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("确认投资页面的请求数据 \(resultDict)")
            self.productModel = ProductDetailsModel(dict: resultDict!)
            
            if self.productModel?.success ?? false {
                
                self.configureBottowButton()
                self.tableView?.reloadData()
                
            } else {
                
                if self.productModel?.errorCode ?? "" as String! == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                    return
                } else {
                    self.view.showTextHud("信息获取失败")
                    return
                }
            }
            
        }) {(request:YTKBaseRequest!) -> Void in
            self.view.hideHud()
            self.view.showTextHud("网络错误")
        }
    }
    
    //配置底部按钮
    func configureBottowButton() -> () {
        
        let str = "\((self.productModel.map?.prize?.amount)!)"
        let string = PD_NumDisplayStandard.numDisplayStandard(str, decimalPointType: 0, numVerification: false)
        let amountString = NSString(string: string!)
        let superString = NSString(string: "投资金额：\(amountString)元")
        let title = NSMutableAttributedString(string: superString as String)
        title.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:superString.range(of: amountString as String))
        
        self.appointmentButton.isEnabled = true //先不可用
        self.amountButton.setAttributedTitle(title, for: UIControlState())
        if self.productModel.map?.prize?.isNot == false { //未抢完
           self.flagView.isHidden = true
           self.appointmentButton.setTitle("投资免费领", for: UIControlState())
        } else { //抢完了
            self.flagView.isHidden = false
            self.appointmentButton.setTitle("我要预约", for: UIControlState())
        }
    }

    //预约
    @IBAction func bottomAction(_ sender: AnyObject) {
        
//        if self.productModel != nil {
//            
//            if self.productModel.map?.prize?.isNot == false { //未抢完
//                
//                let controller = InvestActivityConformController()
//                controller.productNameID = self.productNameID
//                controller.interestType = 2
//                controller.atid = 1
//                self.navigationController?.pushViewController(controller, animated: true)
//
//            } else { //抢完了
//                let controller = InvestActivityAppointmentViewController()
//                controller.id = self.productModel.map?.prize?.id
//                controller.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//        }
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
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "First") as? InvestActivityPrizeDetailTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvestActivityPrizeDetailTableViewCell", owner: nil, options: nil)?.first as? InvestActivityPrizeDetailTableViewCell
            }
            //设置cell
            if self.productModel != nil {
                cell?.configureCell_xibFirst((self.productModel.map?.prize?.h5ImgUrlH)!)
            }
            return cell!
            
        } else if indexPath.section == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "InvestActivityPrizeDetailSecondTableViewCell") as? InvestActivityPrizeDetailSecondTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("InvestActivityPrizeDetailSecondTableViewCell", owner: nil, options: nil)?.last as? InvestActivityPrizeDetailSecondTableViewCell
            }
            //设置cell
            if self.productModel != nil {
                cell?.configureCellWithPrizeModel((self.productModel.map?.prize)!)
            }
            
            return cell!
            
        } else {
//            var cell = tableView.dequeueReusableCellWithIdentifier("Second") as? InvestActivityPrizeDetailTableViewCell
//            if cell == nil {
//                cell = NSBundle.mainBundle().loadNibNamed("InvestActivityPrizeDetailTableViewCell", owner: nil, options: nil)?.last as? InvestActivityPrizeDetailTableViewCell
//            }
//            //设置cell
//            if self.productModel != nil {
//                cell!.configureCell_xibSecond((self.productModel.map?.prize?.h5DetailImgUrl)!)
//            }
//            
//            //回调
//            cell!.loadImageSuccessCallback = { (imageSize: CGSize) in
//                self.cellImageSize = imageSize
//                self.tableView.reloadData()
//            }
//            
//            return cell!
            
            //设置cell
            if self.productModel != nil {
                self.cell_second.configureCell_xibSecond((self.productModel.map?.prize?.h5DetailImgUrl)!)
            }
            
            //回调
            self.cell_second.loadImageSuccessCallback = { (imageSize: CGSize) in
                self.cellImageSize = imageSize
                self.tableView.reloadData()
            }
            
            return self.cell_second
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return InvestActivityPrizeDetailTableViewCell.cellHeightWithXib_first()
        } else if indexPath.section == 1 {
            return 70.0
        } else {
            return InvestActivityPrizeDetailTableViewCell.cellHeightWithXib_second(self.cellImageSize)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return self.headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
             return 0.01
        } else if section == 1 {
            return 5.0
        } else {
            return 50.0
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
        let nibNameOrNil = String?("InvestActivityPrizeDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
