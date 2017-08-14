//
//  JSMessageCentreController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/28.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  消息中心

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


class JSMessageCentreController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var type: Int = 0
    var dataArray: [MailRowsModel] = []
    var pageIndex: Int = 1
    @IBOutlet weak var listView: UITableView!
    
    //头部视图
    lazy var headerView: JSMessageCentreHeadView? = {
       let view = Bundle.main.loadNibNamed("JSMessageCentreHeadView", owner: self, options: nil)![0] as? JSMessageCentreHeadView
        return view!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageIndex = 1
        self.pullRefresh()
        self.dropDownLoading()
        self.title = "消息中心"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    /**
     * 上拉加载
     */
    func pullRefresh() {
        listView.mj_header = MJRefreshNormalHeader {
            self.pageIndex = 1
            self.loadData()
        }
    }
    
    /**
     * 下拉刷新
     */
    func dropDownLoading() {
        listView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //下载数据
    override func loadData() {
        
        view.showLoadingHud()
        weak var weakSelf = self
        MyMessageApi(Uid: UserModel.shareInstance.uid ?? 0, Type: type, PageOn: pageIndex).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            weakSelf!.listView!.mj_header.endRefreshing()
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("\(resultDict)")
            
            if resultDict == nil {
                weakSelf!.listView.reloadData()
                return
            }
            
            let baseModel: MailModel = MailModel(dict: resultDict!)
            if baseModel.success {
                if weakSelf!.pageIndex == 1 {
                    weakSelf!.dataArray.removeAll()
                }
                
                //totalPage: 总页数
                if (baseModel.map?.page?.totalPage == 0) {
                    weakSelf!.listView.mj_footer.isHidden = true
                    
                } else {
                    weakSelf!.listView.mj_footer.isHidden = false
                }
                
                if weakSelf!.pageIndex >= baseModel.map?.page?.totalPage {
                    weakSelf!.listView!.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    weakSelf!.listView.mj_footer.endRefreshing()
                }
                
                for a in (baseModel.map?.page?.rows)! {
                    weakSelf!.dataArray.append(a)
                }
                
                weakSelf!.pageIndex += 1
                
            } else {
                
                if baseModel.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else if baseModel.errorCode == "9999" {
                    weakSelf!.view.showTextHud("系统错误")
                }
            }
            weakSelf!.listView.reloadData()
            
        }) { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JSMessageCentreHeadView") as? JSMessageCentreHeadView
        
        if view == nil {
           view = Bundle.main.loadNibNamed("JSMessageCentreHeadView", owner: self, options: nil)![0] as? JSMessageCentreHeadView
        }

        //配置模型
        view!.configureHeaderView(dataArray[section])
        //回调
        view!.tapCallBack = { (handleModel: MailRowsModel) in
            self.dataArray[section] = handleModel
            self.listView.reloadData()
        }
        return view!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray[section].isOpen {
            return 1
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return JSServiceCentreDisplayTitleTableViewCell.getHeigth(dataArray[indexPath.section].content)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSServiceCentreDisplayTitleTableViewCell") as? JSServiceCentreDisplayTitleTableViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JSServiceCentreDisplayTitleTableViewCell", owner: self, options: nil)![0] as? JSServiceCentreDisplayTitleTableViewCell
        }
        
        cell?.displayTitle.text = dataArray[indexPath.section].content
        
        return cell!
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSMessageCentreController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
