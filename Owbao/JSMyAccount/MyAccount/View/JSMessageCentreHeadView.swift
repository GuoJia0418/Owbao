//
//  JSMessageCentreHeadView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/28.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSMessageCentreHeadView: UIView {

    var tapCallBack:((_ handleModel: MailRowsModel) -> ())? //处理过的模型
    var saveModel: MailRowsModel? //保存的模型
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! //标题label
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBAction func tapActionCallback(_ sender: AnyObject) {
        if saveModel != nil  {
            saveModel!.isOpen = !(saveModel?.isOpen)! //置为相反
            if self.tapCallBack != nil  {
                self.tapCallBack!(saveModel!) //回调
            }
        }
    }
    
    //配置视图
    func configureHeaderView(_ model: MailRowsModel?) -> () {
        
        saveModel = model //保存模型
        if model != nil {
            if model!.isOpen {
                self.indicatorImageView.image = UIImage(named: "收缩")
            } else {
                self.indicatorImageView.image = UIImage(named: "展开")
            }
            self.titleLabel.text = model!.title
            self.timeLabel.text = "\(TimeStampToString((model?.addTime)!, isHMS: false))"
        }
    }
}
