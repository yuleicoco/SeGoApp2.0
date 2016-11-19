//
//  AFHttpClient.h
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BaseModel.h"

//共用url字段
#define BASE_URL    @"http://180.97.80.227:8082/"
#define BASE_URL_Test              @"http://180.97.81.213:16202/sego2/"


@interface AFHttpClient : AFHTTPRequestOperationManager

/**
 * POST请求
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters result:(void (^)(BaseModel* model))result;

+ (AFHttpClient *)sharedAFHttpClient;




@end
