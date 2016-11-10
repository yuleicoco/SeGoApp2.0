//
//  AFHttpClient+TestNetWork.m
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+TestNetWork.h"

@implementation AFHttpClient (TestNetWork)


-(void)TestNet:(NSString *)phone type:(NSString *)type  complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"check";
    NSMutableDictionary * dataparms = [[NSMutableDictionary alloc]init];
    dataparms[@"phone"] = phone;
    dataparms[@"type"] = type;
    parms[@"data"] =dataparms;
    
    [self POST:@"sebot/moblie/forward" parameters:parms result:^(BaseModel * model) {
        
       // model.list = [CheckDeviceModel arrayOfModelsFromDictionaries:model.list];
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
    
    
}

@end


