//
//  NSString+URLEncoding.m
//  17dong_ios
//
//  Created by willson on 12/12/13.
//  Copyright (c) 2013 Wills. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding : (NSStringEncoding) encoding {
    
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)urlDecodeUsingDecoding {
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,  (CFStringRef)self, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSString *)escapedURLString {
    
    NSString *ret = self;
    char *src     = (char *)[self UTF8String];
    if (NULL != src)
    {
        NSMutableString *tmp = [NSMutableString string];
        int ind              = 0;
        while (ind < strlen(src)) {
            if (src[ind] < 0
                || ':' == src[ind]
                || '/' == src[ind]
                || '%' == src[ind]
                || '#' == src[ind]
                || ';' == src[ind]
                || '&' == src[ind])
            {
                NSLog(@"escapedURLString: src[%d] = %d",ind,src[ind]);
                [tmp appendFormat:@"%%%x",(unsigned char)src[ind++]];
                
            }else
            {
                [tmp appendFormat:@"%c",src[ind++]];
            }
        }
        ret = tmp;
#if UE_DEBUG
        NSLog(@"Escaped string = %@",tmp);
#endif
    }
    return ret;
}

-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

@end
