//
//  AFHttpClient+Login.m
//  sego2.0
//
//  Created by yulei on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Login.h"

@implementation AFHttpClient (Login)

-(void)Trlogin:(NSString *)nickname secretkey :(NSString *)secretkey headportrait:(NSString *)headportrait rtype:(NSString *)rtype  complete:(void (^)(BaseModel *))completeBlock
{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"common"] = @"otherLogin";
    parms[@"nickname"] =nickname;
    parms[@"secretkey"]=secretkey;
    parms[@"rtype"] = rtype;
    NSMutableDictionary * dataparms = [[NSMutableDictionary alloc]init];
    dataparms[@"headportrait"]= headportrait;
    parms[@"data"] =dataparms;

    
    [self POST:@"clientAction.do?" parameters:parms result:^(BaseModel * model) {
        
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}

@end
