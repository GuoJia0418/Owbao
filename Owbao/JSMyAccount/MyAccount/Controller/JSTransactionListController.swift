//
//  JSTransactionListController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/27.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  交易明细列表控制器

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


class JSTransactionListController: BaseViewController {
    
    var tradeType: Int = 0
    var dataArray: [MyAssetRowsModel] = []           //消息数据存放数组
    var pageIndex: Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "交易明细"
        pageIndex = 1
        self.tableView.tableFooterView = UIView()
        
        self.pullRefresh()
        self.dropDownLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadDataFromSever(tradeType)
    }
    
    //上拉加载
    func pullRefresh() {
        tableView.mj_header = MJRefreshNormalHeader {
            self.pageIndex = 1
            self.loadDataFromSever(self.tradeType)
        }
    }
    
    //下拉刷新
    func dropDownLoading() {
        tableView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadDataFromSever(self.tradeType)
        }
    }
    
    //MARK: 下载数据
    func loadDataFromSever(_ var_tradeType: Int) -> () {
        self.view.showLoadingHud()
        
        MyAssetRecordApi(Uid: UserModel.shareInstance.uid ?? 0, PageOn: pageIndex,TradeType: var_tradeType).startWithCompletionBlock(success: { (request:YTKBaseRequest!) -> Void in
            self.view.hideHud()
        
            self.tableView.mj_header.endRefreshing()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("输出我的明细\(resultDict)")
            if resultDict == nil {
                self.tableView.reloadData()
                return
            }
            
            let baseModel = MyAssetRecordModel(dict: resultDict!)
            if baseModel.success {
                
                if self.pageIndex == 1 {
                    self.dataArray.removeAll()
                }
                
                if (baseModel.map?.page?.rows)!.count == 0 {
                    self.tableView.mj_footer.isHidden = true
                } else {
                    self.tableView.mj_footer.isHidden = false
                }
                
                for a in (baseModel.map?.page?.rows)! {
                    self.dataArray.append(a)
                }
                
                if self.pageIndex >= baseModel.map?.page?.totalPage {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.mj_footer.endRefreshing()
                }
                
                self.pageIndex += 1
                
            } else {
                
                if baseModel.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if baseModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                }
            }
            
            self.tableView.reloadData()
            
        }) { (request:YTKBaseRequest!) -> Void in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableDelegate / UITableDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JSTransactionListHeadView") as? JSTransactionListHeadView
        
        if view == nil {
            view = Bundle.main.loadNibNamed("JSTransactionListHeadView", owner: self , options:  nil)![0] as? JSTransactionListHeadView
        }
        
        return view!
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSAccountAssetsTableViewCell_2") as? JSAccountAssetsTableViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JSAccountAssetsTableViewCell", owner: self, options: nil)![0] as? JSAccountAssetsTableViewCell
        }
        cell?.configureCell_xib_1_WithMyAssetRowsModel(dataArray[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        return JSAccountAssetsTableViewCell.cellHeight_secondXib()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSTransactionListController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
