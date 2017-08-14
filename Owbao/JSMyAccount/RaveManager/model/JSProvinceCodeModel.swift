//
//  JSProvinceModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/5/24.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSProvinceCodeModel: NSObject {

    var provinceName: String = ""
    var provinceCode: String = ""
    var provinceAlias: String = ""
    
    var cities = [JSCityCodeModel]()
}

class JSCityCodeModel: NSObject {
    
    var cityName: String = ""
    var cityCode: String = ""
}
