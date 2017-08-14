//
//  JSPrizeDetailViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/2.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSPrizeDetailViewController: BaseTableViewController,UITableViewDelegate,UITableViewDataSource {
    
    var pid: Int =  0
    var model: JSPrizeDetailModel?
    var investId: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.model == nil {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    //MARK: - 请求数据
    override func loadData() {
        view.showLoadingHud()
        weak var weakSelf = self
        
        if pid == 0
        {
            return
        }
        JSPrizeDetailApi(Uid: UserModel.shareInstance.uid ?? 0,Pid:pid,InvestId: self.investId).startWithCompletionBlock(success: { (request:YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            
            weakSelf!.listView.mj_footer.resetNoMoreData()
            weakSelf!.listView.mj_header.endRefreshing()
            
            if weakSelf!.listView.isHidden {
                weakSelf!.listView.isHidden = false
            }
            
            let resultDic = request.responseJSONObject as? [String:AnyObject]
            print("财胜标 - 奖品详情页面 \(resultDic)")
            let dataModel:JSPrizeDetailModel = JSPrizeDetailModel(dict: resultDic!)
            self.model = JSPrizeDetailModel(dict: resultDic!)
            
            if dataModel.success {
                
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
        navigationItem.title = "奖品信息"
        listView.isHidden = false
        listView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 37 - 64 - 30 * SCREEN_WIDTH / 320)
        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.dataSource = self
        listView.delegate = self
        listView.separatorStyle = .singleLine

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        footerView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = footerView
    }

    //MARK: - UITableViewDelegate,UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSGiftDetailHeaderCell") as! JSGiftDetailHeaderCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSGiftDetailHeaderCell", owner: self, options: nil)?.first as! JSGiftDetailHeaderCell
            }
            
            if model != nil && model?.map != nil
            {
                cell?.setupPrizeModel()
            }
            return cell!
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSGiftDetailListCell") as! JSGiftDetailListCell!
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("JSGiftDetailListCell", owner: self, options: nil)?.first as! JSGiftDetailListCell
            }
            
            if model != nil && model?.map != nil
            {
                cell?.setupPrizeModel((model?.map)!,row:indexPath.row)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return JSGiftDetailHeaderCell.cellHeight()
        }
        else
        {
            if model != nil && model?.map != nil
            {
                return JSGiftDetailListCell.cellHeight((model?.map)!,row:indexPath.row)
            }
            else
            {
                return JSGiftDetailListCell.normalCellHeight()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
            if model != nil && model?.map != nil && model?.map?.prizeStatus == 1
            {
                let prizePerson = WinningPersonController()
                prizePerson.vcType = 1
                prizePerson.pid = self.pid
                self.navigationController?.pushViewController(prizePerson, animated: true)
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
        let nibNameOrNil = String?("JSPrizeDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
