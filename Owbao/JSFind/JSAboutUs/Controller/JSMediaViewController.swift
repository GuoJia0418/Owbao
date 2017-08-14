//
//  JSMediaViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
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


class JSMediaViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var model: PublickModel?
    var pageIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "媒体报道"
        self.tableView.tableFooterView = UIView()
        
        //下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader {
            self.pageIndex = 1
            self.loadDataFromServer()
        }
        
        //上啦刷新
        self.tableView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadDataFromServer()
        }
        self.loadDataFromServer()
    }
    
    //从服务器下载数据
    func loadDataFromServer() -> () {
        
        let mediaViewModel = JSMediaViewModel()
        
        mediaViewModel.startLoadingData(PublickApi(Uid: UserModel.shareInstance.uid ?? 0,PageOn: self.pageIndex, ProId: 1),
                                        controller: self,
                                        modelName: "PublickModel",
                                        callback: { (returnValue) in
                                            
                                         let superModel =  returnValue as! PublickModel
                                         self.tableView.mj_footer.resetNoMoreData()
                                         self.tableView.mj_header.endRefreshing()
                                            
                                         if self.pageIndex == 1 {
                                            self.model = superModel
                                         } else {
                                            for a in (superModel.map?.page?.rows)! {
                                                self.model?.map?.page?.rows.append(a)
                                            }
                                         }
                                            
                                         if self.pageIndex >= superModel.map?.page?.totalPage {
                                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                                         } else {
                                            self.tableView.mj_footer.endRefreshing()
                                            self.pageIndex += 1
                                         }
                                            
                                         self.tableView.reloadData()
                                            
            }) { (errorCode) in
                self.view.showTextHud(errorCode as! String)
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.model != nil && self.model?.map != nil {
           return (self.model?.map?.page?.rows.count)!
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return JSMediaTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSMediaTableViewCell") as? JSMediaTableViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JSMediaTableViewCell", owner: self, options: nil)![0] as? JSMediaTableViewCell
        }
        cell?.configureCell(self.model?.map?.page?.rows[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if self.model != nil && self.model?.map != nil {
            
            let model = self.model?.map?.page?.rows[indexPath.row]
            
            if model != nil {
                let vc = LocationController()
                vc.model = HomeBannerModel.init(dict: ["location":(BASE_URL + Report + "?artiId=" + "\(model!.artiId)") as AnyObject,"title":"详情" as AnyObject])
                self.navigationController?.pushViewController(vc, animated: true)
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
        let nibNameOrNil = String?("JSMediaViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
