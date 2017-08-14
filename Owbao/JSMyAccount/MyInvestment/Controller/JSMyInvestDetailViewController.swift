//
//  JSMyInvestDetailViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMyInvestDetailViewController: BaseTableViewController,UITableViewDataSource,UITableViewDelegate {

    var detailModel: MyInvestRowsModel?   //投资详情
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        self.refreshView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadModel(notification:)), name: NSNotification.Name(rawValue: SaveSuccessCallbackWithProfectInfoType), object: nil)
    }
    
    //接受通知
    func reloadModel(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let investId = userInfo?["investId"] as? Int
        
        if investId == detailModel?.id {
            detailModel?.isPerfect = 1
            self.listView.reloadData()
        }
    }
    
    override func createView() {
        super.createView()
        navigationItem.title = "投资详情"
        listView.isHidden = false
        listView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 37 - 64 - 30 * SCREEN_WIDTH / 320)
        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.dataSource = self
        listView.delegate = self
        listView.separatorStyle = .singleLine

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        footerView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = footerView
        
        //新手标 体验标 是5
        if detailModel!.type == 1 {
            if detailModel!.deadline == 1 {
               self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            } else {
                if detailModel?.productStatus == 3 { //表示已经回款
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "协议", style: .plain, target: self, action: #selector(rightBarButtonClick))
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                } else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "协议", style: .plain, target: self, action: #selector(rightBarButtonClick))
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            
        } else if detailModel!.type == 5 { //体验标要隐藏
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {
            
            if detailModel?.productStatus == 3 { //表示已经回款
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "协议", style: .plain, target: self, action: #selector(rightBarButtonClick))
//                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "协议", style: .plain, target: self, action: #selector(rightBarButtonClick))
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
    }
    //MARK: - 右侧按钮
    func rightBarButtonClick()
    {
        //查看投资协议
        if detailModel != nil
        {
            let pro = ProtocolController()
            pro.Open = true
            pro.protocolName = "用户投资协议"
            pro.model = detailModel
            self.navigationController?.pushViewController(pro, animated: true)
        }
    }
    
    //MARK: 刷新数据
    func refreshView()
    {
        if detailModel != nil
        {
            listView.reloadData()
        }
    }
    
    //MARK: 上拉加载
    override func dropDownLoading() {
    }
    override func pullRefresh(){
    }
     
    //MARK: - 查看回款记录
    @IBAction func seeBackRecordClick(_ sender: UIButton) {
        
        let backRecord = BackToRecordViewController()
        backRecord.investModel = self.detailModel
        self.navigationController?.pushViewController(backRecord, animated: true)
    }
    
    //MARK: - UITableViewDataSource,UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            if detailModel?.productType == 1 || detailModel?.productType == 2
            {
                return 2
            }
            else
            {
                return 1
            }
        }
        else if section == 1
        {
            if detailModel?.couponType == 1 || detailModel?.couponType == 2 || detailModel?.couponType == 3 || detailModel?.couponType == 4
            {
                return 10
            }
            else
            {
                return 9
            }
        }
        else
        {
            if detailModel?.type == 1
            {//新手标
                return 0
            }
            else
            {
                return 1
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyInvestDetailNormalProCell") as! JSMyInvestDetailNormalProCell!
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("JSMyInvestDetailNormalProCell", owner: self, options: nil)?.first as? JSMyInvestDetailNormalProCell
                }
                
                if detailModel != nil
                {
                   cell?.setupModel(detailModel!)
                }
                return cell!
            }
            else
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyInvestDetailListCell") as! JSMyInvestDetailListCell!
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("JSMyInvestDetailListCell", owner: self, options: nil)?.first as? JSMyInvestDetailListCell
                }
                
                if detailModel != nil
                {
                    cell?.setupModel(detailModel!,section:indexPath.section)
                }
                cell?.accessoryType = .disclosureIndicator
                return cell!
            }
        }
        else if indexPath.section == 1
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyInvestDetailListCell") as! JSMyInvestDetailListCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSMyInvestDetailListCell", owner: self, options: nil)?.first as? JSMyInvestDetailListCell
            }
            cell?.accessoryType = .none
            if detailModel != nil
            {
                cell?.configModel(detailModel!,row:indexPath.row)
            }
            return cell!
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyInvestDetailListCell") as! JSMyInvestDetailListCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSMyInvestDetailListCell", owner: self, options: nil)?.first as? JSMyInvestDetailListCell
            }
            cell?.accessoryType = .disclosureIndicator
            if detailModel != nil
            {
                cell?.setupModel(detailModel!,section:indexPath.section)
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //奖品信息： 0-普通标 1-投即送 2-送iPhone7
        if indexPath.section == 0 && indexPath.row == 1 {
            
            if detailModel?.productType == 1 {
                
                if detailModel?.isPerfect == 0 {
                    
                    let controller = JSInvestGiveSuccessController()
                    controller.productNameID = (detailModel?.pid)!
                    controller.investId = (detailModel?.id)!
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else {
                    
                    let giftDetailVC = JSGiftDetailViewController()
                    giftDetailVC.investId = (detailModel?.id)!
                    giftDetailVC.pid = (detailModel?.pid)!
                    self.navigationController?.pushViewController(giftDetailVC, animated: true)
                }
                
            } else if detailModel?.productType == 2 {

                let prizeDetailVC = JSPrizeDetailViewController()
                prizeDetailVC.pid = (detailModel?.pid)!
                prizeDetailVC.investId = (detailModel?.id)!
                self.navigationController?.pushViewController(prizeDetailVC, animated: true)
            }
        }
        
        //产品详情 ： 3-存管新手标 2-普通标 5-体验标 1-新手标
        if indexPath.section == 2
        {
            if detailModel?.type == 3 || detailModel?.type == 1
            {
                self.toNoviceVC((detailModel?.pid)!)
            }
            else if detailModel?.type == 5
            {
                //体验标详情
                let productDetailVC = ExperienceInvestViewController()
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
            else
            {
                let productDetailVC = JSInvestDetailViewController()
                productDetailVC.establish = (detailModel?.establish)!     //计息日期
                productDetailVC.expireDate = (detailModel?.expireDate)!   //回款日期
                productDetailVC.productNameID = (detailModel?.pid)!
                productDetailVC.productStatus = (detailModel?.productStatus)!
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49 * SCREEN_SCALE_W
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10 * SCREEN_SCALE_W
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: 10 * SCREEN_SCALE_W))
        view.backgroundColor = DEFAULT_GRAYCOLOR
        return view
    }

//    //MARK: 获取新手标的id，然后才可以跳转
//    func loadMainData(){
//        self.view.showLoadingHud()
//        var uid = 0
//        if UserModel.shareInstance.isLogin == 1 {
//            uid = UserModel.shareInstance.uid!
//        }
//        weak var weakSelf = self
//        HomeApi(Uid: uid).startWithCompletionBlockWithSuccess({ (request: YTKBaseRequest!) -> Void in
//            self.view.hideHud()
//            let resultDict = request.responseJSONObject as? [String: AnyObject]
//            let homeModel = HomeModel(dict: resultDict!)
//            if homeModel.success {
//                self.toNoviceVC((homeModel.map?.newHand?.id)!)
//            } else if homeModel.errorCode == "9998" {
//                UserModel.shareInstance.logout()
//                let vc = JSLoginViewController()
//                let nvc = RootNavigationController(rootViewController:vc)
//                self.presentViewController(nvc, animated: true, completion: nil)
//            } else {
//                weakSelf!.view.showTextHud("网络错误,请稍后重试")
//                
//            }
//            
//        }) { (request: YTKBaseRequest!) -> Void in
//            self.view.hideHud()
//            weakSelf!.view.showTextHud("网络错误,请稍后重试")
//        }
//    }
    
    //MARK: 去新手页
    func toNoviceVC(_ pid:Int){
        
        let newhandDetailVC = JSInvestDetailViewController()
        newhandDetailVC.productNameID = pid
        newhandDetailVC.establish = (detailModel?.establish)!     //计息日期
        newhandDetailVC.expireDate = (detailModel?.expireDate)!   //回款日期
        newhandDetailVC.productStatus = (detailModel?.productStatus)!
        self.navigationController?.pushViewController(newhandDetailVC, animated: true)
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSMyInvestDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
