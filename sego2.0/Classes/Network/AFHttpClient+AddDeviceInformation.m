//
//  AFHttpClient+AddDeviceInformation.m
//  sego2.0
//
//  Created by yulei on 16/11/17.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+AddDeviceInformation.h"

@implementation AFHttpClient (AddDeviceInformation)


-(void)AddDeviceStats:(NSString *)mid deviceno:(NSString *)deviceno   complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"addDevice";
    parms[@"mid"] = mid;
    parms[@"deviceno"]= deviceno;
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}

@end
