//
//  ProductDetailsMapModel.swift
//  Owbao
//
//  Created by lufeng on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailsMapModel: NSObject {
    
    var balance: Double = 0.00       //账户余额
    var investNums: Int = 0 //已投资人数
    var info: ProductDetailsInfoModel?
    var couponList = [ProductDetailsCouponListModel]() //红包模型
    var extendInfos = [ExtendInfosModel]()
    var investTotal: Int = 0
    var preProInvestNums: Int = 0
    
    var newHandInvested: Bool = false //是否投资过新手标
    var isInvested: Bool = false //是否投资过Type=2的产品,是否投资过其他

    var appTitle: String?   //移动端短标题
    var linkURL: String?    //活动详情页（活动ID不为空时，取此值）

    //添加预约功能,2016年11月22日
    var isReservation: Bool = false //是否预约
    var realVerify: Bool = false  //是否实名
    var tpwdFlag: Bool = false    //是否设置过交易密码
    var prid: Int = 0 //预约规则id
    var name: String? //预约规则名称
    
    //双旦活动
    var specialRate: Double = 0.00       //增加利率
    var isOldUser: Bool = false          //是否是新老用户
    var doubleEggrule: String? = ""      //双旦活动文案
    
    //奖品详情
    var prize: ProductDetailsMapPrizeModel?
    
    //******* 新增的app2.0产品介绍字段  ***************//
    var iphoneDetailUrl: String = ""   //Iphone7奖品详情url
    var nowTime: Double = 0.00         //服务器当前时间
    var isShowLabel: Bool = false      //新增是否显示100000体验金的
    var isFuiou: Int = 0               //是否开通存管
    var balanceFuiou: Double = 0.0     //存管账户余额
    var fuiouNewHandInvested: Int = 1  //1已投，0未投
    var isNewUser: Int = 0  //1是，0不是
    
    //******************* 保存用户输入金额、选中红包、控制器的类型 ***************//
    var inputAmount: Double = 0.0
    var selectCouponModel: MyCouponsListModel?
    var controllerType: InvestDetailControllerType = .normal //默认是普通标
    var investId: Int = 0            //投资id，投资成功后获取到
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "info" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                info = ProductDetailsInfoModel(dict: dict)
            }
            return
        }
        
        if key == "couponList" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = ProductDetailsCouponListModel(dict: dict)
                    couponList.append(invest)
                }
            }
            return
        }
        
        if key == "extendInfos" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [[String: AnyObject]] {
                // 然后开始遍历
                for dict in arr {
                    let invest = ExtendInfosModel(dict: dict)
                    extendInfos.append(invest)
                }
            }
            return
        }
        
        if key == "prize" {
            // 判断 value 是否是一个有效的数组
            if let arr = value as? [String: AnyObject] {
                self.prize =  ProductDetailsMapPrizeModel(dict: arr)
            }
            return
        }

        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    class func modelContainerPropertyGenericClass() -> NSDictionary {
        return NSDictionary(dictionary: ["info": ProductDetailsInfoModel.classForCoder(),
                                         "prize": ProductDetailsMapPrizeModel.classForCoder(),
                                         "couponList": ProductDetailsCouponListModel.classForCoder(),
                                         "extendInfos": ExtendInfosModel.classForCoder()])
    }
}


class ProductDetailsMapPrizeModel: NSObject {
    
    var amount: Double = 0.0 //投资金额
    var name: String = "" //全称
    var simpleName: String = "" //简称
    var price: Double = 0.00 //标价
    var isNot: Bool = false //默认未抢完，true:抢完  false：未抢完
    var h5ImgUrlH: String = "" //h5奖品图片横版
    var h5DetailImgUrl: String = "" //pc奖品详情图片
    var id: Int = 0 //奖品id
    var rate: Double = 0.0          //利率
    var activityRate: Double = 0.0  //活动利率
    var deadline: Int = 0           //标时间
    var prizeType: Int = 2          //1：50元话费，2：其他奖品
    
    var investSendUrl: String = ""   //投即送链接
    var investSendDetailUrl: String = ""  //投即送奖品详情url
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
