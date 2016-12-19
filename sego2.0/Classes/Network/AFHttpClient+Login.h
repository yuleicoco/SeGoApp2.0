//
//  AFHttpClient+Login.h
//  sego2.0
//
//  Created by yulei on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Login)

/**
 *    第三方登录
 */
-(void)Trlogin:(NSString *)nickname secretkey :(NSString *)secretkey headportrait:(NSString *)headportrait rtype:(NSString *)rtype  complete:(void (^)(BaseModel *))completeBlock;

/**
 *    逗一逗  会员权限
 */
-(void)CheckCode:(NSString *)playcode  complete:(void (^)(BaseModel *))completeBlock;

/**
 *    逗码
 */

-(void)CheckDouCode:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock;

@end
