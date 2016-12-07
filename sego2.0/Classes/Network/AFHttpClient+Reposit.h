//
//  AFHttpClient+Reposit.h
//  sego2.0
//
//  Created by czx on 16/12/2.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Reposit)

//获取会员录像信息（资源库录像）
-(void)getVideoWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel * model))completeBlock;

//资源库抓拍
-(void)getPhotoGraphWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel * model))completeBlock;



@end
