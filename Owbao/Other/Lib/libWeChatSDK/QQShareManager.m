//
//  QQShareManager.m
//  Owbao
//
//  Created by 一言难尽 on 2017/1/13.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

#import "QQShareManager.h"

static QQShareManager *manager;

@interface QQShareManager()

@property (nonatomic,copy) void (^shareCallback)(BOOL isSuccess); //分享后回调

@end

@implementation QQShareManager

+ (QQShareManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QQShareManager alloc] init];
    });
    return manager;
}

//MARK: QQ分享
- (void)qqShare:(NSString *)title
     description:(NSString *)description
        withKey:(NSString *)qqKey
        withURL:(NSString *)url
      withImage:(NSString *)imageURLString
       callback:(void (^)(BOOL isSuccess))callback {
    
    TencentOAuth *OAuth = [[TencentOAuth alloc] initWithAppId:qqKey andDelegate:nil];
    if (OAuth) {
        QQApiSendResultCode  sent = [QQApiInterface sendReq:[self sendsendTencenLink:title withURL:url withImage:imageURLString description:description]];
        [self handleSendResult:sent];
    }
    
    //保存
    self.shareCallback = callback;
}

- (SendMessageToQQReq *)sendsendTencenLink:(NSString *)titleStr
                                   withURL:(NSString *)url
                                 withImage:(NSString *)imageURLString
                               description:(NSString *)description {
    
    if ([QQApiInterface isQQInstalled]) {//是否安装QQ
        
        if ([QQApiInterface isQQSupportApi]) {//是否可以调用
            
            QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                            title:titleStr
                                                      description:description
                                                  previewImageURL:[NSURL URLWithString:imageURLString]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
            return req;
            
        } else {
            //        QQ版本太低不支持调用
            return nil;
        }
    } else {//否
        //        您尚未安装QQ,不能进行分享
        return nil;
    }
    return nil;
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
            
        case EQQAPIAPPNOTREGISTED: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        case EQQAPIQQNOTINSTALLED: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        case EQQAPIQQNOTSUPPORTAPI: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        case EQQAPISENDFAILD: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        default: {
            break;
        }
    }
}

#pragma ----- QQApiInterfaceDelegate

/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    if ([resp.result isEqualToString:@"0"]) {
        if (self.shareCallback) {
            self.shareCallback(YES);
        }
    } else {
        if (self.shareCallback) {
            self.shareCallback(NO);
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}


@end
