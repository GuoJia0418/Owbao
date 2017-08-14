//
//  Common.m
//  Owbao
//
//  Created by GuoJia on 16/12/1.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//- (void)aa {
//    
//        UIImageView *avaImageView =(UIImageView *) [self.tableView viewWithTag:355];
//        avaImageView.image = image;
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        
//        // 设置request
//        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//        [request setHTTPShouldHandleCookies:NO];
//        [request setTimeoutInterval:30];
//        [request setHTTPMethod:@"POST"];
//        
//        NSString *BoundaryConstant = [NSString stringWithFormat:@"----------V2ymHFg03ehbqgZCaKO6jy"];
//        NSString *FileParamConstant = [NSString stringWithFormat:@"myfile"];
//        
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
//        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//        [request setValue:[CommonUtils getUA] forHTTPHeaderField:@"User-Agent"];
//        NSString *xsrf = [CommonUtils GT];
//        NSString *xsrf_token = [CommonUtils CT:xsrf];
//        
//        NSMutableData *body = [NSMutableData data];
//        
//        // add params (all params are strings)
//        NSMutableDictionary *myparams = [[NSMutableDictionary alloc] init];
//        [myparams setObject:xsrf forKey:@"xsrf"];
//        [myparams setObject:xsrf_token forKey:@"token"];
//        [myparams setObject:self.userInfo[@"user_id"] forKey:@"uid"];
//    
//        for (NSString *param in myparams) {
//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [myparams objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        // add image data
////        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
////        if (imageData) {
////            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
////            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
////            [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
////            [body appendData:imageData];
////            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
////        }
//    
//        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        // setting the body of the post to the reqeust
//        [request setHTTPBody:body];
//        
//        // set the content-length
//        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        
//        // set URL
//        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v2.0/user/avatar/upload", SERVER_ADDRESS]]];
//    
//        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//         {
//             if (error) {
//                 NSLog(@"recv data error: %@", [error description]);
//             } else {
//                 
//             }
//         }];
//}

@end
