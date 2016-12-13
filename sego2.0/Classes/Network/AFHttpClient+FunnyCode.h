//
//  AFHttpClient+FunnyCode.h
//  sego2.0
//
//  Created by czx on 16/12/13.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (FunnyCode)
//生成逗码
-(void)generatePlayCodeWithMid:(NSString *)mid tsnum:(NSString *)tsnum complete:(void (^)(BaseModel * model))completeBlock;

//查询是否有效逗码
-(void)queryPlayCodeWithMid:(NSString *)mid complete:(void (^)(BaseModel * model))completeBlock;

//取消逗吗
-(void)dePlayCodeWithPlayCode:(NSString *)playCode complete:(void (^)(BaseModel * model))completeBlock;










@end
