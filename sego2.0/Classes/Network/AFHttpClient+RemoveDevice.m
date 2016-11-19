//
//  AFHttpClient+RemoveDevice.m
//  sego2.0
//
//  Created by yulei on 16/11/19.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+RemoveDevice.h"

@implementation AFHttpClient (RemoveDevice)


-(void)RemoveDevice:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"delDevice";
    parms[@"mid"] = mid;
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];

    
}

@end
