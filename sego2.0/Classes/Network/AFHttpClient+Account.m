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

-(void)getCheckWithPhone:(NSString *)phone type:(NSString *)type complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"check";
    params[@"phone"] = phone;
    params[@"type"] = type;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
        
        
    }];
    
}

-(void)regiestWithPhone:(NSString *)phone password:(NSString *)password complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"memberRegister";
    params[@"phone"] = phone;
    params[@"password"] = password;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
        
        
    }];
}

-(void)forgetPasswordWithPhone:(NSString *)phone password:(NSString *)password complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"forgetPassword";
    params[@"phone"] = phone;
    params[@"password"] = password;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
        
        
    }];

}
-(void)exchangePasswordWithMid:(NSString *)mid password:(NSString *)password complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyPassword";
    params[@"mid"] = mid;
    params[@"password"] = password;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
    
    }];
}


-(void)queryByIdMemberWithMid:(NSString *)mid complete:(void (^)(BaseModel *    ))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryByIdMember";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
        
    }];




}





@end
