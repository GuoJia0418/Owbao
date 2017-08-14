//
//  DiscoverViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/20.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseTableViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "发现"
        self.isShowLeftItem = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return DiscoverTabelViewCell.cellHeightWithIndex(indexPath.section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTabelViewCell_0") as? DiscoverTabelViewCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("DiscoverTabelViewCell", owner: self, options: nil)![0] as? DiscoverTabelViewCell
            }
            
            cell?.tapCallback = {  (callbackType: DiscoverTapCallback) in
                print("点击index = \(callbackType)")
                
                //开始点击事件
                if callbackType == DiscoverTapCallback.invite {
                    
                    let controller = InvitedViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if callbackType == DiscoverTapCallback.activityCenter {
                    
//                    let controller = JSActivityCentreViewController()
//                    self.navigationController?.pushViewController(controller, animated: true)
                    let controller = JSAboutUsViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if callbackType == .openDay { //线下活动
//                    let controller = JSOfflineActivityViewController()
//                    self.navigationController?.pushViewController(controller, animated: true)
                    let vc = LocationController()
                    vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + MoreSecurity_Api as AnyObject,"title":"安全保障" as AnyObject])
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if callbackType == DiscoverTapCallback.serviceCenter {
                    
                    let controller = JSServiceCentreViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if callbackType == DiscoverTapCallback.safeguard { //安全保障
                    
                    
                } else if callbackType == DiscoverTapCallback.aboutJS { //关于嗷呜
                    
                }
            }
            
            return cell!
            
        } else {
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTabelViewCell_2") as? DiscoverTabelViewCell
                
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("DiscoverTabelViewCell", owner: self, options: nil)![2] as? DiscoverTabelViewCell
                }
                return cell!

            } else if indexPath.row == 1 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTabelViewCell_1") as? DiscoverTabelViewCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("DiscoverTabelViewCell", owner: self, options: nil)![1] as? DiscoverTabelViewCell
                }
                return cell!
                
            } else  {
                var cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTabelViewCell_1") as? DiscoverTabelViewCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("DiscoverTabelViewCell", owner: self, options: nil)![1] as? DiscoverTabelViewCell
                }
                cell?.titleLabel_cellIndex_1.text = "打赏好评"
                cell?.detailTitleLabel_cellIndex_1.text = ""
                return cell!
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            //复制微信号
            let pastet = UIPasteboard.general
            pastet.string = "jsfax2016"

            let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,
                                                     viewTpye: .third)
            //开始写标题
            popView.titleLabel_first.text = "嗷呜宝公众号"
            popView.titleLabel_first.textColor = UIColor.black
            
            popView.titleLabel_second.text = "微信号已成功复制,请前往微信搜索"
            popView.titleLabel_third.text = "并开始关注我们吧~"
            
            popView.leftButton.setTitle("稍后再去", for: UIControlState())
            popView.rightButton.setTitle("去关注", for: UIControlState())
            popView.setAlertPopViewType(viewTpye: .forth)
            
            if IS_PHONE_WIDTH_320 {
                popView.titleLabel_first.font = UIFont.systemFont(ofSize: 17.0)
                popView.titleLabel_second.font = UIFont.systemFont(ofSize: 15.0)
                popView.titleLabel_third.font = UIFont.systemFont(ofSize: 15.0)
                popView.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
                popView.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            }
            
            popView.conformCallback = {
                
                if WXApi.isWXAppInstalled() == true {
                    UIApplication.shared.openURL(URL(string: "weixin://\(WX_KEY)")!)
                } else {
                    self.view.showTextHud("请先安装微信")
                }
            }
        } else if indexPath.section == 1 && indexPath.row == 2 {
            UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1171321616&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
        }
    }
    
    /*
     上拉加载更多
     */
    override func pullRefresh(){
        
    }
    /**
     下拉刷新
     */
    override func dropDownLoading(){
        
    }
    
    

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("DiscoverViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
