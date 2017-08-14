//
//  PD_WebView.m
//  Owbao
//
//  Created by Panda on 16/5/18.
//  Copyright © 2016年 lufeng. All rights reserved.
//

#import "PD_WebView.h"
static PD_WebView *pdWebView;
@implementation PD_WebView

+ (PD_WebView *) shareInstance{
    if (pdWebView == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pdWebView = [[PD_WebView alloc] init];
        });
    }
    return pdWebView;
}
-(void)jsCreate:(UIWebView *)webView{
    //webView可以是UIWebView或WKWebView
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
//    [self.bridge setWebViewDelegate:webView.delegate];
    [self.bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        NSLog(@"testObjcCallback called: %@", [data objectForKey:@"ok"]);
        responseCallback(@"Response from testObjcCallback");
    }];
}

- (void)callJSAction{
//    [self.bridge callHandler:@"putData" data:nil];
    [self.bridge callHandler:@"testJavascriptHandler" data:@"1.1.1.1.1.1.1" responseCallback:^(id responseData) {
        NSLog(@"callBack:%@",responseData);
    }];
    
    
//    [self.bridge registerHandler:@"handlerName" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"registerHandler");
//    }];
//    
//    [self.bridge registerHandler:@"testJavascriptHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"registerHandler");
//    }];
    
}

- (void)handlerName{
    NSLog(@"jsCall");
}
@end
