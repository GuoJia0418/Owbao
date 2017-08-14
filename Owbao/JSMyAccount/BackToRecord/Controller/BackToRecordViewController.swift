 //
//  BackToRecordViewController.swift
//  Owbao
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BackToRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var listView: UITableView!
    
    var investModel:MyInvestRowsModel?
    var myBackToRecordModel: MyBackToRecordModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = UIView()
        listView.separatorInset = UIEdgeInsets.zero
        listView.layoutMargins = UIEdgeInsets.zero
        
        navigationItem.title = "回款记录"
       
        listView.register(UINib(nibName: "BackToRecordCell", bundle: nil),forCellReuseIdentifier: "BackToRecordCell")
        loadData()
        
    }
    
    /**
     上拉加载
     */
    func dropDownLoading(){
        listView.mj_footer = MJRefreshAutoNormalFooter {
            
            self.loadData()
        }
    }

    //下载数据
    override func loadData(){
        
        var uid = 0
        if UserModel.shareInstance.isLogin == 1 {
            uid = UserModel.shareInstance.uid!
        }
        var pid = 0
        var id = 0
        if investModel != nil {
            pid = (investModel?.pid)!
            id = (investModel?.id)!
        }
        view.showLoadingHud()
        weak var weakSelf = self
        print("回款记录的参数pid=\(pid)==uid\(uid)-id=\(id)")
        BackToRecordApi(Uid: uid, Pid: pid, Id: id).startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
            
                weakSelf!.view.hideHud()
                let resultDict = request.responseJSONObject as? [String: AnyObject]
                print("回款记录请求的数据 \(resultDict)")
                weakSelf!.myBackToRecordModel = MyBackToRecordModel(dict: resultDict!)
            
                if weakSelf?.myBackToRecordModel?.success == false
                {
                    if weakSelf?.myBackToRecordModel?.errorMsg != nil && weakSelf?.myBackToRecordModel?.errorMsg != ""
                    {
                         weakSelf!.view.showTextHud((weakSelf?.myBackToRecordModel!.errorMsg)!)
                    }
                    else
                    {
                         weakSelf!.view.showTextHud("系统错误!")
                    }
                }
                else if weakSelf!.myBackToRecordModel?.errorCode != nil
                {
                    weakSelf!.view.hideHud()
                    
                    if weakSelf!.myBackToRecordModel?.errorCode == "9998" {
                        
                        //弹出登录控制器
                        JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                        
                    } else if weakSelf!.myBackToRecordModel?.errorCode == "9999"{
                        weakSelf!.view.showTextHud("系统错误!")
                    }

                }
                else
                {
                    if weakSelf!.listView.isHidden {
                        weakSelf!.listView.isHidden = false
                    }
                    weakSelf?.listView.reloadData()
                }
        
            }) { (request: YTKBaseRequest!) in
                if weakSelf!.listView.isHidden {
                    weakSelf!.listView.isHidden = false
                }
                weakSelf!.view.hideHud()
                weakSelf!.view.showTextHud("网络错误")
                weakSelf!.listView.reloadData()
                weakSelf!.listView.mj_header.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    //MARK: - tableData
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.myBackToRecordModel != nil && self.myBackToRecordModel?.map != nil && self.myBackToRecordModel?.map?.backRecordModel != nil {
           
            return (self.myBackToRecordModel?.map?.backRecordModel.count)!
        }
        else
        {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BackToRecordCell") as? BackToRecordCell
        if cell == nil {
            
            cell = BackToRecordCell(style: UITableViewCellStyle.default, reuseIdentifier: "BackToRecordCell")
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.model = (self.myBackToRecordModel?.map?.backRecordModel)![indexPath.row]

        return cell!
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience  init() {
        
        let nibNameOrNil = String?("BackToRecordViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
