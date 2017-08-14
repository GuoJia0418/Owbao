//
//  JSHistoryInvestRecordViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
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


class JSHistoryInvestRecordViewController: BaseTableViewController,UITableViewDelegate,UITableViewDataSource {
    var investModel:MyInvestModel?      //我的投资数据
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.investModel == nil {
            self.pageIndex = 1
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
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
        MyInvestApi(Uid: UserModel.shareInstance.uid ?? 0, Status: 3, PageOn: pageIndex!).startWithCompletionBlock(success: { (request:YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            
            weakSelf!.listView.mj_footer.resetNoMoreData()
            weakSelf!.listView.mj_header.endRefreshing()
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            let dataDic = request.responseJSONObject as? [String:AnyObject]
            print("JS - 我的投资页面 \(dataDic)")
            let dataModel:MyInvestModel = MyInvestModel(dict: dataDic!)
            if dataModel.success {
                
                if weakSelf?.pageIndex! == 1
                {
                    weakSelf?.investModel = dataModel
                }
                else
                {
                    for a in (dataModel.map?.page?.rows)!
                    {
                        weakSelf?.investModel?.map?.page?.rows.append(a)
                    }
                }
                
                if weakSelf?.pageIndex! >= dataModel.map?.page?.totalPage
                {
                    weakSelf?.listView.mj_footer.endRefreshingWithNoMoreData()
                }
                else
                {
                    weakSelf?.listView.mj_footer.endRefreshing()
                    weakSelf?.pageIndex! += 1
                }
                
                weakSelf?.listView.reloadData()
                
            } else {
                weakSelf!.view.hideHud()
                weakSelf?.listView.mj_footer.endRefreshing()
                
                if dataModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                    
                }else if dataModel.errorCode == "9999"{
                    weakSelf!.view.showTextHud("系统错误!")
                }
            }
            weakSelf!.listView.reloadData()
            
        }) { (request:YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }

    //MARK: - 初始化
    override func createView() {
        super.createView()
        navigationItem.title = "历史投资记录"
        listView.isHidden = false
        listView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 37 - 64 - 30 * SCREEN_WIDTH / 320)
        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.dataSource = self
        listView.delegate = self
        listView.separatorStyle = UITableViewCellSeparatorStyle.none
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        footerView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = footerView

    }
    
    //MARK: - UITableViewDataSource,UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if investModel?.map?.page?.rows != nil && investModel?.map?.page?.rows.count != 0
        {
            return (investModel?.map?.page?.rows.count)! + 1
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSHistoryRecordCell") as? JSHistoryRecordCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSHistoryRecordCell", owner: self, options: nil)?.first as? JSHistoryRecordCell
            }
            cell?.selectionStyle = .none
            if investModel?.map != nil
            {
                cell?.configModel((investModel?.map)!)
            }
            return cell!
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyInvestListCell") as? JSMyInvestListCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSMyInvestListCell", owner: self, options: nil)?.first as? JSMyInvestListCell
            }
            cell?.selectionStyle = .none
            
            if investModel?.map?.page?.rows.count != 0 && investModel?.map?.page?.rows != nil
            {
                cell?.configModel((investModel?.map?.page?.rows[indexPath.row - 1])!)
            }

            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? JSHistoryRecordCell.cellHeight() : JSMyInvestListCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 && investModel?.map?.page?.rows.count != 0 && investModel?.map?.page?.rows != nil
        {
            let investDetailVC = JSMyInvestDetailViewController()
            investDetailVC.detailModel = (investModel?.map?.page?.rows[indexPath.row - 1])!
            self.navigationController?.pushViewController(investDetailVC, animated: true)
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
        let nibNameOrNil = String?("JSHistoryInvestRecordViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
}
