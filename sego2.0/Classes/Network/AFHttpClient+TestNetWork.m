//
//  AFHttpClient+TestNetWork.m
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+TestNetWork.h"
#import "CheckDeviceModel.h"

@implementation AFHttpClient (TestNetWork)

// step one
-(void)TestNet:(NSString *)phone type:(NSString *)type  complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"check";
    parms[@"phone"] = phone;
    parms[@"type"] = type;
    
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
      //  model.list = [CheckDeviceModel arrayOfModelsFromDictionaries:model.list];
        
//        if (model) {
//            completeBlock(model);
//        }
        
    }];
    
    
    
}

@end


