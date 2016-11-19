//
//  AFHttpClient+DeviceStats.m
//  sego2.0
//
//  Created by yulei on 16/11/17.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+DeviceStats.h"
#import "DeviceStats.h"

@implementation AFHttpClient (DeviceStats)

-(void)DeviceStats:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"queryMyDevice";
    parms[@"mid"] = mid;
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
          model.list = [DeviceStats arrayOfModelsFromDictionaries:model.list];

                if (model) {
                    completeBlock(model);
                }
        
    }];
    

    
}

@end
