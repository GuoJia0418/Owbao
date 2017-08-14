//
//  JSAccountAssetsViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  总资产和累计收益合并的控制器

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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class JSAccountAssetsViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var segmentIndex: Int = 0 //选中的第几页,默认第一页
    
    fileprivate var segmented: UISegmentedControl?
    fileprivate var assetsModel: MyAssetsModel? //总资产模型
    fileprivate var accumulatedIncomeModel: JSAccumulatedIncomeModel? //累计资产模型
    fileprivate var pageOn: Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var assetsCell: JSAccountAssetsFirstCell? = {
        let cell = Bundle.main.loadNibNamed("JSAccountAssetsFirstCell", owner: self, options: nil)![0] as? JSAccountAssetsFirstCell
        return cell!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViw()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadDataFromServer(self.segmentIndex)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        if self.assetsCell != nil {
            self.assetsCell?.waveAnimationView.stopAnimation()
            self.assetsCell = nil
        }
    }
    
    func configureViw() -> () {
        let sgController = UISegmentedControl(items: ["总资产","累计收益"])
        sgController.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        sgController.tintColor = Global_yellow_deep
        sgController.layer.borderColor = Global_yellow_deep.cgColor
        sgController.layer.borderWidth = 1.0
        sgController.layer.cornerRadius = 4
        sgController.layer.masksToBounds = true
        
        sgController.addTarget(self, action: #selector(didClicksegmentedControlAction), for: UIControlEvents.valueChanged)
        sgController.selectedSegmentIndex = self.segmentIndex //默认选中第一页
        self.navigationItem.titleView = sgController
        
        //右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "明细", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightButtonItemAction))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadDataFromServer(_:)), name: NSNotification.Name(rawValue: FuiouHandleRefreshSucessPostNotification), object: nil)
    }
    

    func rightButtonItemAction() -> () {
        let controller = JSTransactionListController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didClicksegmentedControlAction(_ segmented: UISegmentedControl) -> () {
        let index = segmented.selectedSegmentIndex
        self.segmentIndex = index
        self.tableView.reloadData()
        self.loadDataFromServer(self.segmentIndex)
        
        switch index {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    //下载数据
    func loadDataFromServer(_ segmentIndex: Int) -> () {
        
        if segmentIndex == 0 { //总资产
            
            view.showLoadingHud()
            MyAssetsApi(Uid: UserModel.shareInstance.uid ?? 0).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
                self.view.hideHud()
                
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("总资产---\(resultDict)")
                self.assetsModel = MyAssetsModel(dict: resultDict!)
                self.tableView.reloadData()
                
                if self.assetsModel?.success == false {
                    self.view.hideHud()
                    
                    if self.assetsModel?.errorCode == "9998" {

                        self.view.showTextHud("登录失效,请重新登录")
                        //弹出登录控制器
                        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                        
                    } else {
                        self.view.showTextHud("系统错误")
                    }
                } else if self.assetsModel?.errorCode == "9998" {
                    
                    self.view.showTextHud("登录失效,请重新登录")
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                    
                } else {
                    
                    self.tableView.reloadData()
                }
                
            }) { (request: YTKBaseRequest!) -> Void in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
            }
            
        } else if segmentIndex == 1 { //累计收益
            
            view.showLoadingHud()
            JSAccumulatedIncomeApi(Uid: UserModel.shareInstance.uid ?? 0,PageOn: self.pageOn).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
                self.view.hideHud()
                
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("累计收益--\(resultDict)")
                self.accumulatedIncomeModel = JSAccumulatedIncomeModel(dictionary: resultDict!)

                //处理数据模型
                if self.accumulatedIncomeModel?.success == true {
                    
                    self.tableView.reloadData()
                    
                } else {
                    
                    if self.accumulatedIncomeModel?.errorCode == "9999" {
                        self.view.showTextHud("系统错误")
                    } else if self.accumulatedIncomeModel?.errorCode == "9998" {
                        //弹出登录控制器
                        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                    } else {
                        if self.accumulatedIncomeModel?.errorMsg != "" {
                            self.view.showTextHud((self.accumulatedIncomeModel?.errorMsg)!)
                        } else {
                            self.view.showTextHud("报名失败")
                        }
                    }
                }
                
            }) { (request: YTKBaseRequest!) -> Void in
                self.view.hideHud()
                self.view.showTextHud("网络错误")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITabelViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentIndex == 0 {
            
            if section == 2 {
                
                if self.assetsModel?.map?.funds?.balance == 0 {
                    return 0
                }
            }
            
            return 1
            
        } else {
            if self.accumulatedIncomeModel != nil {
                
                if self.accumulatedIncomeModel?.map != nil {
                    
                    if self.accumulatedIncomeModel?.map?.page != nil {
                        
                        if self.accumulatedIncomeModel?.map?.page?.rows != nil {
                            
                            if self.accumulatedIncomeModel?.map?.page?.rows.count >= 0 {
                                return (self.accumulatedIncomeModel?.map?.page?.rows.count)! + 1
                            }
                        }
                    }
                }
            }
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentIndex == 0 {
            return 5
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.segmentIndex == 0 { //第一个界面
            
            if indexPath.section == 0 { //第一个
                
                //配置模型
                self.assetsCell?.configureCell_xib_0_WithModel(self.segmentIndex, fundsModel: self.assetsModel?.map?.funds,accumulatedIncomeMapModel: nil)
                return self.assetsCell!
                
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSAccountAssetsTableViewCell_2") as? JSAccountAssetsTableViewCell
                
                if cell == nil {    
                    cell = Bundle.main.loadNibNamed("JSAccountAssetsTableViewCell", owner: self, options: nil)![1] as? JSAccountAssetsTableViewCell
                }
                //配置模型
                if self.assetsModel != nil {
                    
                    if self.assetsModel?.map != nil {
                        
                        if self.assetsModel?.map?.funds != nil {
                            cell?.configureCell_xib_2_WithModel(indexPath.section - 1 ,
                                                                fundsModel: (self.assetsModel?.map?.funds)!,
                                                                isFuiou: (self.assetsModel?.map?.isFuiou)!)
                        }
                    }
                }
                return cell!
            }
        
        } else { //第二个界面
            
            if indexPath.row == 0 { //第一个
                //配置模型
                self.assetsCell?.configureCell_xib_0_WithModel(self.segmentIndex, fundsModel: nil,accumulatedIncomeMapModel: self.accumulatedIncomeModel?.map)
                return self.assetsCell!
                
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "JSAccountAssetsTableViewCell_2") as? JSAccountAssetsTableViewCell
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("JSAccountAssetsTableViewCell", owner: self, options: nil)![0] as? JSAccountAssetsTableViewCell
                }
                cell?.configureCell_xib_1_WithModel(self.accumulatedIncomeModel?.map?.page?.rows[indexPath.row - 1])
                return cell!
            }
        }
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentIndex == 0 {
            if indexPath.section == 0 {
               return JSAccountAssetsFirstCell.cellHeight_firstXib()
            } else {
               return JSAccountAssetsTableViewCell.cellHeight_secondXib()
            }
        } else {
            if indexPath.row == 0 {
                return JSAccountAssetsFirstCell.cellHeight_firstXib()
            } else {
                return JSAccountAssetsTableViewCell.cellHeight_thirdXib()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.segmentIndex == 0 {
            
            if indexPath.section == 1 {
                
                if self.assetsModel?.map?.isFuiou == 0 {
                    let controller = JSOpenAccountFuiouViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
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
        let nibNameOrNil = String?("JSAccountAssetsViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
