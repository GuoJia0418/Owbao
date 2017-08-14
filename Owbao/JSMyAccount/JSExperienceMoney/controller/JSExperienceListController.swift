//
//  JSExperienceListController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum ExperienceBottomButtonType: Int {
    case noneUse = 0           //有体验金，但不可使用
    case activate = 1         //立即激活状态，表示全是未激活体状态且可以使用的验金
    case use = 2              //立即使用状态，表示有可以使用的体验金
    case noneExperince = 3    //无体验金
}

class JSExperienceListController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    fileprivate var model: MyCouponsModel?
    fileprivate var bottomButtonType: ExperienceBottomButtonType = .noneExperince //默认是无体验金
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "体验金"
        self.bottomButton.layer.cornerRadius = 4
        self.bottomButton.layer.masksToBounds = true
        
        //登录成功
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewAfterLoginSuccess), name: NSNotification.Name(rawValue: LoginSucessPostNotification), object: nil)
        
        self.listView.mj_header = MJRefreshNormalHeader {
            //加载数据
            self.loadData()
        }
        
        //默认添加无体验金视图
        self.listView.tableFooterView = self.getNoDataView()
        self.barType = .red //红色bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.model == nil {
            //加载数据
            self.loadData()
        }
        
        //未登录
        if UserModel.shareInstance.isLogin == 0 {            
            //弹出登录控制器
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
        }
    }
    
    //底部点击事件
    @IBAction func bottomClickAction(_ sender: AnyObject) {
        
        if self.bottomButtonType == .activate { //立即激活
            
            RootNavigationController.goToInvestList(controller: self)
            
        } else if self.bottomButtonType == .use { //去正常体验标详情
            
            let controller = ExperienceInvestViewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    /**
     *  刷新数据
     */
    override func loadData() {
        
        view.showLoadingHud()
        weak var weakSelf = self
        //        print("输出请求参数\(UserModel.shareInstance.uid)以及\(couponsStatus)")
        MyActivityApi(Uid: UserModel.shareInstance.uid ?? 0, Status: -1,Flag: 0 ).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            weakSelf!.listView.mj_header.endRefreshing()
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
                        print("输出我的红包\(resultDict)")
            
            if resultDict == nil {
                weakSelf!.loadDataError()
                weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
                return
            }
            self.model = MyCouponsModel(dict: resultDict!)
            if weakSelf!.model?.success == false {
                weakSelf!.loadDataError()
                weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
                return
            }
            
            if weakSelf!.errorView != nil {
                weakSelf!.errorView.isHidden = true
            }
            
            //配置底部按钮
            if self.model != nil {
                self.configureBottomButton(self.model!)
            }
            
            weakSelf!.listView.reloadData()
            
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.loadDataError()
            weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
        }
    }
    
    //判断底部按钮显示逻辑,有三种见前枚举
    func configureBottomButton(_ model: MyCouponsModel) -> () {

        if model.map?.list.count == 0 { //无体验金
            
            self.bottomButtonType = .noneExperince
            
        }  else {
            
            //注意：flag_use不会小于flag_activity，他们之间是包含关系（注意：未激活的体验金status不一定为0）
            var flag_use: Int = 0
            var flag_activity: Int = 0
            
            for index in 0 ... (model.map?.list.count)! - 1 {
                
                let couponsModel = model.map?.list[index]
                
                //表示有可用的体验金
                if couponsModel!.status == 0 {
                    flag_use += 1
                }
                
                //表示有未激活且可以使用的体验金
                if couponsModel!.source == 100 && couponsModel!.status == 0 {
                    flag_activity += 1
                }
            }
            
            if flag_use == 0 { //表示没有可用体验金
                
                self.bottomButtonType = .noneUse
                
            } else {
                
                if flag_use > flag_activity { //不全是未激活状态
                    
                    self.bottomButtonType = .use
                    
                } else if flag_use == flag_activity { //全是未激活状态
                    
                    self.bottomButtonType = .activate
                }
            }
        }
        
        //开始判断
        if self.bottomButtonType == .noneExperince {
            //添加无体验金代码
            self.listView.tableFooterView = self.getNoDataView()
            self.bottomButton.isEnabled = false
            self.bottomButton.backgroundColor = UIColorFromRGB(164, green: 164, blue: 164)
            
        } else if self.bottomButtonType == .use {
            
            self.listView.tableFooterView = UIView()
            self.bottomButton.isEnabled = true
            self.bottomButton.backgroundColor = UIColorFromRGB(228, green: 71, blue: 74)
            
        } else if self.bottomButtonType == .activate {
            
            self.listView.tableFooterView = UIView()
            self.bottomButton.isEnabled = true
            self.bottomButton.backgroundColor = UIColorFromRGB(228, green: 71, blue: 74)
            self.bottomButton.setTitle("立即激活", for: UIControlState())
            
        } else if self.bottomButtonType == .noneUse {
            
            self.listView.tableFooterView = UIView()
            self.bottomButton.isEnabled = false
            self.bottomButton.backgroundColor = UIColorFromRGB(164, green: 164, blue: 164)
        }
    }
    
    //创建没数据的视图
    func getNoDataView() -> UIView {
        let view = JSNoDataView.getNoDataView(CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: JSNoDataView.getSuitHeight(169.0/176.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH) ))
        view.displayImageView.image = UIImage(named: "暂无可用体验金")
        view.displayLabel.text = "暂无可用体验金"
        view.imageWHScale = 187.0 / 115.0
        
        //父视图
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: JSNoDataView.getSuitHeight(169.0/176.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH) + 20 ))
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: JSNoDataView.getSuitHeight(187.0/115.0, imageViewRelativeScale: 4.0, width: SCREEN_WIDTH))
        
        superView.addSubview(view)
        return superView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //登录成功
    func reloadViewAfterLoginSuccess() -> () {
        self.loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            
            if self.model != nil {
                return (self.model?.map?.list.count)!
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSExperienceHeadCell") as? JSExperienceHeadCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSExperienceHeadCell", owner: self, options: nil)?.last as? JSExperienceHeadCell
            }
            
            if self.model != nil {
                if self.model?.map != nil {
                    cell?.configureCell((self.model?.map)!)
                }
            }
            
            //点击查看体验金回调
            cell?.checkButtonCallback = {
                let controller = LocationController()
                controller.model = HomeBannerModel(dict: ["location": BASE_URL + ExperienceRule as AnyObject,"title":"体验金使用规则" as AnyObject])
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            return cell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSExperienceDisplayInfoCell") as? JSExperienceDisplayInfoCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSExperienceDisplayInfoCell", owner: self, options: nil)?.last as? JSExperienceDisplayInfoCell
            }
            
            //配置模型
            if model?.map?.list.count != 0 {
                cell!.configureCell((model?.map?.list[indexPath.row])!)
            }
            
            //点击使用回调
            cell?.tapActionCallback = {
                self.pushController(indexPath) //开始跳转
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return JSExperienceHeadCell.cellHeight()
        } else {
            return JSExperienceDisplayInfoCell.cellHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section != 0 {
            self.pushController(indexPath) //开始跳转
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //MARK: 取出当前cell对应的模型判断类型，然后进行push控制器
    func pushController(_ indexPath: IndexPath) -> () {
        
        if model?.map?.list.count != 0 {
            
            let couponsModel: MyCouponsListModel = (model?.map?.list[indexPath.row])!
            
            if couponsModel.status == 0 { //未使用才能跳转
                
                if couponsModel.source == 100 { //未激活
                    
                    RootNavigationController.goToInvestList(controller: self)
                    
                } else { //已经激活
                    let controller = ExperienceInvestViewController()
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
        }
    }
    
    //MARK: - init 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience  init() {
        
        let nibNameOrNil = String?("JSExperienceListController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

 

}
