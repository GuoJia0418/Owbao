//
//  UIViewController+popType.h
//  Owbao
//
//  Created by 一言难尽 on 2017/3/30.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  利用runtim给UIViewController添加属性（写在UIViewController能强加扩展性)

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSNavigationPop) {
    JSNavigationPopNomarl = 0,     //默认从0开始,回到上个控制器
    JSNavigationPopPopToRoot = 1,  //回到根控制器
    JSNavigationPopReloadApp = 2,  //刷新app
    JSNavigationPopInvestList = 3, //回到投资列表
    JSNavigationPopDismissGoHome = 4, //回到主界面(有dismiss操作)
    JSNavigationPopDismissInvestList = 5, //回到列表界面(有dismiss操作)
    JSNavigationPopDismiss = 6,           //登录界面dismiss掉
};

typedef NS_ENUM(NSInteger, JSNavigationBarType) {
    JSNavigationBarWhite = 0,    //白色
    JSNavigationBarRed = 1, //红色
};

@interface UIViewController (popType)

@property (nonatomic,assign) JSNavigationBarType barType; //控制器导航栏颜色，默认是JSNavigationBarWhite

@property (nonatomic,assign) JSNavigationPop popType; //pop类型,默认是JSNavigationPopNomarl
@property (nonatomic,copy) void (^popBeforeCallback)(JSNavigationPop popType); //pop之前的时候回调,以便进行额外的操作

@end
