//
//  JPushManager.h
//  Owbao
//
//  Created by 一言难尽 on 2017/3/7.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PushManager : NSObject

+ (PushManager *)shareManager; //单例

@property (nonatomic,strong) NSString *deviceToken;  //设备的标识符

//注册友盟推送
- (void)registerUMPushManager:(NSDictionary *)launchOptions
                    UMPushKey:xUMPushKey;

/**
 *  处理远程发送的通知
 *  1、程序正在运行时候会在顶部下拉一个view显示通知内容 
 *  2、程序未运行或者在后台，系统会发送通知，当点击通知时候，就会调用该方法
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

@end
