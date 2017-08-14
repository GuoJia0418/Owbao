//
//  GJTextView.h
//
//
//  Created by guojia on 15/4/17.
//  Copyright (c) 2015年 guojia. All rights reserved.
//  封装的控件:文本输入view,带有占位文字,只需要传占位符和占位文字的颜色

#import <UIKit/UIKit.h>

@interface GJTextView : UITextView

@property(nonatomic,copy)   NSString *placeholder;
@property(nonatomic,strong) UIColor *placeholderColor;

@end
