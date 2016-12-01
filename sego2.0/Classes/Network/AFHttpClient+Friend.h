//
//  AFHttpClient+Friend.h
//  sego2.0
//
//  Created by czx on 16/11/29.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Friend)
//查询好友列表
-(void)queryFriendsWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel * model))completeBlock;

//搜索好友(用户)
-(void)searchPeopleWithMid:(NSString *)mid condition:(NSString *)condition page:(int)page size:(int)size complete:(void (^)(BaseModel * model))completeBlock;


//申请添加好友
-(void)addFriendRequsetWithMid:(NSString *)mid friend:(NSString *)friendid complete:(void (^)(BaseModel * model))completeBlock;

//新的朋友消息列表
-(void)newFriendsMsgWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel * model))completeBlock;

//同意/拒绝 添加好友
-(void)addFriendResponseWithMid:(NSString *)mid friend:(NSString *)friendId opttype:(NSString *)opttype complete:(void (^)(BaseModel * model))completeBlock;

//删除好友
-(void)delFriendWithMid:(NSString *)mid friend:(NSString *)friendId complete:(void (^)(BaseModel * model))completeBlock;








@end
