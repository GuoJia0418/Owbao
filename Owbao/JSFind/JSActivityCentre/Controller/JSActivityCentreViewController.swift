//
//  JSActivityCentreViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

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


class JSActivityCentreViewController: BaseTableViewController,UITableViewDelegate,UITableViewDataSource {

    var makeMoneyStatus: Int! = 1  //全部：0   进行中 1  已结束 2
    var getActivityFriendAllMapModel: GetActivityFriendAllMapModel? //第二层数据
    var dataArray: [GetActivityFriendAllRowsModel] = []              //数据
    var model: GetActivityFriendAllModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.model == nil {
            self.pageIndex = 1
            self.loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "活动中心"
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        footerView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = footerView
        
        if makeMoneyStatus == 1 { //前面一个界面才有右边按钮
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "往期活动", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightButtonAction))
        }
    }
    
    //右按钮点击事件
    func rightButtonAction() -> () {
        let controller = JSActivityCentreViewController()
        controller.makeMoneyStatus = 2
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 上拉加载
    override func dropDownLoading() {
        listView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadData()
        }
    }
    
    //MARK: - 请求数据
    override func loadData() {
        
        view.showLoadingHud()
        weak var weakSelf = self
        GetActivityFriendAllApi(Uid: UserModel.shareInstance.uid ?? 0, Status: makeMoneyStatus, PageOn: pageIndex!,ApiType:1).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            
            weakSelf!.view.hideHud()
            
            weakSelf!.listView.mj_footer.resetNoMoreData()
            weakSelf!.listView.mj_header.endRefreshing()
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            let resultDict = request.responseJSONObject as? [String:AnyObject]
            let dataModel = GetActivityFriendAllModel(dict: resultDict!)
            print("专区 == \(resultDict) == \(self.makeMoneyStatus)==\(self.pageIndex!)")
            if resultDict == nil {
                weakSelf!.view.hideHud()
                weakSelf!.listView.reloadData()
                return
            }
            
            if dataModel.success
            {
                if weakSelf?.pageIndex == 1
                {
                    weakSelf?.model = dataModel
                }
                else
                {
                    for a in (dataModel.map?.Page?.rows)! {
                        weakSelf!.model?.map?.Page?.rows.append(a)
                    }
                }
                weakSelf?.getActivityFriendAllMapModel = dataModel.map
                
                if weakSelf!.pageIndex! >= dataModel.map?.Page?.totalPage
                {
                    weakSelf!.listView.mj_footer.endRefreshingWithNoMoreData()
                }
                else
                {
                    weakSelf!.listView.mj_footer.endRefreshing()
                    weakSelf!.pageIndex! += 1
                }
                
                weakSelf!.listView.reloadData()
            } else if dataModel.errorCode == "9998" {
                //弹出登录控制器
                JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
            } else {
                weakSelf?.view.hideHud()
                weakSelf!.view.showTextHud("系统错误!")
            }
            
        }) { (request:YTKBaseRequest!) in
            
            weakSelf!.view.showTextHud("网络错误,请稍后重试")
            weakSelf!.view.hideHud()
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource && UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if model != nil && model?.map?.Page?.rows.count != 0 && model?.map?.Page?.rows != nil {
            
            return (model?.map?.Page?.rows.count)!
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSActivityCentreTableViewCell") as! JSActivityCentreTableViewCell!
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JSActivityCentreTableViewCell", owner: self, options: nil)?.last as? JSActivityCentreTableViewCell
        }
        if model?.map?.Page?.rows.count != 0 {
            cell?.configureCell((model?.map?.Page?.rows[indexPath.row])!)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JSActivityCentreTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if model?.map?.Page?.rows.count != 0 {
            let model_row = model?.map?.Page?.rows[indexPath.row]
            
            if model_row?.status != 2 {
                let controller = LocationController()
                controller.model = HomeBannerModel(dict: ["location": "\((model_row?.appUrl)!)?afid=\((model_row?.id)!)"  as AnyObject,"title": (model_row?.title)! as AnyObject])
                self.navigationController?.pushViewController(controller, animated: true)
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
        let nibNameOrNil = String?("JSActivityCentreViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
