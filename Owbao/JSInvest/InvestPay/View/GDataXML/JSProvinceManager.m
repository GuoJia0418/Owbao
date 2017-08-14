//
//  JSProvinceManager.m
//  Owbao
//
//  Created by 一言难尽 on 2017/3/10.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

#import "JSProvinceManager.h"
#import "GDataXMLNode.h"

@implementation JSProvinceManager

static JSProvinceManager *manager;

+ (JSProvinceManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSProvinceManager alloc] init];
        manager.dataArray = [manager getXMLArray];
    });
    return manager;
}

- (NSMutableArray *)getXMLArray {
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
    NSString *xmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [xmlEle children];
    NSLog(@"count : %lu", (unsigned long)[array count]);

    NSMutableArray *princeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        
        if ([[ele name] isEqualToString:@"province"]) { //省级
            
            JSProvinceModel *provinceModel = [[JSProvinceModel alloc] init];
            provinceModel.name = [[ele attributeForName:@"name"] stringValue];
            provinceModel.cityArray = [NSMutableArray array];
            
            //城市
            NSArray *cityArray = [ele children];
            for (int j = 0; j < cityArray.count ; j++) {
                
                GDataXMLElement *cityEle = [cityArray objectAtIndex:j];
                
                if ([[cityEle name] isEqualToString:@"city"]) {
                
                    JSCityModel *cityModel =  [[JSCityModel alloc] init];
                    cityModel.name = [[cityEle attributeForName:@"name"] stringValue];
                    cityModel.districtArray = [NSMutableArray array];
                    
                    //区、县
                    NSArray *districtArray = [cityEle children];
                    for (int z = 0; z < districtArray.count; z++) {
                        
                        GDataXMLElement *disEle = [districtArray objectAtIndex:z];
                        
                        JSDistrictModel *districtModel = [[JSDistrictModel alloc] init];
                        districtModel.name = [[disEle attributeForName:@"name"] stringValue];
                        [cityModel.districtArray addObject:districtModel]; //区、县加入数组
                    }
                    [provinceModel.cityArray addObject:cityModel]; //城市加入数组
                }
            }
            
            [princeArray addObject:provinceModel]; //省加入数组
            
        }
    }
    return princeArray;
}


@end

@implementation JSProvinceModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation JSCityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _districtArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation JSDistrictModel

@end



