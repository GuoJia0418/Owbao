//
//  PD_WebView.h
//  Owbao
//
//  Created by Panda on 16/5/18.
//  Copyright © 2016年 lufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge.h"
@interface PD_WebView : NSObject{
    
}
+ (PD_WebView *) shareInstance;
@property WebViewJavascriptBridge* bridge;
- (void)jsCreate:(UIWebView *)webView;
- (void)callJSAction;
@end
