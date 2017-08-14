//
//  JSExperienceDisplayInfoCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/23.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSExperienceDisplayInfoCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var titleLabelTopContrains: NSLayoutConstraint! //正常的是17
    @IBOutlet weak var detailLabel: UILabel!
    
    var tapActionCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backView.layer.cornerRadius = 10
        self.backView.layer.masksToBounds = true
        self.backView.layer.borderColor = UIColorFromRGB(230, green: 230, blue: 230).cgColor
        self.backView.layer.borderWidth = 1
        
        self.rightButton.layer.cornerRadius = 3
        self.rightButton.layer.masksToBounds = true
    }

    //配置模型
    func configureCell(_ couponsModel: MyCouponsListModel) -> () {
        
        if couponsModel.type == 3 { //3 为体验金
            
            self.titleLabel.text = "体验金\((couponsModel.amount))元"
            self.timeLabel.text = "\(TimeStampToString(couponsModel.addtime, isHMS: false)) 获得"
            self.sourceLabel.text = "来源: \(couponsModel.remark!)"
            
            if couponsModel.status == 0 { //0未只用
            
                self.rightButton.backgroundColor = UIColorFromRGB(228, green: 71, blue: 74)
                self.rightButton.isEnabled = true
                
                if couponsModel.source == 100 { //未激活
                    
                    self.rightButton.setTitle("立即激活", for: UIControlState())
                    
                } else if couponsModel.source == 99 { //激活了的新手注册的体验金
                    
                    self.rightButton.setTitle("立即使用", for: UIControlState())
                    
                } else {
                    
                    self.rightButton.setTitle("立即使用", for: UIControlState())
                }
                
            } else if couponsModel.status == 1 { //1已使用
                
                self.rightButton.setTitle("已使用", for: UIControlState())
                self.rightButton.backgroundColor = UIColorFromRGB(193, green: 193, blue: 193)
                self.rightButton.isEnabled = false
                
            } else if couponsModel.status == 2 { //已失效
                self.rightButton.backgroundColor = UIColorFromRGB(193, green: 193, blue: 193)
                self.rightButton.setTitle("已过期", for: UIControlState())
                self.rightButton.isEnabled = false
            }
            
            self.configureExperience(couponsModel) //配置是否显示detailLabel
        }
    }
    
    //配置是否显示detailLabel
    func configureExperience(_ couponsModel: MyCouponsListModel) -> () {
        
        if couponsModel.source == 100 || couponsModel.source == 99 { //未激活
            self.sourceLabel.text = "来源: 新手体验金"
            //显示出detailLable
            self.titleLabelTopContrains.constant = 10
            self.detailLabel.isHidden = false
        } else {
            self.sourceLabel.text = "来源: 普通体验金"
            //隐藏detailLable
            self.titleLabelTopContrains.constant = 17
            self.detailLabel.isHidden = true
        }
    }
    
    @IBAction func clickButtonAction(_ sender: AnyObject) {
        
        if self.tapActionCallback != nil {
            self.tapActionCallback!()
        }
    }
    
    class func cellHeight() -> CGFloat  {
        return 130
    }
}

class backView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let currentContext = UIGraphicsGetCurrentContext()
        //设置虚线颜色
        currentContext!.setStrokeColor(UIColor(red: 193 / 255.0, green: 193 / 255.0, blue: 193 / 255.0, alpha: 1.0).cgColor)
        //设置虚线宽度
        currentContext!.setLineWidth(1.0)
        //设置虚线绘制起点
        currentContext!.move(to: CGPoint(x: 10, y: self.frame.size.height / 2 + 10))
        //设置虚线绘制终点
        currentContext!.addLine(to: CGPoint(x: self.width - 10, y: self.frame.size.height / 2 + 10))
        //设置先排列的宽度间隔
        let lengths: [CGFloat] = [3, 1]
        
        //下面最后一个参数“2”代表排列的个数。
//        currentContext?.setLineDash(phase: 0, lengths: 2)
//        CGContextSetLineDash(currentContext!,0, lengths, 2)
        currentContext?.setLineDash(phase: 0, lengths: lengths)
        
        currentContext!.drawPath(using: CGPathDrawingMode.stroke)
    }
}
