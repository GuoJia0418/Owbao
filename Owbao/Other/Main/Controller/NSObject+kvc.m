//
//  NSObject+kvc.m
//  Owbao
//
//  Created by 一言难尽 on 2017/3/29.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

#import "NSObject+kvc.h"
#import <objc/runtime.h>
#import "Owbao-Swift.h"

//MARK: 如果是app2.0 几个几个class名字可能会更换，这里几个宏同样需要更换
#define Class_1  @"Owbao.CreatePayOrderModel"      //充值1
#define Class_2  @"Owbao.GoPayModel"               //充值2
#define Class_3  @"Owbao.WithdrawalsGoModel"       //提现
#define Class_4  @"Owbao.Register"                 //注册
#define Class_5  @"Owbao.InvestModel"              //投资
#define Class_6  @"Owbao.ExperienceInvestingModel" //体验标

@implementation NSObject (kvc)

//利用runtime交换方法，达到修改系统方法目的
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = object_getClass(self);
        
        SEL originalSelector = @selector(setValue:forKey:);
        SEL swizzledSelector = @selector(objc_setValue:forKey:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
//      注册swizzledMethod方法
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
}

#pragma mark - Method Swizzling

- (void)objc_setValue:(id)value forKey:(NSString *)key {
    [self objc_setValue:value forKey:key];
    
    NSString *classString = NSStringFromClass(self.class);
    
    if ([classString isEqualToString:Class_1] || [classString isEqualToString:Class_2] || [classString isEqualToString:Class_3] || [classString isEqualToString:Class_4] || [classString isEqualToString:Class_5] || [classString isEqualToString:Class_6]) {
        
        if ([key isEqualToString:@"errorCode"] && [value isEqualToString:@"XTWH"]) { //系统在维护
            [SystemUpdateViewController presentSystemUpdateController: @""]; //开始弹出维护页
        }
    }
}

@end
