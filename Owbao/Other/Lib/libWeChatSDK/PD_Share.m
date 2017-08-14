//
//  PD_Share.m
//  YZApp
//
//  Created by Panda on 16/3/19.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "PD_Share.h"
#import "WXApi.h"

static PD_Share *pdShare;

@interface PD_Share()

@property (nonatomic,copy) void (^shareCallback)(BOOL isSuccess); //分享给回调

@end

@implementation PD_Share
+ (PD_Share *) shareInstance{
    if (pdShare == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pdShare = [[PD_Share alloc] init];
        });
    }
    return pdShare;
}

- (void)wxShare:(NSString *)title
    description:(NSString *)description
        withURL:(NSString *)url
      withImage:(UIImage *)image
      withScene:(int) scene
       callback:(void (^)(BOOL isSuccess))callback {
    
    WXMediaMessage *message       = [WXMediaMessage message];
    WXWebpageObject *wxWebpageObj = [WXWebpageObject object];
    
    wxWebpageObj.webpageUrl       = url;
    message.mediaObject           = wxWebpageObj;
    message.description = description;
    
//    NSURL * urlStr = [NSURL URLWithString:@"https://www.jushengcaifu.com/images/applogo.png"];
//    NSData * data = [NSData dataWithContentsOfURL:urlStr];
//    UIImage * img = [UIImage imageWithData:data];
//    if (img == nil)
//    {
//        img = [UIImage imageNamed:@"AppIcon"];
//    }
//    [message setThumbImage:image];
    
    [message setThumbImage:image];
    
    message.title                 = title;

    SendMessageToWXReq* req       = [[SendMessageToWXReq alloc] init];
    req.bText                     = NO;
    req.message                   = message;
    req.scene                     = WXSceneTimeline;
    req.text                      = title;
    
    [WXApi sendReq:req];
    
    //保存
    self.shareCallback = callback;
}

//发送给朋友
- (void)wxShareToFriends:(NSString *)title
             description:(NSString *)description
                 withURL:(NSString *)URL
               withImage:(UIImage *)image
                callback:(void (^)(BOOL isSuccess))callback {
    
    WXMediaMessage *message       = [WXMediaMessage message];
    WXWebpageObject *wxWebpageObj = [WXWebpageObject object];
    wxWebpageObj.webpageUrl       = URL;
    message.mediaObject           = wxWebpageObj;
    
    [message setThumbImage:image];
    message.title                 = title;
    message.description           = description;
    
    SendMessageToWXReq* req       = [[SendMessageToWXReq alloc] init];
    req.bText                     = NO;
    req.message                   = message;
    req.scene                     = WXSceneSession;
    req.text                      = title;
    
    [WXApi sendReq:req];
    
    //保存
    self.shareCallback = callback;
}

- (BOOL)respLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage {
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    [message setThumbImage:thumbImage];
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc]init];
    resp.bText = NO;
    if (resp.bText) {
        resp.text = nil;
    }
    else
    {
        resp.message = message;
    }
    
    return [WXApi sendResp:resp];

}


#pragma mark - WXApiDelegate
/**
 *  委托的处理
 */
- (void)onResp:(BaseResp *)resp {
    NSLog(@"输出为新分享后的结果");
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        if (resp.errCode == 0) { //分享成功
            if (self.shareCallback) {
                self.shareCallback(YES);
            }
        } else {
            if (self.shareCallback) { //分享失败
                self.shareCallback(NO);
            }
        }
    }
}

- (void)onReq:(BaseReq *)req {
    
}

@end
