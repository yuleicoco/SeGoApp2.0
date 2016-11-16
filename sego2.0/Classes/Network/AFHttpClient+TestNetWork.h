//
//  AFHttpClient+TestNetWork.h
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (TestNetWork)

/**
 *  测试网络请求
 */

 // phone:手机号码，type:类型(register注册modifypassword修改密码)

-(void)TestNet:(NSString *)phone type:(NSString *)type  complete:(void (^)(BaseModel *))completeBlock;





@end
