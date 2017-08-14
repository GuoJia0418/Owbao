//
//  ExperienceInestSuccessController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/1/3.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  体验金投资成功界面

import UIKit

class ExperienceInestSuccessController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var bView: UIView?                                   // 动画下面的backgroud view
    var investingModel: ExperienceInvestingModel?       //从体验标详情界面传过来的，体验标投资成功模型
    var exprienceModel: ExperienceInvestModel?          //体验标详情模型,从上个界面传过来的
    
    @IBOutlet weak var tableViewBottomConstrains: NSLayoutConstraint! //tableView底部约束
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //开始配置底部按钮
        self.configureBottomButton()
        self.popType = .reloadApp //刷新app
        
        navigationItem.title = "支付成功"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //底部按钮点击事件
    @IBAction func bottomButtonAction(_ sender: AnyObject) {
        
        if self.investingModel != nil {
            
            if self.investingModel?.map != nil {
                
                if self.investingModel?.map?.realverify == true { //认证过了
                    
                    let moreScreenVC = MoreScreenSlidingRootController()
                    moreScreenVC.vcType = 1
                    self.navigationController?.pushViewController(moreScreenVC, animated: true)
                    
                } else { //未认证
//                    let authentication = JSAuthenticationInformationVC()
//                    authentication.view.showTextHud("请先完成信息认证")
//                    self.navigationController?.pushViewController(authentication, animated: true)
                }
                
            } else {
                self.view.showTextHud("投资成功返回数据为空")
            }
            
        } else {
            
            self.view.showTextHud("投资成功返回数据为空")
        }
    }
    
//    //下载数据
//    func loadDataFromServer() -> () {
//        self.view.showLoadingHud()
//        self.bottomButton.enabled = false //先不可用
//        
//        ExperienceInvestApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlockWithSuccess({ (request: YTKBaseRequest!) -> Void in
//            
//            let resultDict = request.responseJSONObject as? [String: AnyObject]
//            print("可以的 ---- : \(resultDict)")
//            
//            let model = ExperienceInvestModel(dictionary: resultDict!)
//            self.exprienceModel = model
//            
//            self.view.hideHud()
//            self.bottomButton.enabled = true //可用
//            
//            //预处理数据
//            if self.handleDownloadedData(model, isShowLoginCtrl: true) {
//                self.tableView.reloadData()
//            }
//            
//        }) {(request: YTKBaseRequest!) -> Void in
//            self.view.showTextHud("网络错误")
//            self.view.hideHud()
//            self.bottomButton.enabled = true //可用
//        }
//    }
    
    //设置底部按钮
    func configureBottomButton() -> () {
        
        if self.investingModel != nil {
            
            if self.investingModel?.map != nil {
            
                if self.investingModel?.map?.realverify == true { //认证过了
                    
//                    self.bottomButton.hidden = self.investingModel?.map?.redTotal == 0 ? true : false //是否隐藏底部按钮
//                    self.bottomButton.setTitle("立即变现", forState: UIControlState.Normal)
//                    self.tableViewBottomConstrains.constant = self.investingModel?.map?.redTotal == 0 ? 0 : 44.0 //tableView约束
                    
                } else { //未认证
                    
//                    self.bottomButton.setTitle("立即领取", forState: UIControlState.Normal)
                }
                
            }
        }
    }
    
    
   
    //MARK：UITableViewDelegate && UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return JSExprienceInvestHeadTableViewCell.cellHeight()
        }
        return ExperienceInvestSuccessTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSExprienceInvestHeadTableViewCell") as? JSExprienceInvestHeadTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSExprienceInvestHeadTableViewCell", owner: nil, options: nil)?.first as? JSExprienceInvestHeadTableViewCell
            }
            
            if self.exprienceModel != nil {
                if self.exprienceModel?.map != nil {
                    cell?.configureCell((self.exprienceModel?.map)!)
                }
            }

            return cell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceInvestSuccessTableViewCell") as? ExperienceInvestSuccessTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("ExperienceInvestSuccessTableViewCell", owner: nil, options: nil)?.first as? ExperienceInvestSuccessTableViewCell
            }
            
            //设置模型
            if self.exprienceModel != nil && self.investingModel != nil {
                if self.exprienceModel?.map != nil && self.investingModel?.map != nil {
                    cell?.configureCellWithData((self.exprienceModel?.map)!, investing: (self.investingModel?.map)!)
                }
            }
            
            //左边按钮回调
            cell?.leftButtonCallback = {
                let myInvestVC = JSMyInvestViewController()
                self.navigationController?.pushViewController(myInvestVC, animated: true)
            }
            
            //右边按钮回调
            cell?.rightButtonCallback = {
                RootNavigationController.goToInvestList(controller: self)
            }
            
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
        let nibNameOrNil = String?("ExperienceInestSuccessController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
