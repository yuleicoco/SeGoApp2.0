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
        //        if (model) {
        //        model.list = [SearchModel arrayOfModelsFromDictionaries:model.retVal];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
        
    }];






}


@end
