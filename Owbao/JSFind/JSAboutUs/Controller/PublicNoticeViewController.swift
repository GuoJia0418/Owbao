//
//  PublicNoticeViewController.swift
//  Owbao
//
//  Created by GuoJia on 16/11/28.
//  Copyright © 2016年 wangyuxi. All rights reserved.
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


class PublicNoticeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = 1 //初始化第一页
    var model: PublickModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "网站公告"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //从服务器下载数据
    func loadDataFromServer() {
        
        let mediaViewModel = JSMediaViewModel()
        self.view.showLoadingHud()
        
        mediaViewModel.startLoadingData(PublickApi(Uid: UserModel.shareInstance.uid ?? 0,PageOn: self.pageIndex, ProId: 14),
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    //MARK: - tableData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.model != nil && self.model?.map != nil {
            return (self.model?.map?.page?.rows.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PublicNoticeTableViewCell") as? PublicNoticeTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PublicNoticeTableViewCell", owner: self, options: nil)?.last as? PublicNoticeTableViewCell
        }
        
        if self.model != nil && self.model?.map != nil {
            let model = self.model?.map?.page?.rows[indexPath.row]
            
            if model != nil {
                cell?.titleLabel?.text = model!.title
                cell?.detailTitleLabel?.text =  TimeStampToString((model?.createTime)!, isHMS: true)
            }
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.model != nil && self.model?.map != nil {
            let model = self.model?.map?.page?.rows[indexPath.row]
            
            if model != nil {
                let vc = LocationController()
                vc.model = HomeBannerModel(dict: ["location":BASE_URL + GGXQ + "?artiId=" + "\(model!.artiId)" as AnyObject,"title":"详情" as AnyObject])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("PublicNoticeViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
