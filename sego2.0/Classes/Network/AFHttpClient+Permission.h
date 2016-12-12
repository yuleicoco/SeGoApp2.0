//
//  AFHttpClient+Permission.h
//  sego2.0
//
//  Created by czx on 16/12/11.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Permission)
//查询规则
-(void)queryRuleWithMid:(NSString *)mid complete:(void (^)(BaseModel * model))completeBlock;

//规则状态修改（换成哪个规则）
-(void)ruleModifyStatusWithMid:(NSString *)mid rid:(NSString *)rid complete:(void (^)(BaseModel * model))completeBlock;

//删除规则
-(void)ruleDelWithRid:(NSString *)rid complete:(void (^)(BaseModel * model))completeBlock;

//新建规则
-(void)ruleSetWithMid:(NSString *)mid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends tsnum:(NSString *)tsnum complete:(void (^)(BaseModel * model))completeBlock;

//修改规则
-(void)ruleModifyInfoWithMid:(NSString *)mid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends tsnum:(NSString *)tsnum complete:(void (^)(BaseModel * model))completeBlock;






@end
