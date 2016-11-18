//
//  AFHttpClient+VideoQuiltChoose.m
//  sego2.0
//
//  Created by yulei on 16/11/18.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+VideoQuiltChoose.h"

@implementation AFHttpClient (VideoQuiltChoose)


-(void)VideoQuiltChoose:(NSString *)mid vtype:(NSString *)vtype   complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"chooseVideoQuality";
    parms[@"mid"] = mid;
    parms[@"vtype"]= vtype;
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}

@end
