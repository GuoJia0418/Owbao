//
//  NSString+URLEncoding.h
//  17dong_ios
//
//  Created by willson on 12/12/13.
//  Copyright (c) 2013 Wills. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlDecodeUsingDecoding;

-(NSString *)URLEncodedString:(NSString *)str;

@end
