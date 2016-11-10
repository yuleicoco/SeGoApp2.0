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
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
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


@end
