//
//  AFHttpClient+Friend.m
//  sego2.0
//
//  Created by czx on 16/11/29.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Friend.h"

@implementation AFHttpClient (Friend)
-(void)queryFriendsWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryFriends";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
        model.list = [FriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
        
    }];


}

-(void)searchPeopleWithMid:(NSString *)mid condition:(NSString *)condition page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"searchPeople";
    params[@"mid"] = mid;
    params[@"condition"] = condition;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
        model.list = [FriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)addFriendRequsetWithMid:(NSString *)mid friend:(NSString *)friendid complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"addFriendRequest";
    params[@"mid"] = mid;
    params[@"friend"] = friendid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
//        if (model) {
//            model.list = [FriendModel arrayOfModelsFromDictionaries:model.list];
//        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
}

-(void)newFriendsMsgWithMid:(NSString *)mid page:(int)page size:(int)size complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"newFriendsMsg";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    params[@"size"] = @(size);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [NewFriendModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}

-(void)addFriendResponseWithMid:(NSString *)mid friend:(NSString *)friendId opttype:(NSString *)opttype complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"addFriendResponse";
    params[@"mid"] = mid;
    params[@"friend"] = friendId;
    params[@"opttype"] = opttype;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
//        if (model) {
//            model.list = [NewFriendModel arrayOfModelsFromDictionaries:model.list];
//        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)delFriendWithMid:(NSString *)mid friend:(NSString *)friendId complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"delFriend";
    params[@"mid"] = mid;
    params[@"friend"] = friendId;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [NewFriendModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)newFriendsMsgCountWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"newFriendsMsgCount";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [NewFriendModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)modifyFriendsMsgStatusWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyFriendsMsgStatus";
    params[@"mid"] = mid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [NewFriendModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];




}










@end
