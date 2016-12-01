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



@end
