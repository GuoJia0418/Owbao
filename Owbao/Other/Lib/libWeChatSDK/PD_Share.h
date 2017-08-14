//
//  PD_Share.h
//  YZApp
//
//  Created by Panda on 16/3/19.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface PD_Share: NSObject <WXApiDelegate>

+ (PD_Share *) shareInstance;

//发送到朋友圈
- (void)wxShare:(NSString *)title
    description:(NSString *)description
        withURL:(NSString *)url
      withImage:(UIImage *)image
      withScene:(int) scene
      callback:(void (^)(BOOL isSuccess))callback;

//发送给朋友
- (void)wxShareToFriends:(NSString *)title
             description:(NSString *)description
                 withURL:(NSString *)URL
               withImage:(UIImage *)image
                callback:(void (^)(BOOL isSuccess))callback;


- (BOOL)respLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage;

@end
