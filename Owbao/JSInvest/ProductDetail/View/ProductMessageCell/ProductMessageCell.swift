//
//  ProductMessageCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ProductMessageCell: UITableViewCell {

    @IBOutlet weak var messageTitle: UILabel!       //理财周期
    @IBOutlet weak var startTimeLabel: UILabel!     //开始计息时间
    @IBOutlet weak var completeTimeLabel: UILabel!      //预计募集完成时间
    @IBOutlet weak var backTimeLabel: UILabel!  //预计回款时间
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //设置数据
    func configureCell(_ detailModel: ProductDetailsModel?) -> () {
        
        if detailModel != nil {
            self.startTimeLabel.text = "\(TimeStampToString((detailModel?.map?.nowTime)!, isHMS: false))"
            self.completeTimeLabel.text = "\(TimeStampToString((detailModel?.map?.info?.endDate)!, isHMS: false))"
            self.backTimeLabel.text = "\(TimeStampToString((detailModel?.map?.info?.expireDate)!, isHMS: false))"
        }
    }
    
    class func cellHeigth() -> CGFloat {
            return 157.0
    }
}
