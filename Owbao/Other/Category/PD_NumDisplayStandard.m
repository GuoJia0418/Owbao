//
//  PD_NumDisplayStandard.m
//  Panda
//
//  Created by user on 16/3/26.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "PD_NumDisplayStandard.h"

@implementation PD_NumDisplayStandard
+ (NSString *)numDisplayStandard:(NSString *)str
                decimalPointType:(NSInteger )typeNum
                 numVerification:(BOOL)isVerification{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:1];
    
    if (typeNum == 0) {
        [numberFormatter setMaximumFractionDigits:0];
    } else if (typeNum == 1) {
        [numberFormatter setMinimumFractionDigits:0];
        [numberFormatter setMaximumFractionDigits:2];
    } else {
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
     
        
    }
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    numberFormatter.roundingMode = NSRoundDown;
    NSNumber *num = [numberFormatter numberFromString:str];
    
    if (isVerification && num) {
        if ([num intValue] < 1 && [num floatValue] > 0.00) {
            num = [NSNumber numberWithInt:1];
        }
        if ([num intValue] == 99) {
            num = [NSNumber numberWithInt:99];
        }
    }
    NSString *numStr = [numberFormatter stringFromNumber:num];
    NSRange pointRange = [numStr rangeOfString:@"."];
    if (pointRange.location + 2 < numStr.length - 1) {
        
        return [numStr substringToIndex:pointRange.location + 2 + 1];
    } else {
        return numStr;
    }
    return numStr;
}

+ (NSString *)standardString:(NSString *)str
            decimalPointType:(NSInteger )typeNum
             numVerification:(BOOL)isVerification {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:1];
    numberFormatter.roundingMode = NSRoundDown;
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    
    if (typeNum == 0) {
        [numberFormatter setMaximumFractionDigits:0];
    } else if (typeNum == 1) {
        [numberFormatter setMinimumFractionDigits:0];
        [numberFormatter setMaximumFractionDigits:2];
    } else {
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
    }

    NSNumber *num = [numberFormatter numberFromString:str];
    
    if (isVerification && num) {
        if ([num intValue] < 1 && [num floatValue] > 0.00) {
            num = [NSNumber numberWithInt:1];
        }
        if ([num intValue] == 99) {
            num = [NSNumber numberWithInt:99];
        }
    }
    
    NSString *numStr = [numberFormatter stringFromNumber:num];
    numStr =  [numStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSRange pointRange = [numStr rangeOfString:@"."];
    if (pointRange.location + 2 < numStr.length - 1) {

        return [numStr substringToIndex:pointRange.location + 2 + 1];
    } else {
        return numStr;
    }
    return numStr;
}

+ (int)compareVersions:(NSString *)version second:(NSString *)otherVersion{
    return [version compare:otherVersion options:NSNumericSearch];
}
+(NSString *)removeWrap:(NSString *)str{
    
    return str;
}

//判断是否为汉字
- (BOOL)isChinesecharacter:(NSString *)string{
    if (string.length == 0) {
        return NO;
    }
    unichar c = [string characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FA5)     {
        return YES;//汉字
    } else {
        return NO;//英文
    }
}
//计算汉字的个数
- (NSInteger)chineseCountOfString:(NSString *)string{
    int ChineseCount = 0;
    if (string.length == 0) {
        return 0;
    }
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5){
            ChineseCount++ ;//汉字
        }
    }
    return ChineseCount;
}
//计算字母的个数
- (NSInteger)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0) {
        return 0;
    }
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5)        {
        } else {
            characterCount++;//英文
        }
    }
    return characterCount;
}

+ (NSString *)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)setStandardString:(NSString *)str
            decimalPointType:(NSInteger )typeNum
             numVerification:(BOOL)isVerification {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:1];
    numberFormatter.roundingMode = NSRoundBankers;
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    
    if (typeNum == 0) {
        [numberFormatter setMaximumFractionDigits:0];
    } else if (typeNum == 1) {
        [numberFormatter setMinimumFractionDigits:0];
        [numberFormatter setMaximumFractionDigits:2];
    } else {
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
    }
    
    NSNumber *num = [numberFormatter numberFromString:str];
    
    if (isVerification && num) {
        if ([num intValue] < 1 && [num floatValue] > 0.00) {
            num = [NSNumber numberWithInt:1];
        }
        if ([num intValue] == 99) {
            num = [NSNumber numberWithInt:99];
        }
    }
    
    NSString *numStr = [numberFormatter stringFromNumber:num];
//    numStr =  [numStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSRange pointRange = [numStr rangeOfString:@"."];
    if (pointRange.location + 2 < numStr.length - 1) {
        
        return [numStr substringToIndex:pointRange.location + 2 + 1];
    } else {
        return numStr;
    }
    return numStr;
}
    
+ (NSString *)setNumStandard:(double)num
{
 
    NSNumber *num1 = [NSNumber numberWithDouble:num];
    
    // ==================== 类方法 ====================
    
    // 四舍五入的整数
//    NSString *numberNoStyleStr                 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterNoStyle];
//    
//    // 小数形式
//    NSString *numberDecimalStyleStr            = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterDecimalStyle];
    
    // 货币形式 -- 本地化
    NSString *numberCurrencyStyleStr           = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyStyle];
    
    // 货币形式 -- 本地化
//    NSString *numberCurrencyPluralStyleStr     = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyPluralStyle];
    
    return numberCurrencyStyleStr;
}
+ (NSString *)configNumStandard:(double)num1{
    
    NSNumber *num2 = [NSNumber numberWithDouble:num1];
    // 四舍五入的整数
    NSString *numberNoStyleStr                 = [NSNumberFormatter localizedStringFromNumber:num2 numberStyle:NSNumberFormatterNoStyle];
    return numberNoStyleStr;
}

@end
