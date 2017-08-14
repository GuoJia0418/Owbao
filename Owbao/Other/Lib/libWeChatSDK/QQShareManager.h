//
//  QQShareManager.h
//  Owbao
//
//  Created by 一言难尽 on 2017/1/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  因QQ分享回调和微信分享相同，所以重新写个单例

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface QQShareManager : NSObject <QQApiInterfaceDelegate>

+ (QQShareManager *)defaultManager;

- (void)qqShare:(NSString *)title
    description:(NSString *)description
        withKey:(NSString *)qqKey
        withURL:(NSString *)url
      withImage:(NSString *)imageURLString
       callback:(void (^)(BOOL isSuccess))callback;

@end
