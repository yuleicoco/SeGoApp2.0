//
//  AFHttpClient.m
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@implementation AFHttpClient


singleton_implementation(AFHttpClient)



-(instancetype)init
{
    if (self = [super initWithBaseURL:[NSURL URLWithString: [AppUtil getServerSego3]]]) {
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", @"application/json", nil];
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"-------3G/4G------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------WIFI------");
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    
                    break;
                default:
                    break;
            }
        }];
        [self.reachabilityManager startMonitoring];
    }
    
    return self;

    
}


/*
- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters result:(void (^)(BaseModel* model))result {
    
    parameters[@"classes"] = @"appinterface";
    parameters[@"method"] = @"json";
    
    return [super POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError* error = nil;
        //  NSLog(@"respons === %@", [self DataTOjsonString:responseObject]);
        BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject[@"jsondata"] error:&error];
        
        if (error || [model.retCode integerValue] != 0) {
            [[AppUtil appTopViewController] showHint:error ? [error localizedDescription] : model.retDesc];
            
            if (result) {
                result(nil);
            }
            return ;
        }
        
        if (result) {
            result(model);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (result) {
            result(nil);
        }
    }];
}

 */


/**
 * POST 在此block种可以为上传的参数添加(拼接)新的需要的上传的数据,适用于上传给服务器的数据流比较大的时候
 * af中一般post请求的参数都为字典类型
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters result:(void (^)(BaseModel * model))result {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     [self POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         
         if (parameters) {
             NSString* paramsStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]  encoding:NSUTF8StringEncoding];
             // key 可以为任意值
             [formData appendPartWithFormData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding] name:@"rp"];
         }
         
         NSLog(@"在此过程中可以打印上传进度");
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
         NSLog(@"成功");
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         BaseModel* model = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
       //  retCode : 返回状态码（成功：0000，失败：1111，异常：2222
         
         if ([model.retCode isEqualToString:@"0000"]) {
               [[AppUtil appTopViewController] showHint:model.retDesc];
             if (result) {
                 result(model);
             }
         }else{
             
             [[AppUtil appTopViewController] showHint:model.retDesc];
             if (result) {
                 result(nil);
             }
         }

         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"失败");
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         if (result) {
             result(nil);
         }

         
     }];
    

    
}




@end
