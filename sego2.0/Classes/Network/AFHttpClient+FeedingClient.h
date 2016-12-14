//
//  AFHttpClient+FeedingClient.h
//  petegg
//
//  Created by czx on 16/4/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (FeedingClient)


//查询喂食设置
-(void)queryFeedingtimeWithMid:(NSString *)mid
                        status:(NSString *)status
                           complete:(void(^)(BaseModel *model))completeBlock;

//添加喂食
-(void)addFeedingtimeWithMid:(NSString *)mid
                         type:(NSString *)type
                         times:(NSString *)times
                         deviceno:(NSString *)deviceno
                         termid:(NSString *)termid
                         complete:(void(^)(BaseModel *model))completeBlock;

//删除喂食
-(void)cancelFeedingtimeWithbrid:(NSString *)brid
                            complete:(void(^)(BaseModel *model))completeBlock;






@end
