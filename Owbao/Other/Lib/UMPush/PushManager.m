//
//  JPushManager.m
//  Owbao
//
//  Created by 一言难尽 on 2017/3/7.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

#import "PushManager.h"
#import "Owbao-Swift.h"     //OC代码引用Swift代码
#import "UMessage.h"
#import "EBForeNotification.h"

#define URL             @"url"
#define Title           @"title"
#define Aps             @"aps"
#define Alert           @"alert"

@interface PushManager ()

@end

@implementation PushManager

static PushManager *manager;

+ (PushManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushManager alloc] init];
    });
    
    return manager;
}

- (void)registerUMPushManager:(NSDictionary *)launchOptions
                    UMPushKey:(NSString *)UMPushKey {
    //******************************* 友盟推送 ********************//
    [UMessage startWithAppkey:UMPushKey launchOptions:launchOptions httpsEnable:YES];
    [UMessage openDebugMode:YES]; //是否开启开发模式，开发模式为YES。生产模式为NO，不调用默认为生产模式
    
    //注册通知
    [UMessage registerForRemoteNotifications];
         UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  //这里可以添加一些自己的逻辑
                 
                                  
                              } else {
                                  //点击不允许
                                  //这里可以添加一些自己的逻辑

                              }
                          }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    //监听登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUMPushAction) name:@"LOGIN_SUCCESS_NOTIFICATION_POST_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUMPushAction) name:@"Register_SUCCESS_NOTIFICATION_POST_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUMPushAction {
    PushAudienceViewModel *model = [[PushAudienceViewModel alloc] init];
    [model loadPushAudicenceData:self.deviceToken appType:0];
}

//处理远程发送的通知
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"userInfo = %@",userInfo);
    NSString *body = @"";
    NSString *urlString = @"";
    NSString *title = @"";
    
    if ([userInfo[URL] isKindOfClass:[NSString class]]) {
        urlString = userInfo[URL];
        title = userInfo[Title];
    }
    
    //1.程序运行状态
    //后期扩展加上跳转特定界面
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {

        if ([userInfo[Aps][Alert] isKindOfClass:[NSString class]]) {
            body = userInfo[Aps][Alert];
        } else if ([userInfo[Aps][Alert] isKindOfClass:[NSDictionary class]]) {
            body = userInfo[Aps][Alert][@"body"];
        }
        
        [EBForeNotification handleRemoteNotification:@{Aps:@{Alert:body,URL:urlString,Title:title}} soundID:1312 isIos10:NO];
        
    } else {
        if(![urlString isEqualToString:@""]) {
            [self presentViewController:urlString title:title];
        }
    }
}

//顶部推送视图点击发送通知回调
- (void)eBBannerViewDidClick:(NSNotification *)notification {
    NSDictionary *dictionary = notification.object;
    
    if ([dictionary[Aps][URL] isKindOfClass:[NSString class]]) {
        if(![dictionary[Aps][URL] isEqualToString: @""]) {
            
            NSString *title = @"";
            if(dictionary[Aps][Title] != nil) {
                title = dictionary[Aps][Title];
            }
            
            [self presentViewController:dictionary[Aps][URL] title:title];
        }
    }
}

//present出推送界面,若当前有presented的控制器，会取消该presented控制器然后回到首页，继续present推送控制器
- (void)presentViewController:(NSString *)urlString title:(NSString *)titleString {
    LocationController *webController = [[LocationController alloc] init];
    HomeBannerModel *model = [[HomeBannerModel alloc] initWithDict:@{@"location":urlString,Title:titleString}];
    webController.model = model;
    webController.popType = JSNavigationPopDismiss;
    RootNavigationController *naviController = [[RootNavigationController alloc] initWithRootViewController:webController];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *superController = appDelegate.rootVC;
    
    //表示目前有presented的控制器，需要取消
    if ([appDelegate.rootVC presentedViewController] != nil) {
        
        superController = [appDelegate.rootVC presentedViewController]; //取出被self弹出的控制器
        [superController dismissViewControllerAnimated:false completion:nil];
        [RootNavigationController goToHomeControllerWithController:(BaseViewController *)superController];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        RootTabBarController *controller = appDelegate.rootVC;
        controller.selectedIndex = 0;
        [controller presentViewController:naviController animated:true completion:nil];
        
    } else {
        [superController presentViewController:naviController animated:true completion:nil];
    }
}

@end
