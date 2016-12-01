//
//  AFHttpClient+Article.m
//  sego2.0
//
//  Created by czx on 16/12/1.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Article.h"

@implementation AFHttpClient (Article)
-(void)querRecommedcomplete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryRecommend";
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [RecommendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    



}


@end
