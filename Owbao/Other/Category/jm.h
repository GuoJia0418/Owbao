//
//  jm.h
//  Owbao
//
//  Created by lufeng on 16/3/21.
//  Copyright © 2016年 lufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonDigest.h>
@interface jm : NSObject

- (NSString *)sbjm:(NSString *)str;
//MD5加密_32位
- (NSString *)getMd5_32Bit:(NSString *)str;
@end
