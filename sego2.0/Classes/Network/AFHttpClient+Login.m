//
//  AFHttpClient+Login.m
//  sego2.0
//
//  Created by yulei on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Login.h"

@implementation AFHttpClient (Login)

-(void)Trlogin:(NSString *)accountnumber nickname:(NSString *)nickname secretkey :(NSString *)secretkey headportrait:(NSString *)headportrait rtype:(NSString *)rtype  complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"otherLogin";
    parms[@"accountnumber"] = accountnumber;
    parms[@"nickname"] =nickname;
    parms[@"secretkey"]=secretkey;
    parms[@"headportrait"]= headportrait;
    parms[@"rtype"] = rtype;
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}

@end
