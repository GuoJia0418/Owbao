//
//  JSRechargeAndWithdrawsCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSRechargeAndWithdrawsCell: UITableViewCell {
    @IBOutlet weak var withdrawBtn: UIButton!       //提现
    @IBOutlet weak var rechargeBtn: UIButton!       //充值
    @IBOutlet weak var alertView: UIView!       //温馨提示View
    @IBOutlet weak var alertMsgLabel: UILabel!  //温馨提示消息
    
    var withdrawBlock:(()->())!        //提现block
    var rechargeBlock:(()->())!        //充值block
    var newHandBlock:(()->())!         //新手标block
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView()
    {
        withdrawBtn.layer.cornerRadius = 5.0
        withdrawBtn.layer.masksToBounds = true
        withdrawBtn.layer.borderColor = UIColorFromRGB(192, green: 192, blue: 192).cgColor
        withdrawBtn.layer.borderWidth = 1.0
        
        rechargeBtn.layer.cornerRadius = 5.0
        rechargeBtn.layer.masksToBounds = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //显示与隐藏alertView
    func setupModel(_ model:MyAccountModel?)
    {
        alertView.isHidden = true
        
//        if model?.map?.isNewHand == 1 && model?.map != nil
//        {
//            alertView.hidden = false
//            alertMsgLabel.text = "温馨提示:您有1次新手投资机会，赶紧去赚钱吧！"
//        }
//        else
//        {
            if model?.map != nil && model?.map?.isPerfect != 1
            {
                alertView.isHidden = false
            
                let sub1Str = "温馨提示:您有收礼信息尚未完善，"
                let sub2Str = "立即完善"
                let attributedString = NSMutableAttributedString(string: sub1Str + sub2Str)
                attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1 as Int), range: NSMakeRange(sub1Str.characters.count, sub2Str.characters.count))
                self.alertMsgLabel.attributedText = attributedString //设置下划线
            }
            else
            {
               alertView.isHidden = true
            }
//
//        }
    }
    
    //MARK: 提现
    @IBAction func withdrawClick(_ sender: UIButton) {
        if let block = withdrawBlock{
            block()
        }
    }
    
    //MARK: 充值
    @IBAction func rechargeClick(_ sender: UIButton) {
        if let block = rechargeBlock{
            block()
        }
    }
    
    
    //MARK: 温馨提示到新手标
    @IBAction func newhandClick(_ sender: UIButton) {
        if let block = newHandBlock{
            block()
        }
    }
    
}
