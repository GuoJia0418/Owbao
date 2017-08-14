//
//  ProductDetailAlertCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ProductDetailAlertCell: UITableViewCell {

    ///返回cell的高度
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        let firstHeight =  ProductDetailFirstCell.cellHeight() //头部红色
        let firstHeight_account = JSProductAcountCell.cellHeight(detailModel) //项目总额 + 剩余可投
        let secondHeight = ProductDetailSecondCell.cellHeight(detailModel) //输入框
        let thirdHeight =  ProductDetailThirdCell.cellHeight(detailModel) //红包
        
        //iPhone标有2个row
        let forthHeight =  JSIPhone7TableViewCell.cellHeight(detailModel)
        let fithHeight = JSIPhone7TableViewCell.cellHeight(detailModel)
        
        //投即送有2个row
        let sixthHeight = JSInvestGiveTableViewCell.cellHeight(detailModel)
        let seventhHeight = JSInvestGiveTableViewCell.cellHeight(detailModel)
        
        //新手标1个row
        let eightHeight = JSInvestNoviceIntroduceCell.cellHeight(detailModel)
        
        if detailModel != nil && detailModel?.map?.info?.status == 5 {
            
            //1.新手标且为新用户且投资了新手标且登录状态 
            //2.新手标且非新用户且登录状态 
            //3.普通标且活动开启 
            //上面123条都是105(105是底部button的背景视图高度约束)
            if (detailModel?.map?.controllerType == .novice && detailModel?.map?.isNewUser == 1 && detailModel?.map?.fuiouNewHandInvested == 1 && UserModel.shareInstance.isLogin == 1) ||
                (detailModel?.map?.controllerType == .novice && detailModel?.map?.isNewUser == 0 && UserModel.shareInstance.isLogin == 1) ||
                (detailModel?.map?.controllerType == .normal && detailModel?.map?.isShowLabel == true) {
                
                let height = 64.0 + 105 + firstHeight + secondHeight + thirdHeight + forthHeight + fithHeight + sixthHeight + seventhHeight + firstHeight_account + eightHeight
                
                var cellHeight = SCREEN_HEIGHT - height
                
                if cellHeight <= 36 {//保证cell >= 0
                    cellHeight = 45
                }
                
                //cell自适应tableView高度
                return cellHeight
            }
        }
        
        //80 是底部button的背景视图高度约束
        let height = 64.0 + 90 + firstHeight + secondHeight + thirdHeight + forthHeight + fithHeight + sixthHeight + seventhHeight + firstHeight_account + eightHeight
        
        var cellHeight = SCREEN_HEIGHT - height
        
        if cellHeight <= 36 {//保证cell >= 0
            cellHeight = 45
        }
        
        //cell自适应tableView高度
        return cellHeight
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
