//
//  JSSwitchViewsController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/18.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSwitchViewsController: BaseViewController,SwitchTitleViewDelegate {

    var ctrlArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "多重保障"
        
        let switchView = SwitchTitleView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 74))
        switchView.backgroundColor = UIColor.red
        switchView.btnSelectedBgImage = UIImage(named: "tiao")
        switchView.titleBarHeight = 44
        switchView.btnTitlefont = 17.0
        switchView.btnSelectedColor = UIColorFromRGB(231, green: 42, blue: 18)
        switchView.btnNormalColor = UIColor.darkGray
        switchView.titleBarColor = UIColor.white
        switchView.titleViewDelegate = self
        self.view.addSubview(switchView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColorFromRGB(230, green: 230, blue: 230)
        switchView.addSubview(lineView)
        
        //创建controller
        let controller = JSWebViewController()
        controller.index = 0
        controller.title = "三亿验资"
        
        let controller_1 = JSWebViewController()
        controller_1.index = 1
        controller_1.title = "保证金专户"
        
        self.ctrlArray.add(controller)
        self.ctrlArray.add(controller_1)
        
        self.addChildViewController(controller)
        self.addChildViewController(controller_1)
        
        switchView.reloadData()
    }
    
    //MARK: SwitchTitleViewDelegate
    func number(ofTitleBtn View: SwitchTitleView!) -> UInt {
        return 2
    }
    
    func titleView(_ View: SwitchTitleView!, viewControllerSetWithTilteIndex index: UInt) -> UIViewController! {
        return self.ctrlArray.object(at: Int(index)) as! UIViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSSwitchViewsController")
        self.init(nibName: nibNameOrNil, bundle: nil)
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
