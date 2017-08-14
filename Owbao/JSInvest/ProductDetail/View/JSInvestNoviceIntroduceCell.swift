//
//  JSInvestNoviceIntroduceCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/5.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvestNoviceIntroduceCell: UITableViewCell {

    @IBOutlet weak var topLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(detailModel: ProductDetailsModel?) {
        if detailModel != nil {
            
            if detailModel?.map?.controllerType == .novice && detailModel?.map?.info?.status != 5 {
                self.topLineView.isHidden = false
            }
        }
    }
    
    //只有新手标才会有高度，别的类型无高度
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        if detailModel != nil {
            
            if detailModel?.map?.controllerType == .novice {
                return 50.0
            }
        }
        return 0
    }
    
    //新手标存在，需要显示cell，否则不显示
    class func numberRowForNoviceSection(_ detailModel: ProductDetailsModel?) -> Int {
        
        if detailModel != nil {
            if detailModel?.map?.controllerType == .novice {
                return 1
            }
        }
        
        return 0
    }
    
}
