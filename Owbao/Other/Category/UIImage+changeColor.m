//
//  UIImage+changeColor.h
//
//
//  Created by GuoJia on 15-11-19.
//  Copyright (c) 2014年 GuoJia. All rights reserved.
//

#import "UIImage+changeColor.h"

@implementation UIImage (changeColor)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
