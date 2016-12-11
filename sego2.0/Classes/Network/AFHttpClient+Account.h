//
//  AFHttpClient+Account.h
//  sego2.0
//
//  Created by czx on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Account)
//登录
-(void)loginWithAccounynumber:(NSString *)accountnumber password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock;

//获取验证码
-(void)getCheckWithPhone:(NSString *)phone type:(NSString *)type complete:(void (^)(BaseModel * model))completeBlock;

//注册
-(void)regiestWithPhone:(NSString *)phone password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock;

//忘记密码
-(void)forgetPasswordWithPhone:(NSString *)phone password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock;

//修改密码
-(void)exchangePasswordWithMid:(NSString *)mid password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock;






@end
