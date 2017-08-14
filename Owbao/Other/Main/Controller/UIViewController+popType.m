//
//  UIViewController+popType.m
//  Owbao
//
//  Created by 一言难尽 on 2017/3/30.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

#import "UIViewController+popType.h"
#import <objc/runtime.h>
#import "Owbao-Swift.h"

static char *popTypeKey = "JSNavigationPop";
static char *popBeforeCallbackKey = "JSPopBeforeCallbackKey";
static char *navigationBarTypeKey = "JSnavigationBarTypeKey";

@implementation UIViewController (popType)

- (void)setBarType:(JSNavigationBarType)barType {
    objc_setAssociatedObject(self, navigationBarTypeKey, [NSNumber numberWithInteger:(NSInteger)barType], OBJC_ASSOCIATION_RETAIN);
}

- (JSNavigationBarType)barType {
    
    NSNumber *type = objc_getAssociatedObject(self, navigationBarTypeKey);
    
    if ([type isEqualToNumber:@0]) { //红色
        
        return JSNavigationBarWhite;
        
    } else if ([type isEqualToNumber:@1]) { //白色
        
        return JSNavigationBarRed;
    }
    
    return JSNavigationBarWhite;
    
    
    
}

//**************** popType *****************//
- (void)setPopType:(JSNavigationPop)popType {
    objc_setAssociatedObject(self,popTypeKey, [NSNumber numberWithInteger:(NSInteger)popType], OBJC_ASSOCIATION_RETAIN);
}

- (JSNavigationPop)popType {
    
    NSNumber *type = objc_getAssociatedObject(self, popTypeKey);
    
    if ([type isEqualToNumber:@0]) { //pop
        
        return JSNavigationPopNomarl;
        
    } else if ([type isEqualToNumber:@1]) { //popToRoot
        
        return JSNavigationPopPopToRoot;
        
    } else if ([type isEqualToNumber:@2]) { //reloadApp
        
        return JSNavigationPopReloadApp;
    } else if ([type isEqualToNumber:@3]) { //回到列表
        
        return JSNavigationPopInvestList;
    } else if ([type isEqualToNumber:@4]) { //回到列表
        
        return JSNavigationPopDismissGoHome;
        
    } else if ([type isEqualToNumber:@5]) {
        
        return JSNavigationPopDismissInvestList;
        
    } else if ([type isEqualToNumber:@6]) {
        return JSNavigationPopDismiss;
    }
    
    return JSNavigationPopNomarl; //默认是第一个
}

- (void)setPopBeforeCallback:(void (^)(JSNavigationPop))popBeforeCallback {
    objc_setAssociatedObject(self, popBeforeCallbackKey, popBeforeCallback, OBJC_ASSOCIATION_COPY);
}

- (void (^)(JSNavigationPop))popBeforeCallback {
    return objc_getAssociatedObject(self, popBeforeCallbackKey);
}


@end
