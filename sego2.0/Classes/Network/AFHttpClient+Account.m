//
//  AFHttpClient+Account.m
//  sego2.0
//
//  Created by czx on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Account.h"

@implementation AFHttpClient (Account)
-(void)loginWithAccounynumber:(NSString *)accountnumber password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"memberLogin";
    params[@"accountnumber"] = accountnumber;
    params[@"password"] = password;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {

        if (completeBlock) {
            completeBlock(model);
        }
        
        
    }];

    
    
    
    
    
    
    
    

}




@end
