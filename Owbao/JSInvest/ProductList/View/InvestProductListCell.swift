//
//  InvestProductListCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/3/8.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class InvestProductListCell: UITableViewCell {

    @IBOutlet weak var productListBtn: UIButton!    //优选理财
    @IBOutlet weak var activityListBtn: UIButton!   //活动专享
    @IBOutlet weak var productListLine: UILabel!    //优选理财line
    @IBOutlet weak var activityListLine: UILabel!   //活动专享line
    
    var productListBlock:(()->())?   //优选理财
    var activityListBlock:(()->())?  //活动专享
    
    func setupBtn(_ type:Int)
    {
        if type == 1
        {
            productListBtn.setTitleColor(UIColorFromRGB(153, green: 153, blue: 153), for: UIControlState())
            activityListBtn.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())
            productListLine.backgroundColor = UIColor.white
            activityListLine.backgroundColor = DEFAULT_REDCOLOR
        }
        else
        {
            productListBtn.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())
            activityListBtn.setTitleColor(UIColorFromRGB(153, green: 153, blue: 153), for: UIControlState())
            productListLine.backgroundColor = DEFAULT_REDCOLOR
            activityListLine.backgroundColor = UIColor.white
        }
    }
    
    //优选理财
    @IBAction func productListClick(_ sender: UIButton) {
        
        productListBtn.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())
        activityListBtn.setTitleColor(UIColor.black, for: UIControlState())
        productListLine.backgroundColor = DEFAULT_REDCOLOR
        activityListLine.backgroundColor = UIColor.white
        
        if productListBlock != nil
        {
            self.productListBlock!()
        }

    }
    //活动专享
    @IBAction func activityListClick(_ sender: UIButton) {
        productListBtn.setTitleColor(UIColor.black, for: UIControlState())
        activityListBtn.setTitleColor(DEFAULT_REDCOLOR, for: UIControlState())

        productListLine.backgroundColor = UIColor.white
        activityListLine.backgroundColor = DEFAULT_REDCOLOR

        if activityListBlock != nil
        {
            self.activityListBlock!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
