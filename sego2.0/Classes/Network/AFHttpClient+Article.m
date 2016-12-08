//
//  AFHttpClient+Article.m
//  sego2.0
//
//  Created by czx on 16/12/1.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Article.h"
#import "ArticlesModel.h"

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

-(void)addArticleWithMid:(NSString *)mid content:(NSString *)content type:(NSString *)type resources:(NSString *)resources complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"addArticle";
    params[@"mid"] = mid;
    params[@"content"] = content;
    params[@"type"] = type;
    params[@"resources"] = resources;

    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
//        if (model) {
//            model.list = [RecommendModel arrayOfModelsFromDictionaries:model.list];
//        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)queryArticlesWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryArticles";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [ArticlesModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];







}









@end
