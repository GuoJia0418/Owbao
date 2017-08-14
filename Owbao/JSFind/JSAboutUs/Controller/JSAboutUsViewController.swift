//
//  JSAboutUsViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSAboutUsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topImageView: UIImageView!
    var titleArray = ["走进嗷呜","历程回顾","管理团队","公司资质","多重保障","网站公告","媒体报道"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        topImageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * 224 / 750)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
        if cell == nil  {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableViewCell")
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = titleArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {//公司介绍
            
            let vc = LocationController()
            vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + GSJS as AnyObject,"title":"走进嗷呜"as AnyObject])
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            
            let vc = LocationController()
            vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + LCHG as AnyObject,"title":"历程回顾" as AnyObject])
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 2 {
            
            let vc = LocationController()
            vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + GLTD as AnyObject,"title":"管理团队" as AnyObject])
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 3 {
            
            let vc = LocationController()
            vc.model = HomeBannerModel.init(dict: ["location":BASE_URL + GSZZ as AnyObject,"title":"公司资质" as AnyObject])
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 4 {
            
            let controller = JSSwitchViewsController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if indexPath.row == 5 {
            
            let vc =  PublicNoticeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 6 {
            
            let controller = JSMediaViewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            
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
        let nibNameOrNil = String?("JSAboutUsViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
