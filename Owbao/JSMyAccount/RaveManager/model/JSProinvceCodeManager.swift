//
//  JSProinvceCodeManager.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProinvceCodeManager: NSObject {

    static let sharedInstance = JSProinvceCodeManager()
    
    private override init() {
        super.init()
        self.jsonStringCovertToModel()
        self.getBankCode()
    }
    
    var provinceArray = [JSProvinceModel]()
    var bankModelArray = [JSProvinceModel]()
    
    //解析数组
    func jsonStringCovertToModel() {
        
        let baseString = Bundle.main.path(forResource: "ProvinceAndCity", ofType: "json")
        let data = NSData(contentsOfFile: baseString!)
        let array = try!JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as! NSArray
        
        for item in array  {
            
            if let dict = item as? NSDictionary {
                
                let model = JSProvinceModel.init()
                model.name = dict["ProvinceName" as Any] as! String
                model.provinceCode = dict["ProvinceCode" as Any] as! String
                
                if let sub_dict = dict["Cities" as Any] as? NSArray {
                    
                    for subArray in sub_dict {
                        
                        if let sub_Array = subArray as? NSArray {
                            let subModel = JSCityModel.init()
                            subModel.cityCode = sub_Array[1] as! String
                            subModel.name = sub_Array[0] as! String
                            model.cityArray.add(subModel)                     }
                    }
                }
                
                self.provinceArray.append(model)
            }
        }
        
        print("")
    }
    
    func getBankCode() {
        
        let model = JSProvinceModel()
        model.name = "中国工商银行"
        model.provinceCode = "0102"
        
        let model_1 = JSProvinceModel()
        model_1.name = "中国农业银行"
        model_1.provinceCode = "0103"
        
        let model_2 = JSProvinceModel()
        model_2.name = "中国银行"
        model_2.provinceCode = "0104"
        
        let model_3 = JSProvinceModel()
        model_3.name = "中国建设银行"
        model_3.provinceCode = "0105"

        let model_4 = JSProvinceModel()
        model_4.name = "交通银行"
        model_4.provinceCode = "0301"
        
        let model_5 = JSProvinceModel()
        model_5.name = "中信银行"
        model_5.provinceCode = "0302"
        
        let model_6 = JSProvinceModel()
        model_6.name = "中国光大银行"
        model_6.provinceCode = "0303"
        
        let model_7 = JSProvinceModel()
        model_7.name = "华夏银行"
        model_7.provinceCode = "0304"
        
        let model_8 = JSProvinceModel()
        model_8.name = "中国民生银行"
        model_8.provinceCode = "0305"
        
        let model_9 = JSProvinceModel()
        model_9.name = "广东发展银行"
        model_9.provinceCode = "0306"
        
        let model_10 = JSProvinceModel()
        model_10.name = "平安银行股份有限公司"
        model_10.provinceCode = "0307"
        
        let model_11 = JSProvinceModel()
        model_11.name = "招商银行"
        model_11.provinceCode = "0308"
        
        let model_12 = JSProvinceModel()
        model_12.name = "兴业银行"
        model_12.provinceCode = "0309"
        
        let model_13 = JSProvinceModel()
        model_13.name = "上海浦东发展银行"
        model_13.provinceCode = "0310"
        
        let model_14 = JSProvinceModel()
        model_14.name = "中国邮政储蓄银行股份有限公司"
        model_14.provinceCode = "0403"

        self.bankModelArray.append(model)
        self.bankModelArray.append(model_1)
        self.bankModelArray.append(model_2)
        self.bankModelArray.append(model_3)
        self.bankModelArray.append(model_4)
        self.bankModelArray.append(model_5)
        self.bankModelArray.append(model_6)
        self.bankModelArray.append(model_7)
        self.bankModelArray.append(model_8)
        self.bankModelArray.append(model_9)
        self.bankModelArray.append(model_10)
        self.bankModelArray.append(model_11)
        self.bankModelArray.append(model_12)
        self.bankModelArray.append(model_13)
        self.bankModelArray.append(model_14)
    }
}
