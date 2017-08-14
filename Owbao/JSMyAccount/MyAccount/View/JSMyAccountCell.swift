//
//  JSMyAccountCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

enum accountCellCallbackType: Int {
    case sumIncome = 0   //查看总收益
    case available = 1   //可用余额
}

class JSMyAccountCell: UITableViewCell {

    @IBOutlet weak var eyeBtn: UIButton!    //眼睛按钮
    @IBOutlet weak var sumIncomeLabel: UILabel!     //累计收益
    @IBOutlet weak var totalAssetsLabel: UILabel!       //总资产
    
    @IBOutlet weak var availBanlanceLabel: UILabel!     //可用余额label
    @IBOutlet weak var remainLabel: UILabel!      //可用余额

    var callbackAction: ((_ type: accountCellCallbackType) -> ())?  //点击几个button回调
    var eyeClick:((_ selected:Bool)->())?          //点击眼睛
    
    var totalAssetsAmount: String?   //总资产
    var sumIncomeAmount: String?     //累计收益
    var remainAmount: String?        //可用余额
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func cellHeight()->CGFloat
    {
        return 187
    }
    
    //模型设置数据
    func configureCellWithAccountModel(_ accountMapModel: MyAccountMapModel,isSelected:Bool) -> () {
        
        //可用余额显示
        if accountMapModel.balance != 0.00
        {
            availBanlanceLabel.text = "账户余额(平台+存管)"
        }
        else
        {
            availBanlanceLabel.text = "存管账户余额(元)"
        }
        
        let account = accountMapModel.balance +
            accountMapModel.free +
            accountMapModel.wprincipal +
            accountMapModel.balanceFuiou +
            accountMapModel.freeFuiou +
            accountMapModel.wprincipalFuiou
        
        self.totalAssetsLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(account)", decimalPointType: 1, numVerification: false)
        self.remainLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(accountMapModel.balance+accountMapModel.balanceFuiou)", decimalPointType: 1, numVerification: false)
        self.sumIncomeLabel.text = PD_NumDisplayStandard.numDisplayStandard("\(accountMapModel.accumulatedIncome)", decimalPointType: 1, numVerification: false)
        
        totalAssetsAmount = totalAssetsLabel.text
        sumIncomeAmount = sumIncomeLabel.text
        remainAmount = remainLabel.text
        
        self.showOrHidden(isSelected)
    }
    
    //MARK: - 查看总收益
    @IBAction func sumIncomeAction(_ sender: UIButton) {
        if self.callbackAction != nil {
            self.callbackAction!(accountCellCallbackType.sumIncome)
        }
    }
    
    //MARK: - 关闭眼睛
    @IBAction func eyeClick(_ sender: UIButton) {
        
        if eyeClick != nil {
            self.eyeClick!(eyeBtn.isSelected)
        }
    }
    
    //MARK: - 显示与隐藏数据
    func showOrHidden(_ flag:Bool)
    {
        if flag == true
        {
            eyeBtn.setImage(UIImage(named: "js_mine_open_eye"), for: UIControlState())
            totalAssetsLabel.text = totalAssetsAmount
            sumIncomeLabel.text = sumIncomeAmount
            remainLabel.text = remainAmount
        }
        else
        {
            eyeBtn.setImage(UIImage(named: "js_mine_close_eye"), for: .selected)
            totalAssetsAmount = totalAssetsLabel.text
            totalAssetsLabel.text = "******"
            sumIncomeAmount = sumIncomeLabel.text
            sumIncomeLabel.text = "******"
            remainAmount = remainLabel.text
            remainLabel.text = "******"
        }
        
        eyeBtn.isSelected = !flag
    }
    
    //MARK: 可用余额 
    @IBAction func availableClick(_ sender: UIButton) {
        if self.callbackAction != nil {
            self.callbackAction!(accountCellCallbackType.available)
        }
    }
    
    //MARK: 总资产
    @IBAction func totalAssetsClick(_ sender: UIButton) {
        if self.callbackAction != nil {
            self.callbackAction!(accountCellCallbackType.available)
        }
    }

}
