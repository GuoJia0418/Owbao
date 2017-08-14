//
//  InvestActivityAppointmentTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/27.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityAppointmentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //***************第1个cell***************//
    @IBOutlet weak var titleDetailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    //设置cell 根据模型
    func configureCellWithPrizeModel_firstCell(_ prizeModel: ProductDetailsMapPrizeModel) -> () {
        self.titleLabel.text = prizeModel.name //全称
        self.titleDetailLabel.text = prizeModel.simpleName //简称
        self.displayImageView.sd_setImage(with: URL(string: prizeModel.h5ImgUrlH), placeholderImage: Common.image(with: UIColorFromRGB(235, green: 235, blue: 235)), options: SDWebImageOptions.refreshCached)
    }
    
    class func getCellHeight_firstCell() -> CGFloat {
        return 43 * SCREEN_WIDTH / 58 + 84
    }
    
    //***************第2个cell***************//
    @IBOutlet weak var amountLabel: UILabel! //投资金额
    @IBOutlet weak var profitLabel: UILabel! //收益label
    
    func configureCellWithPrizeModel_secondCell(_ prizeModel: ProductDetailsMapPrizeModel,profitNumber: Double) -> () {
        let profitString = PD_NumDisplayStandard.numDisplayStandard("\(profitNumber)", decimalPointType: 1, numVerification: false)
        self.amountLabel.text = "\(prizeModel.amount)" //投资金额
        self.profitLabel.text = "\(profitString!)" //收益
    }
    
    class func getCellHeight_secondCell() -> CGFloat {
        return 135
    }
}
