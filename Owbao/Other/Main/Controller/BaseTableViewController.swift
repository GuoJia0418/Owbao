//
//  BaseTableViewController.swift
//  Owbao
//  带有TableView的ViewController基类
//  Created by Panda on 16/6/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    @IBOutlet weak var listView: UITableView!
//    var listView:UITableView!                           //显示列表
    var noneDataPromptTitle: String?                     //没有数据时显示的文字提示
    var noneDataImageName: String?                       //没有数据时显示的图片名称
    var pageIndex: Int?                                   //第几页
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        noneDataPromptTitle = "暂无数据"
        noneDataImageName = "ico_record"
        
        listView.separatorStyle = UITableViewCellSeparatorStyle.none
        listView.tableFooterView = UIView(frame: CGRect.zero)
        listView.backgroundColor = DEFAULT_GRAYCOLOR
        listView.emptyDataSetSource = self
        listView.emptyDataSetDelegate = self
        self.pullRefresh()
        self.dropDownLoading()
    }
    
    /**
     * 视图初始化
     */
    func createView(){
        
        listView.tableFooterView = UIView(frame: CGRect.zero)
        listView.emptyDataSetSource = self
        listView.emptyDataSetDelegate = self
        
    }
    // 獲取數據成功后的結果
    override func hideErrorView() {
        // 如果有网的时候，删除掉，所有的 NetworkErrorView（无网络处理视图）
//        for subView  in view.subviews {
//            if subView.classForCoder == NetworkErrorView.classForCoder() {
//                subView.removeFromSuperview()
//            }
//        }
    }
    
    /**
     错误视图初始化
     */
//    func loadDataError() {
//        //没有网络的时候添加 无网络视图 --- NetworkErrorView
//        self.errorView = NSBundle.mainBundle().loadNibNamed("NetworkErrorView", owner: nil, options: nil).first as!  NetworkErrorView
//        self.errorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
//        self.errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadData)))
//        self.errorView.backgroundColor = DEFAULT_GRAYCOLOR
//        self.view.addSubview(self.errorView)
//        
//    }
    /**
     显示错误视图
     */
//    func showErrorView(){
//        
//        if errorView == nil {
//            self.loadDataError()
//        }
//        errorView.hidden = false
//    }
    
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
    func dropDownLoading(){
        
        listView.mj_footer = MJRefreshAutoNormalFooter {
            self.loadData()
        }
    }
    
    /**
     * 连接服务器读取数据
     */
    override func loadData() {
       
        
    }
    
    /*
     DZNEmptyDataSetSource Methods  (数据空时的处理方法)
     */
//    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        return NSAttributedString.init(string: "暂无数据111")
//    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let attibutedSting = NSMutableAttributedString.init(string: "没有数据或请求失败")
//        //attibutedSting.addAttribute(NSFontAttributeName, value: UIFont.systemFontSize(CGFloat(14)), range: NSMakeRange(0, 0))
//        return attibutedSting
        return NSAttributedString(string: noneDataPromptTitle!)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "ico_record")
        return UIImage(named: noneDataImageName!)
    }
//    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
//        return NSMutableAttributedString.init(string: "点击刷新一下")
//    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -64.0
    }
//    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
////        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
////        [activityView startAnimating];
////        
////        return activityView;
//        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        activityView.startAnimating()
//        return activityView
//    }
    /*
     DZNEmptyDataSetDelegate Methods  (数据空时的处理方法)
     */
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
       
        self.loadData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadData()
    }
    
    //MARK : tableView的delegate以及datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
//        var cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "TableViewCell")
//        }
//        return cell!
//    }
//    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = DEFAULT_GRAYCOLOR
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = DEFAULT_GRAYCOLOR
    }

    
}
