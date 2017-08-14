//
//  InvitedTableViewCell.swift
//  Owbao
//
//  Created by GuoJia on 16/11/24.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvitedTableViewCell: UITableViewCell {

    @IBOutlet weak var showTimeLabel: UILabel!//显示时间label
    @IBOutlet weak var showImageView: UIImageView!//显示图片
    @IBOutlet weak var showNumberLabelLeft: UILabel!//右边显示人数label
    @IBOutlet weak var showNumberLabelRight: UILabel!//左边显示人数label
    @IBOutlet weak var showContentLabel: UILabel!//显示内容label
    @IBOutlet weak var showTitleLabel: UILabel!//推荐送礼活动label
    
    @IBOutlet weak var showTimeLabelTopConstrains: NSLayoutConstraint!
    @IBOutlet weak var showTitleLabelTopContrains: NSLayoutConstraint!
    
    @IBOutlet weak var toGetBgView: UIView!         //马上领取view
    @IBOutlet weak var showMoneyLabel: UILabel!     //马上领取label
    @IBOutlet weak var getMoneyBtn: UIButton!       //去领取的btn
    
    var getMoneyNow: (()->())!       //马上领取block
    var imageTapAction:((_ URLString: String) ->())?
    var model: InvitedModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.getMoneyBtn.layer.cornerRadius = 2
        self.getMoneyBtn.layer.masksToBounds = true
        
        self.showImageView.isUserInteractionEnabled = true
        self.showImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(_imageTapAction)))
    }
    //MARK: 马上领取点击
    @IBAction func getMoneyClick(_ sender: UIButton) {
        if let b = getMoneyNow {
            b()
        }
    }
    
    //CompanyAndYanZiViewController
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    //图片点击事件
    func _imageTapAction() -> () {
        self.imageTapAction!((self.model?.jumpUrl)!)
    }
    
    //模型
    class func cellHightWithModel(_ invitedModel:InvitedModel,unclaimed:Double) -> CGFloat {
        if invitedModel.isPut == 0 {
            return InvitedTableViewCell.cellHightWithImageViewAndLabelDisplayStatus(false, isShowContentLabel: false, willDisplayContent: invitedModel.content, unclaimed: unclaimed)
            
        } else {
//            return InvitedTableViewCell.cellHightWithImageViewAndLabelDisplayStatus(true, isShowContentLabel: true, willDisplayContent: invitedModel.content)
            return InvitedTableViewCell.cellHightWithImageViewAndLabelDisplayStatus(true, isShowContentLabel: false, willDisplayContent: invitedModel.content, unclaimed: unclaimed)
        }
    }
    //设置视图,模型
    func configureCell(_ invitedModel:InvitedModel,unclaimed:Double) -> () {
        
        self.model = invitedModel
        if invitedModel.isPut == 1 {
            self.configureCellWithImageViewAndLabelDisplayStatus(true, isShowContentLabel: true, unclaimed: unclaimed)
            //开始显示
            self.showImageView.sd_setImage(with: URL(string: invitedModel.banner), placeholderImage: Common.image(with: UIColorFromRGB(240, green: 240, blue: 240)), options:SDWebImageOptions.refreshCached)
            self.showTimeLabel.text = self.getTimeString(invitedModel.startTime,endTime:invitedModel.endTime)
            self.showContentLabel.text = invitedModel.content
            
        } else {
            self.configureCellWithImageViewAndLabelDisplayStatus(false, isShowContentLabel: false, unclaimed: unclaimed)
        }
        self.showNumberLabelLeft.text = "\(invitedModel.total)人"
        self.showNumberLabelRight.text = "\(invitedModel.investors)人"
    }
    
    //视图布局设置
    func configureCellWithImageViewAndLabelDisplayStatus(_ isShowImageView: Bool,isShowContentLabel: Bool,unclaimed:Double) {
        self.showImageView?.isHidden = !isShowImageView
        self.showContentLabel.isHidden = !isShowContentLabel
        self.showTimeLabel.isHidden = !isShowContentLabel
        self.showTitleLabel.isHidden = !isShowContentLabel
        
        if isShowImageView == true && isShowContentLabel == true {//全部显示
            
        } else if isShowImageView == false && isShowContentLabel == false {//全部不显示

        } else if isShowImageView == true && isShowContentLabel == false {//显示图片，不内容
            
        } else {//只显示内容，不显示图片
            self.showTitleLabelTopContrains.constant =  8 - 41.0 / 160.0 * SCREEN_WIDTH
            self.showTimeLabelTopConstrains.constant =  8 - 41.0 / 160.0 * SCREEN_WIDTH
        }
        
        if unclaimed != 0
        {
            toGetBgView.isHidden = false
            
            let unclaimedStr = String(unclaimed)
            let attributedString = NSMutableAttributedString(string:"您有" + unclaimedStr + "元任务奖励未领取")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: NSMakeRange("您有".length, unclaimedStr.length))
            showMoneyLabel.attributedText = attributedString
        }
        else
        {
            toGetBgView.isHidden = true
        }
    }
    
    //返回cell的hight的高度
    class func cellHightWithImageViewAndLabelDisplayStatus(_ isShowImageView: Bool,isShowContentLabel: Bool,willDisplayContent: String,unclaimed:Double) -> CGFloat
    {
        if isShowImageView == true && isShowContentLabel == true {//全部显示
            if unclaimed != 0
            {
                return 49 + 10 + 62.0 + 38.0 + InvitedTableViewCell.getHeigth(willDisplayContent) + SCREEN_WIDTH / 160.0 * 41.0
            }
            else
            {
                return 62.0 + 38.0 + InvitedTableViewCell.getHeigth(willDisplayContent) + SCREEN_WIDTH / 160.0 * 41.0
            }
        } else if isShowImageView == false && isShowContentLabel == false {
            if unclaimed != 0
            {
                return 49 + 10 + 62.0 //只显示邀请人数
            }
            else
            {
                return 62.0
            }
        } else if isShowImageView == true && isShowContentLabel == false {//显示图片，不内容
            if unclaimed != 0
            {
                return 49 + 10 + SCREEN_WIDTH / 160.0 * 41.0 + 62.0
            }
            else
            {
                return SCREEN_WIDTH / 160.0 * 41.0 + 62.0
            }
            
        } else {//只显示内容，不显示图片
            if unclaimed != 0
            {
                return 49 + 10 + 62.0 + 38.0 + InvitedTableViewCell.getHeigth(willDisplayContent)
            }
            else
            {
                return 62.0 + 38.0 + InvitedTableViewCell.getHeigth(willDisplayContent)
            }
        }
    }
    
    class func getHeigth(_ content: String) -> CGFloat {
        if content == "" {
            return 0.0
        } else {
            let height = content.getTextRectSize(UIFont.systemFont(ofSize: 12.0),size:CGSize(width: SCREEN_WIDTH - 30.0, height: 3000.0)).size.height
            return height
        }

    }
    
    func getTimeString(_ beginTime: Double,endTime: Double) -> String {
        var timeString = ""
        let beginTimeDate = Date.init(timeIntervalSince1970: beginTime / 1000)
        let endTimeDate = Date.init(timeIntervalSince1970: endTime / 1000)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        let formatSecond = DateFormatter()
        formatSecond.dateFormat = "MM月dd日"
        timeString = "\(format.string(from: beginTimeDate))-\(formatSecond.string(from: endTimeDate))"
        return timeString
    }
}
