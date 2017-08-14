//
//  JSOfflineActivityViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/4.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSOfflineActivityViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listView: UITableView!
    fileprivate var pageIndex: Int?
    var model:JSOfflineActivityModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "线下活动"
        listView.separatorStyle = .none
        listView.backgroundColor = UIColorFromRGB(239, green: 239, blue: 239)
        self.pullRefresh()
        self.dropDownLoading()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageIndex = 1
        self.loadData()
    }

    //MARK: - 上拉加载
    func pullRefresh() {
        listView.mj_header = MJRefreshNormalHeader {
            self.pageIndex = 1
            self.loadData()
        }
    }
    
    //MARK: 下拉刷新
    func dropDownLoading() {
        listView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadData()
        }
    }
    //MARK: - 请求数据
    override func loadData() {
        self.view.showLoadingHud()
        weak var weakSelf = self
        JSOfflineActivityApi(PageOn: pageIndex!).startWithCompletionBlock(success: { (request:YTKBaseRequest?) in
            weakSelf!.view.hideHud()

            weakSelf!.listView.mj_footer.resetNoMoreData()
            weakSelf!.listView.mj_header.endRefreshing()
            
            let resultDict = request?.responseJSONObject as? [String: AnyObject]
            print("线下活动=\(resultDict)")
            let dataModel = JSOfflineActivityModel(dict: resultDict!)
            if dataModel.success == true
            {
                if weakSelf!.pageIndex! == 1 {
                    weakSelf!.model = dataModel
                } else {
                    for a in (dataModel.map?.page?.rows)! {
                        weakSelf!.model?.map?.page?.rows.append(a)
                    }
                }

                if weakSelf!.pageIndex! >= (dataModel.map?.page?.totalPage)! {
                    weakSelf!.listView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    weakSelf!.listView.mj_footer.endRefreshing()
                    weakSelf!.pageIndex! += 1
                }
                weakSelf!.listView.reloadData()
            }
            else
            {
                weakSelf!.listView.mj_footer.endRefreshing()
            }
            
        }) { (request:YTKBaseRequest?) in
            
            weakSelf!.view.hideHud()
            weakSelf!.view.showTextHud("网络错误")
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.listView.mj_footer.endRefreshing()
        }
    }

    //MARK:- table数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.model != nil && self.model?.map != nil && self.model?.map?.page != nil && self.model?.map?.page?.rows != nil
        {
            return (self.model?.map?.page?.rows.count)! + 1
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 //开放日
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSOfflineActivityCell") as? JSOfflineActivityCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSOfflineActivityCell", owner: self, options: nil)?.first as? JSOfflineActivityCell
            }
            if self.model != nil && self.model?.map != nil
            {
                cell?.configData(model: (self.model?.map)!)
            }
            return cell!
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSOfflineActivityCell") as? JSOfflineActivityCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSOfflineActivityCell", owner: self, options: nil)?.first as? JSOfflineActivityCell
            }
            if self.model?.map!.page?.rows.count != 0 {
                cell?.refreshView(model: (self.model?.map!.page?.rows[indexPath.row - 1])!)
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JSOfflineActivityCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            //开放日
            let controller = LocationController()
            controller.homeBtnIndex = 8
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            if self.model?.map!.page?.rows.count != 0 {
                let model:JSOfflineActivityRowsModel = (self.model?.map!.page?.rows[indexPath.row - 1])!
                let vc = LocationController()
                let urlStr = "/publicWelfare" + "?id=\(model.id)"
                vc.model = HomeBannerModel.init(dict: ["location":(BASE_URL + urlStr) as AnyObject,"title":"活动详情" as AnyObject])
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
        let nibNameOrNil = String?("JSOfflineActivityViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
