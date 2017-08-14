//
//  RootTabBarController.swift
//  Owbao
//
//  Created by user on 16/6/24.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    var defaultImageArray: [String] = []
    var selectImageArray: [String] = []
    var itemTitleArray: [String] = []
    
    var model: TabbarActivityModel? {
        didSet{
            
            if (model != nil) && (model?.map?.isInDoubleEggActivity == true) && (model?.map != nil) {
                self.defaultImageArray = ["year_home_n","year_fund_n","year_account_n","year_more_n"]
                self.selectImageArray = ["year_home_s","year_fund_s","year_account_s","year_more_s"]
            } else {
                self.defaultImageArray = ["ico_home_n","ico_fund_n","ico_account_n","ico_more_n"]
                self.selectImageArray = ["ico_home_s","ico_fund_s","ico_account_s","ico_more_s"]
            }
            
            for i in 0...defaultImageArray.count - 1 {
                let item = UITabBarItem()
                item.image = UIImage(named: defaultImageArray[i])
                item.selectedImage = UIImage(named: selectImageArray[i])
                
                item.imageInsets = UIEdgeInsets(top: 3,left: 0,bottom: -3,right: 0)
                self.viewControllers![i].tabBarItem = item
            }
            
            self.view.backgroundColor = UIColor.white
            self.tabBar.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildViewControllers()
        self.createBarItem()
    }
    
    //MARK: 是否处于活动期
    func downloadData() {
        TabbarActivityApi().startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("输出数据\(resultDict)")
            self.model = TabbarActivityModel(dict: resultDict!)
        }) { (request:YTKBaseRequest!) in
            self.createBarItem()
        }
    }
    
    //MARK: 初始化子控制器
    func setupChildViewControllers() {
        self.addChildVC(MainViewController())
        self.addChildVC(JSInvestFinancingActivityController())
        self.addChildVC(DiscoverViewController())
        self.addChildVC(JSMyAccountViewController())
    }
    
    //MARK: 添加子控制器
    func addChildVC(_ vc:UIViewController) {
        self.addChildViewController(RootNavigationController(rootViewController:vc))
    }
    
    //MARK: 创建tabBarItem
    func createBarItem() {
        self.view.backgroundColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.itemTitleArray = ["精选","理财","发现","我的"]
        self.defaultImageArray = ["jingxuan","invest","find","me"]
        self.selectImageArray = ["jingxuan_s","invest_s","find_s","me_s"]
        
        var dict:[String:AnyObject] = [:]
        dict[NSForegroundColorAttributeName] = Default_TabBar_Title_Color
        UITabBarItem.appearance().setTitleTextAttributes(dict, for: UIControlState.selected)
        
        for i in 0...defaultImageArray.count - 1 {
            let item = UITabBarItem()
            item.image = UIImage(named: defaultImageArray[i])
            item.title = itemTitleArray[i]
            item.selectedImage = UIImage(named: selectImageArray[i])
            
            item.imageInsets = UIEdgeInsets(top: 3,left: 0,bottom: -3,right: 0)
            self.viewControllers![i].tabBarItem = item
        }
    }
}
