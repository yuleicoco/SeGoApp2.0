//
//  AFHttpClient+Article.h
//  sego2.0
//
//  Created by czx on 16/12/1.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Article)
//查询平台内推荐信息
-(void)querRecommedcomplete:(void (^)(BaseModel * model))completeBlock;

//添加收藏
-(void)addArticleWithMid:(NSString *)mid content:(NSString *)content type:(NSString *)type resources:(NSString *)resources complete:(void (^)(BaseModel * model))completeBlock;

//查询收藏
-(void)queryArticlesWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel * model))completeBlock;






@end
