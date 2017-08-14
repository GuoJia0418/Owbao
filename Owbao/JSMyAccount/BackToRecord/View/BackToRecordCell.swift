//
//  BackToRecordCell.swift
//  Owbao
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BackToRecordCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var model : BackRecordModel? {
    
        didSet{
        
            amountLabel.text! = "\(model!.shouldSum)"
            
            //index期收益
            model!.residualPrincipal == 0 ? (situationLabel.text = "\(model!.index)期收益" + "+" + "本金") : (situationLabel.text = "\(model!.index)期收益")
            dateLabel.text = model!.date
            
            model!.status == 0 ? (statusLabel.text = "未到账") : (statusLabel.text = "已到账")
            if model?.status != 0 { statusLabel.textColor = Global_red }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //大写中文
    func NumToChineseString(_ key: Int) -> String
        
    {
        let keyStr = "\(key)"
        let dict = ["1":"一","2":"二","3":"三","4":"四","5":"五","6":"六","7":"七","8":"八","9":"九","10":"十","11":"十一"]

        return dict[keyStr]!
    }
    
    
}
