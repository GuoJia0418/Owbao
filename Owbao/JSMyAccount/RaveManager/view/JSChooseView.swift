//
//  JSChooseView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/31.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSChooseView: UIView {

    @IBOutlet weak var leftTitleLabel_1: UILabel! //左边label
    @IBOutlet weak var titleLabel_1: UILabel!
    @IBOutlet weak var indicateImageView: UIImageView!
    @IBOutlet weak var button_1: UIButton!
    @IBOutlet weak var backgroundView_1: UIView!
    
    //第2个
    @IBOutlet weak var titleLabel_2: UILabel!
    @IBOutlet weak var button_2: UIButton!
    @IBOutlet weak var backgroundView_2: UIView!
    
    @IBOutlet weak var bottomViewHeightConstains: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstains_2: NSLayoutConstraint!
    
    //底部按钮
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    private var indicateFlag: Int = 0 //默认是第一个
    private var status: Int = 0  //0：表示存管和平台账户都存在,1：表示只有存管账户，2：只有平台账户
    
    var bottomClickCallback: ((_ indicateFlag: Int,_ status: Int) -> Void)? //底部按钮点击回调
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomButton.layer.cornerRadius = 4
        self.bottomButton.layer.masksToBounds = true
        self.backgroundColor = PopView_BackgroundColor
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureCloseAction)))
    }
    
    //点击空白取消
    func gestureCloseAction(getrue: UITapGestureRecognizer) {
        
        let point: CGPoint = getrue.location(in: self)
        
        let minY = self.bottomView.frame.minY
        
        if point.y < minY {
            JSChooseView.animateRemoveFromSuperView(chooseView: self,
                                                    animate: true,
                                                    status: self.status)
        }
    }
    
    /**
     * 选择视图初始化(动画般从下向上推出)
     * status: 0：表示存管和平台账户都存在,1：表示只有存管账户，2：只有平台账户
     */
    class func animateWindowsAddSubView(status: Int) -> JSChooseView {
        
        //创建pushView
        let chooseView = Bundle.main.loadNibNamed("JSChooseView", owner: self, options: nil)?.last as? JSChooseView
        
        let chooseViewHeight = chooseView?.configureCellDisplayStatus(status: status)
        
        chooseView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        chooseView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: chooseViewHeight!)
        chooseView?.bottomViewHeightConstains.constant = chooseViewHeight!
        
        UIApplication.shared.keyWindow?.addSubview(chooseView!)
        
        //动画般显示pushView
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            chooseView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - chooseViewHeight!, width: SCREEN_WIDTH, height: chooseViewHeight!)
        }) { finished -> () in
        }
        
        return chooseView!
        
    }
    
    /**
     *  选择视图初始化(动画般从上向下移除)
     *  status: 0：表示存管和平台账户都存在,1：表示只有存管账户，2：只有平台账户
     */
    class func animateRemoveFromSuperView(chooseView: JSChooseView,
                                          animate: Bool,
                                          status: Int) {
        
        let chooseViewHeight = chooseView.configureCellDisplayStatus(status: status)
        
        if animate == true {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                chooseView.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: chooseViewHeight)
            }) { finished ->() in
                chooseView.removeFromSuperview()
            }
            
        } else {
            chooseView.removeFromSuperview()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        JSChooseView.animateRemoveFromSuperView(chooseView: self,
                                                animate: true,
                                                status: self.status)
    }
    
    @IBAction func buttonClickAction_1(_ sender: Any) {
        self.indicateFlag = 0
        self.setButtonDisplayImage()
    }
    
    @IBAction func buttonClickAction_2(_ sender: Any) {
        self.indicateFlag = 1
        self.setButtonDisplayImage()
    }
    
    @IBAction func buttonClickAction_top(_ sender: Any) {
        self.indicateFlag = 0
        self.setButtonDisplayImage()
    }
    
    @IBAction func buttonClickAction_bottom(_ sender: Any) {
        self.indicateFlag = 1
        self.setButtonDisplayImage()
    }
    
    //设置按钮选中为状态/未选中状态
    func setButtonDisplayImage() {
        if self.indicateFlag == 0 { //选中第一个
            self.button_1.setImage(UIImage(named: "选中.png"), for: .normal)
            self.button_2.setImage(UIImage(named: "未选中.png"), for: .normal)
        } else {
            self.button_1.setImage(UIImage(named: "未选中.png"), for: .normal)
            self.button_2.setImage(UIImage(named: "选中.png"), for: .normal)
        }
    }
    
    //底部下一步按钮点击事件
    @IBAction func bottomButtonClick(_ sender: Any) {
        
        if self.bottomClickCallback != nil {
            self.bottomClickCallback!(self.indicateFlag,self.status)
        }
        
        JSChooseView.animateRemoveFromSuperView(chooseView: self,
                                                animate: false,
                                                status: self.status)
    }
    
    /**
     * status: 0：表示存管和平台账户都存在,1：表示只有存管账户，2：只有平台账户
     * @return 整个视图的高度
     */
    private func configureCellDisplayStatus(status: Int) -> CGFloat {
        
        self.status = status
        
        if status == 0 { //存管和平台账户都存在
            
            
        } else if status == 1 { //只有存管账户
            self.backgroundView_2.isHidden = true
            self.indicateImageView.isHidden = true
            self.leftTitleLabel_1.text = "银行存管账户"
            self.backgroundViewHeightConstains_2.constant = 15
            return 190
        } else if status == 2 { //只有平台账户
            self.backgroundView_2.isHidden = true
            self.indicateImageView.isHidden = true
            self.leftTitleLabel_1.text = "平台账户"
            self.backgroundViewHeightConstains_2.constant = 15
            return 190
        }
        return 240
    }
}

