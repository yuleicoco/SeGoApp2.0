//
//  AFHttpClient+Permission.m
//  sego2.0
//
//  Created by czx on 16/12/11.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Permission.h"
#import "RuleModel.h"
#import "ZdFriendModel.h"

@implementation AFHttpClient (Permission)
-(void)queryRuleWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryRule";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [RuleModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
}


-(void)ruleModifyStatusWithMid:(NSString *)mid rid:(NSString *)rid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleModifyStatus";
    params[@"mid"] = mid;
    params[@"rid"] = rid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
//        if (model) {
//            model.list = [RuleModel arrayOfModelsFromDictionaries:model.list];
//        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)ruleDelWithRid:(NSString *)rid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleDel";
    params[@"rid"] = rid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [RuleModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)ruleSetWithMid:(NSString *)mid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends tsnum:(NSString *)tsnum complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleSet";
    params[@"mid"] = mid;
    params[@"rulesname"] = rulesname;
    params[@"object"] = object;
    params[@"friends"] = friends;
    params[@"tsnum"] = tsnum;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [RuleModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)ruleModifyInfoWithMid:(NSString *)mid rulesname:(NSString *)rulesname object:(NSString *)object friends:(NSString *)friends tsnum:(NSString *)tsnum complete:(void (^)(BaseModel *))completeBlock{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleModifyInfo";
    params[@"rid"] = mid;
    params[@"rulesname"] = rulesname;
    params[@"object"] = object;
    params[@"friends"] = friends;
    params[@"tsnum"] = tsnum;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [RuleModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];




}


-(void)ruleSetQueryFriendWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[ NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleSetQueryFriend";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [ZdFriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)ruleSetQueryExchangeFriendWithMid:(NSString *)mid rid:(NSString *)rid page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[ NSMutableDictionary alloc]init];
    params[@"common"] = @"ruleSetQueryFriend";
    params[@"mid"] = mid;
    params[@"rid"] = rid;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [ZdFriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

    



}





@end
