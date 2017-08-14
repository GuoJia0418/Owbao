//
//  InvitedBottowPushView.swift
//  Owbao
//
//  Created by GuoJia on 16/11/24.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//  封装的分享视图

import UIKit

//注意：微信分享设置image即可，字段imageURLString无效。QQ分享，设置imageURLString即可，字段image无效（QQ分享本地图片加载不出来）
class ShareInfoModel: NSObject {
    var descriptionTitle  = ""      //副标题
    var imageURLString = ""         //分享图片服务器地址
    var image:UIImage? = UIImage()  //分享的图片image
    var URLString = ""      //分享网页地址
    var title = ""          //分享的标题
    
    
    init(shareImageURLString: String,shareImage: UIImage,shareURLString: String,shareTitle: String,shareDescription: String) {
        super.init()
        imageURLString = shareImageURLString
        image = shareImage
        URLString = shareURLString
        title = shareTitle
        descriptionTitle = shareDescription
    }
}

class InvitedBottowPushView: UIView {
    
    //**************分享到QQ**************//
    @IBOutlet weak var qqShareButton: UIButton! //qq分享按钮
    @IBOutlet weak var qqShareLabel: UILabel! //qq分享按钮下面label
    
    //**************分享到朋友圈**************//
    @IBOutlet weak var wxShareToFriendCircle: UIButton! //微信分享按钮
    @IBOutlet weak var wxShareToFriendCircleXConstains: NSLayoutConstraint! //分享到朋友圈centerX约束
    @IBOutlet weak var wxShareToFriendLabelCircleXConstains: NSLayoutConstraint! //朋友圈label的centerX约束
    
    //**************分享给朋友**************//
    @IBOutlet weak var wxShareToFriendsButton: UIButton! //微信分享给朋友按钮
    @IBOutlet weak var wxShareToFriendLabelCenterXConstains: NSLayoutConstraint! //微信label的centerX约束
    @IBOutlet weak var wxShareToFriendButtonCenterXConstains: NSLayoutConstraint! //分享给朋友button的centerX约束
    @IBOutlet weak var wxShareToFriendsLabel: UILabel!
    
    //**************回调函数**************//
    var shareCallback:((_ isSuccess: Bool) -> ())? //分享后的回调
    var clickShareButtonCallback:(()->())?   //点击朋友圈、微信、QQ按钮即刻回调
    
    @IBOutlet weak var bottowView: UIView!
    @IBOutlet weak var bottomViewHeightConstains: NSLayoutConstraint!
    
    var wxToFiendModel: ShareInfoModel = ShareInfoModel(shareImageURLString: "", shareImage: UIImage.init(), shareURLString: "", shareTitle: "",shareDescription: "")
    var wxTimelineModel: ShareInfoModel = ShareInfoModel(shareImageURLString: "", shareImage: UIImage.init(), shareURLString: "", shareTitle: "",shareDescription: "")
    var qqModel: ShareInfoModel = ShareInfoModel(shareImageURLString: "", shareImage: UIImage.init(), shareURLString: "", shareTitle: "",shareDescription: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = PopView_BackgroundColor
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(cancelAction(_:))))
    }
    
    /**
     * 分享视图初始化(动画般从下向上推出)
     *
     * @param   WXToFriendModel：分享给朋友的模型，WXTimelineModel：分享到朋友圈，QQModel：分享到QQ
     *
     * @returen 返回InvitedBottowPushView视图
     */
    class func animateWindowsAddSubView(_ WXToFriendModel:ShareInfoModel,WXTimelineModel: ShareInfoModel,QQModel: ShareInfoModel) -> (InvitedBottowPushView) {
        //创建pushView
        let pushView = Bundle.main.loadNibNamed("InvitedBottowPushView", owner: self, options: nil)?.last as? InvitedBottowPushView
        pushView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pushView!.bottowView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 150.0)
        pushView?.wxToFiendModel = WXToFriendModel
        pushView?.wxTimelineModel = WXTimelineModel
        pushView?.qqModel = QQModel
        UIApplication.shared.keyWindow?.addSubview(pushView!)
        
        //动画般显示pushView
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            pushView!.bottowView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 150, width: SCREEN_WIDTH, height: 150.0);
        }) { finished -> () in
        }
        return pushView!
    }
    
    /**
     *  分享视图移除(动画般从上向下移除)
     */
    class func animateRemoveFromSuperView(_ pushView: InvitedBottowPushView,animate: Bool) -> () {
        
        if animate == true {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                pushView.bottowView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH,height: 150.0);
            }) { finished ->() in
                pushView.removeFromSuperview()
            }
            
        } else {
            pushView.removeFromSuperview()
        }
    }
    
    /**
     *  隐藏QQ分享（分享到朋友圈、分享给朋友重新设置位置，移到1/4位置）
     *
     */
    func hiddenQQShareButton() -> () {
        //1.先隐藏QQ按钮、label
        self.qqShareButton.isHidden = true
        self.qqShareLabel.isHidden = true
        
        //2.分享到朋友圈,吧分享到朋友圈移到1/4位置
        self.wxShareToFriendCircleXConstains.constant = SCREEN_WIDTH  / 4.0
        self.wxShareToFriendLabelCircleXConstains.constant = SCREEN_WIDTH  / 4.0
        
        //3.把分享给朋友按钮、微信label移到-1/4位置 （根据 53/160比例算出来）
        self.wxShareToFriendButtonCenterXConstains.constant = 27 * SCREEN_WIDTH / 320
        self.wxShareToFriendLabelCenterXConstains.constant = 27 * SCREEN_WIDTH / 320
    }
    
    func hiddenQQShareButtonShareToFriends() -> () {
        
        //1.隐藏QQ按钮、label
        self.qqShareButton.isHidden = true
        self.qqShareLabel.isHidden = true
        
        //2.隐藏分享给朋友
        self.wxShareToFriendsButton.isHidden = true
        self.wxShareToFriendsLabel.isHidden = true
    }
    
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        let button = sender as! UIButton
        InvitedBottowPushView.animateRemoveFromSuperView(self,animate: false) //移除当前视图
        
        if button.tag == 0 {//微信
            if WXApi.isWXAppInstalled() == true {
                
                PD_Share.shareInstance().wxShare(toFriends: self.wxToFiendModel.title, description: self.wxToFiendModel.descriptionTitle,withURL: self.wxToFiendModel.URLString, with: self.wxToFiendModel.image) {(isSuccess: Bool) in
                    
                    if self.shareCallback != nil {
                        self.shareCallback!(isSuccess)
                    }
                }
                
                //点击分享按钮回调
                if self.clickShareButtonCallback != nil {
                    self.clickShareButtonCallback!()
                }
                
            } else {
                self.showTextHud("请先安装微信")
            }
            
        } else if button.tag == 1 {//朋友圈
            
            if WXApi.isWXAppInstalled() == true {
                
                PD_Share.shareInstance().wxShare(self.wxTimelineModel.title, description:self.wxTimelineModel.descriptionTitle, withURL: self.wxTimelineModel.URLString, with: self.wxTimelineModel.image, withScene: 1) { (isSuccess: Bool) in
                    
                    if self.shareCallback != nil {
                        self.shareCallback!(isSuccess)
                    }
                }
                
                //点击分享按钮回调
                if self.clickShareButtonCallback != nil {
                    self.clickShareButtonCallback!()
                }
                
            } else {
                self.showTextHud("请先安装微信")
            }
        } else if button.tag == 2 {//QQ
            
            if QQApiInterface.isQQInstalled() == true {
                
                QQShareManager.default().qqShare(self.qqModel.title, description: self.qqModel.descriptionTitle, withKey: QQ_KEY, withURL: self.qqModel.URLString, withImage: self.qqModel.imageURLString, callback: { (shareResult: Bool) in
                    
                    if self.shareCallback != nil {
                        self.shareCallback!(shareResult)
                    }
                })
                
                //点击分享按钮回调
                if self.clickShareButtonCallback != nil {
                    self.clickShareButtonCallback!()
                }
                
            } else {
                self.showTextHud("请先安装QQ")
            }
        }
    }
    
    //取消操作
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        InvitedBottowPushView.animateRemoveFromSuperView(self,animate: true)
    }
    
    func cancelAction(_ tap: UITapGestureRecognizer) -> () {
        let location  = tap.location(in: self)
        if  location.y < SCREEN_HEIGHT - 150.0 {
            InvitedBottowPushView.animateRemoveFromSuperView(self,animate: true)
        }
    }
}
