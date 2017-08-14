//
//  JSInvalidCouponViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvalidCouponViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listView: UITableView!
    var couponType:Int = 0
    var model:MyCouponsModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.model == nil {
            //加载数据
            self.loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "失效优惠券"
        createView()
    }

    //MARK: - 数据
    override func loadData()
    {
        view.showLoadingHud()
        weak var weakSelf = self
        print("输出请求参数\(UserModel.shareInstance.uid)以及\(couponType)")
        //MARK: - 确定好接口
        MyActivityApi(Uid: UserModel.shareInstance.uid ?? 0, Status:3,Flag: 1).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            weakSelf!.view.hideHud()
            weakSelf!.listView.mj_header.endRefreshing()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("失效优惠券\(resultDict)")
            if resultDict == nil {
                weakSelf!.loadDataError()
                weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
                return
            }
            self.model = MyCouponsModel(dict: resultDict!)
            if weakSelf!.model?.success == false {
                weakSelf!.loadDataError()
                weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
                return
            }
            if weakSelf!.model?.map?.list.count == 0 {
                weakSelf!.loadDataError()
                weakSelf!.errorView.errInoLB.text = "没有红包"
                return
            }
            if weakSelf!.errorView != nil {
                weakSelf!.errorView.isHidden = true
            }
            weakSelf!.listView.reloadData()
        }) { (request: YTKBaseRequest!) -> Void in
            weakSelf!.listView.mj_header.endRefreshing()
            weakSelf!.loadDataError()
            weakSelf!.errorView.errInoLB.text = "网络中断链接，请检查您的网络设置"
        }
    }

    
    //MARK: - UI布局
    func createView()
    {
        navigationItem.title = "失效优惠券"
        
        listView.isHidden = false
        listView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 37 - 64 - 30 * SCREEN_WIDTH / 320)
        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.dataSource = self
        listView.delegate = self
        listView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        listView.mj_header = MJRefreshNormalHeader {
            //加载数据
            self.loadData()
        }
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        footerView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.tableFooterView = footerView
        
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model == nil {
            return 0
        }
        return (self.model?.map?.list.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSMyCouponCell") as! JSMyCouponCell!
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("JSMyCouponCell", owner: self, options: nil)?.first as? JSMyCouponCell
        }
        cell?.selectionStyle = .none
        
        //数据
        if model?.map?.list.count != 0 {
            cell?.invalidCouponModel((model?.map?.list[indexPath.row])!)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JSMyCouponCell.cellHeight()
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvalidCouponViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
