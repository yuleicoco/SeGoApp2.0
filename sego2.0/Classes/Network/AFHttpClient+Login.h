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
 *    检查逗码
 */

-(void)CheckDouCode:(NSString *)mid playCode :(NSString *)playcode  complete:(void (^)(BaseModel *))completeBlock;
@end
