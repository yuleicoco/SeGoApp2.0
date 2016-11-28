//
//  AFHttpClient+DeviceUseMember.m
//  sego2.0
//
//  Created by yulei on 16/11/18.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+DeviceUseMember.h"

@implementation AFHttpClient (DeviceUseMember)

-(void)DeviceUseMember:(NSString *)mid object :(NSString *)object deviceno:(NSString *)deviceno belong:(NSString *)belong starttime:(NSString *)starttime    complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"addDeviceUseRecord";
    parms[@"mid"] = mid;
    parms[@"object"]= object;
    parms[@"deviceno"] = deviceno;
    parms[@"belong"]= belong;
    parms[@"starttime"]= starttime;
    
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}


- (void)OverDeviceMember:(NSString *)did  complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"updateDeviceUseRecord";
    parms[@"id"] = did;
    
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
    
}



@end
