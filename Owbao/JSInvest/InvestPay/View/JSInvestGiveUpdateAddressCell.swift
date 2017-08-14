//
//  JSInvestGiveUpdateAddressCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/8.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  用户上传更新收货地址、收货人

import UIKit

enum ClickActionType: Int {
    case receiverName = 0 //收货人
    case phoneNumber = 1 //手机号码
    case address = 2     //收货人地址
}

class JSInvestGiveUpdateAddressCell: UITableViewCell {

    @IBOutlet weak var receiverNameLabel: UILabel! //收货人名字label
    @IBOutlet weak var phoneNumLabel: UILabel! //手机号码label
    @IBOutlet weak var addressLabel: UILabel! //收货人地址
    
    var clickCallback: ((_ type: ClickActionType) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellHeight() -> CGFloat {
        return 222.0
    }
    
    @IBAction func buttonClickAction(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        
        if button.tag == 0 { //收货人
            
            if self.clickCallback != nil{
                self.clickCallback!(ClickActionType.receiverName)
            }
            
        } else if button.tag == 1 { //联系电话
            
            if self.clickCallback != nil{
                self.clickCallback!(ClickActionType.phoneNumber)
            }
            
        } else if button.tag == 2 { //收货地址
            
            if self.clickCallback != nil{
                self.clickCallback!(ClickActionType.address)
            }
        }
    }
    
    //配置cell
    func configureCell(addressDetailModel: GetAddressDetailModel?) -> () {
        
        if addressDetailModel != nil {
            self.receiverNameLabel.text = addressDetailModel?.name
            self.phoneNumLabel.text = addressDetailModel?.phone
            
            //该字段不为空表示是第一次进来,如果用户自己选择过地址，该字段会置为空（没办法，服务器只有一个字段表示地址）
            if addressDetailModel?.address != "" {
               self.addressLabel.text = "\((addressDetailModel?.address)!)"
            } else {
               self.addressLabel.text = "\((addressDetailModel?.chooseLocationAddress)!)\((addressDetailModel?.detailAddress)!)"
            }
        }
    }
}
