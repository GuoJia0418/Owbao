//
//  GJTextView.m
//
//
//  Created by guojia on 15/4/17.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "GJTextView.h"

@interface GJTextView ()

@end

@implementation GJTextView

- (id)init {
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 监听文字的改变 */
- (void)textChange {
    //重新描绘
    [self setNeedsDisplay];
}

/** 吧控件描绘在view上面,每次调用都会吧上次清除 */
- (void)drawRect:(CGRect)rect {
    
    if (self.hasText){
        
        return;
    }
    //文字改变
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    
    attri[NSFontAttributeName] = self.font;
    
    attri[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor colorWithRed:160.0 / 255.0 green:160.0 / 255.0  blue:160.0 /255.0 alpha:1.0];
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat h = rect.size.height - 2 * y; //让占位的多行显示
    CGRect placeholderRect = CGRectMake(x, 8,w , h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attri];
}

/** 重写setter保证外面随时改变文字里面都能实时改变 */
- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

/** 重写setter保证外面随时改变文字颜色里面都能实时改变 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

/** 为了防止外面用户用系统的方法来改变文字,里面却监视不到,重写setter方法去监视 */
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self setNeedsDisplay];//该方法会吧所有需要描绘的东西放在消息队里里面并且会在下个消息循环时候,调用drawRect:且连续调用5次drawRect:它只会画一次。
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

@end
