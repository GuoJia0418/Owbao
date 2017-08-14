//
//  PD_NumDisplayStandard.h
//  YZApp
//
//  Created by user on 16/3/26.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PD_NumDisplayStandard : NSObject
/**
 *  数字标准化千分位显示
 *
 *  @param str            需要标准化的数字字符串
 *  @param typeNum        小数点是否需要显示  测试数字：8623.300000
                            0为不显示小数点 输出结果为: 8,623
                            1为显示小数点后2位，如果小数点后为0就不显示 输出结果为8,623.3
                            2为必需显示小数点后2位，如果不足2位则补0 输出结果为8,623.30
 *  @param isVerification isVerification为YES的时候，数字小于1的时候就显示为1，当数字大于99的时候就显示为99
 *
 *  @return 返回标准化以后的字符串
 */
+ (NSString *)numDisplayStandard:(NSString *)str
                decimalPointType:(NSInteger )typeNum
                 numVerification:(BOOL)isVerification;

/**
 *  数字标准化千分位显示
 *
 *  @param str            需要标准化的数字字符串
 *  @param typeNum        小数点是否需要显示  测试数字：8623.300000
                            0为不显示小数点 输出结果为: 8623
                            1为显示小数点后2位，如果小数点后为0就不显示 输出结果为8623.3
                            2为必需显示小数点后2位，如果不足2位则补0 输出结果为8623.30
 *  @param isVerification isVerification为YES的时候，数字小于1的时候就显示为1，当数字大于99的时候就显示为99
 *
 *  @return 返回标准化以后的字符串
 */
+ (NSString *)standardString:(NSString *)str
            decimalPointType:(NSInteger )typeNum
             numVerification:(BOOL)isVerification;

+ (int)compareVersions:(NSString *)version second:(NSString *)otherVersion;

+ (NSString *)notRounding:(double)price afterPoint:(int)position;
+ (NSString *)setStandardString:(NSString *)str
               decimalPointType:(NSInteger )typeNum
                numVerification:(BOOL)isVerification;
    
+ (NSString *)setNumStandard:(double)num;
+ (NSString *)configNumStandard:(double)num1;
@end
