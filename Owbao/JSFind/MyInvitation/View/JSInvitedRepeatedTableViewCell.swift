//
//  JSInvitedRepeatedTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSInvitedRepeatedTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bottomBackgroundView: UIView! //底部tableView的背景view
    @IBOutlet weak var subTableView: UITableView!
    @IBOutlet weak var noneItemBackgroundView: UIView! //无数据背景view
    
    var invitedModel: JSInvitedModel? //保存
    var index: Int = 0 //表示是那个cell 0表示基础奖励cell  1表示进阶奖励cell
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var indicateLabel: UILabel! //完成首投的好友label&完成复投的好友label
    @IBOutlet weak var inviteNumberLabel: UILabel! //邀请总数
    @IBOutlet weak var investNumberLabel: UILabel! //投资总数
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleBackgroundView1: UIView!
    @IBOutlet weak var titleBackgroundView2: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bottomBackgroundView.layer.borderColor = UIColorFromRGB(239, green: 239, blue: 239).cgColor
        self.bottomBackgroundView.layer.borderWidth = 1
        self.subTableView.tableFooterView = UIView()
    }
    
    func configureCell(_ invitedModel: JSInvitedModel?,index: Int) {
        self.index = index //保存cell
        self.invitedModel = invitedModel //保存模型
        
        if invitedModel != nil && invitedModel?.map != nil {
            
            if index == 0 {
                
                self.detailTitleLabel.text = "每邀请一位好友首投≥1000元,可获得10元返现"
                self.indicateLabel.text = "完成首投的好友"
                
                let string = "\((invitedModel?.map!.firstInvestCount)!)位"
                let attriString = NSMutableAttributedString(string: string)
                attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(233, green: 48, blue: 56), range: NSRange(location: 0, length: string.length - 1))
                self.investNumberLabel.attributedText = attriString
                
                self.titleBackgroundView1.isHidden = false
                self.titleBackgroundView2.isHidden = true
                self.titleLabel.text = "基础奖励"
                
                if self.invitedModel?.map?.firstInvestList.count > 0 {
                    self.subTableView.isHidden = false
                    self.noneItemBackgroundView.isHidden = true
                    self.subTableView.reloadData()
                } else {
                    self.subTableView.isHidden = true
                    self.noneItemBackgroundView.isHidden = false
                }
                
            } else {
                
                self.detailTitleLabel.text = "获好友第2笔及第3笔投资收益30%的现金返现"
                self.indicateLabel.text = "完成复投的好友"
                
                let string = "\((invitedModel?.map!.reInvestCount)!)位"
                let attriString = NSMutableAttributedString(string: string)
                attriString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(233, green: 48, blue: 56), range: NSRange(location: 0, length: string.length - 1))
                self.investNumberLabel.attributedText = attriString
                
                self.titleBackgroundView1.isHidden = true
                self.titleBackgroundView2.isHidden = false
                self.titleLabel.text = "进阶奖励"
                
                if self.invitedModel?.map?.repeatInvestList.count > 0 {
                    self.subTableView.isHidden = false
                    self.noneItemBackgroundView.isHidden = true
                    self.subTableView.reloadData()
                } else {
                    self.subTableView.isHidden = true
                    self.noneItemBackgroundView.isHidden = false
                }
            }
    
            self.inviteNumberLabel.text = "\((invitedModel?.map!.recommendedCount)!)位"
        }
    }
    
    class func cellHeight() -> CGFloat {
        return 280
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.invitedModel != nil && self.index == 0 && self.invitedModel?.map != nil {
            
            return (self.invitedModel?.map?.firstInvestList.count)!
            
        } else if self.invitedModel != nil && self.index == 1 {
            
            return (self.invitedModel?.map?.repeatInvestList.count)!
        }
        
        return 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.index == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedSubDisplayInfoCell") as! JSInvitedSubDisplayInfoCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedSubDisplayInfoCell", owner: self, options: nil)![0] as? JSInvitedSubDisplayInfoCell
            }
        
            cell?.configureCell(self.invitedModel?.map?.firstInvestList[indexPath.row])
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedSubDisplayInfoCell") as! JSInvitedSubDisplayInfoCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedSubDisplayInfoCell", owner: self, options: nil)![1] as? JSInvitedSubDisplayInfoCell
            }
            cell?.configureCell_xib1(self.invitedModel?.map?.repeatInvestList[indexPath.row])
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
