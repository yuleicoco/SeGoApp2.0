//
//  AFHttpClient+PersonMember.h
//  sego2.0
//
//  Created by czx on 16/11/23.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (PersonMember)
//修改会员和宠物基本信息
-(void)modifyMemberWithMid:(NSString *)mid nickname:(NSString *)nickname address:(NSString *)address signature:(NSString *)signature pet_sex:(NSString *)pet_sex pet_birthday:(NSString *)pet_birthday pet_race:(NSString *)pet_race complete:(void (^)(BaseModel * model))completeBlock;

//修改头像
-(void)modifyHeadportraitWithMid:(NSString *)mid
                         picture:(NSString *)picture
                        complete:(void(^)(BaseModel *model))completeBlock;


@end
