//
//  JSProvinceManager.h
//  Owbao
//
//  Created by 一言难尽 on 2017/3/10.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSProvinceManager : NSObject

+ (JSProvinceManager *)shareManager;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@interface JSProvinceModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *provinceCode;
@property (nonatomic,strong) NSMutableArray *cityArray;

@end

@interface JSCityModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,strong) NSMutableArray *districtArray;

@end

@interface JSDistrictModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *cityCode;

@end
