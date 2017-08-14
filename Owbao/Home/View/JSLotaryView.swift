//
//  JSLotaryView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/4/25.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSLotaryView: UIView {

    var closeBlock:(() ->())!
    weak var wd: UIWindow?
    @IBAction func closeClick(_ sender: UIButton) {
        self.wd?.isHidden = true
        self.wd = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /**
     * 创建并于UIWindow上显示popView
     * @param back:() ->()，闭包回调，当点击前往邀请那个button回调
     * @param imageURLString popView上显示的图片
     * @return popView的superView
     */
    
    class func dispayPopView() -> (UIWindow)
    {
        let popView: JSLotaryView = Bundle.main.loadNibNamed("JSLotaryView", owner: self, options:nil)?.first as! JSLotaryView
        popView.frame = CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT)
        popView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
        //创建显示窗口
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.addSubview(popView)
        window.makeKeyAndVisible()
        popView.wd = window
        return window
    }


}
