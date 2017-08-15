//
//  JSCouponBaseViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/8/14.
//  Copyright © 2017年 Owbao. All rights reserved.
//

import UIKit

class JSCouponBaseViewController: BaseViewController,SwitchTitleViewDelegate {
    var ctrlArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //去投资
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "去投资", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goInvest))
        
        //自定义导航栏标题
        let titleView = UIView(frame: CGRect(x: 0,y: 0, width: 100, height: 40))
        
        //label
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 0, width: 60, height: 40)
        label.text = "优惠券"
        label.textAlignment = .center
        titleView.addSubview(label)
        
        //button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "问号.png")?.withTintColor(UIColorFromRGB(250, green: 76, blue: 66)), for: UIControlState())
        button.addTarget(self, action: #selector(buttonClickAction), for: .touchUpInside)
        button.frame = CGRect(x: 60, y: 0, width: 40, height: 40)
        titleView.addSubview(button)
        navigationItem.titleView = titleView
        
        let switchView = SwitchTitleView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 44))
        switchView.backgroundColor = UIColor.red
        switchView.btnSelectedBgImage = UIImage(named: "tiao")
        switchView.titleBarHeight = 44
        switchView.btnTitlefont = 17.0
        switchView.btnSelectedColor = UIColor.darkGray
        switchView.btnNormalColor = UIColor.lightGray
        switchView.titleBarColor = UIColor.white
        switchView.titleViewDelegate = self
        self.view.addSubview(switchView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColorFromRGB(230, green: 230, blue: 230)
        switchView.addSubview(lineView)
        
        //创建controller
        let controller = JSCouponViewController()
        controller.couponType = 2
        controller.title = "返现红包"
        
        let controller_1 = JSCouponViewController()
        controller_1.couponType = 3
        controller_1.title = "加息券"
        
        self.ctrlArray.add(controller)
        self.ctrlArray.add(controller_1)
        
        self.addChildViewController(controller)
        self.addChildViewController(controller_1)
        
        switchView.reloadData()
        
    }
    
    //MARK: - 去投资
    func goInvest() {
        RootNavigationController.goToInvestList(controller: self)
    }
    
    //按钮点击action
    func buttonClickAction() -> () {
        let controller = JSCouponExplainViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: SwitchTitleViewDelegate
    func number(ofTitleBtn View: SwitchTitleView!) -> UInt {
        return 2
    }
    
    func titleView(_ View: SwitchTitleView!, viewControllerSetWithTilteIndex index: UInt) -> UIViewController! {
        return self.ctrlArray.object(at: Int(index)) as! UIViewController
    }
    
    @IBAction func bottowTapAction(_ sender: Any) {
        let validCouponVC = JSInvalidCouponViewController()
        self.navigationController?.pushViewController(validCouponVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
