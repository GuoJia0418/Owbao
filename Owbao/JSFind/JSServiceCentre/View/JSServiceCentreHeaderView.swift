//
//  JSServiceCentreHeaderView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSServiceCentreHeaderView: UIView {
    
    //************* 第二2个xib **************//
    var tapCallBack:((_ handleModel: JSServiceCentreHotProblemDetailModel) -> ())? //处理过的模型
    var saveModel: JSServiceCentreHotProblemDetailModel? //保存的模型
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel_1: UILabel!
    @IBOutlet weak var indicatorImageView_1: UIImageView!
    
    @IBAction func tapActionCallback(_ sender: AnyObject) {
        
        if saveModel != nil  {
            
            saveModel!.isOpen = !(saveModel?.isOpen)! //置为相反
            if self.tapCallBack != nil  {
               self.tapCallBack!(saveModel!) //回调
            }
        }
    }
    
    //配置视图
    func configureHeaderView(_ model: JSServiceCentreHotProblemDetailModel) -> () {
        
        saveModel = model //保存模型
        
        if model.isOpen {
            self.indicatorImageView_1.image = UIImage(named: "收缩.png")
            self.lineView.isHidden = true
        } else {
             self.indicatorImageView_1.image = UIImage(named: "展开.png")
            self.lineView.isHidden = false
        }
        
        
        self.titleLabel_1.text = model.title
    }
}
