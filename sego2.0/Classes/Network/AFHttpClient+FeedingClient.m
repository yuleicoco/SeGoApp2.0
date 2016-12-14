//
//  AFHttpClient+FeedingClient.m
//  petegg
//
//  Created by czx on 16/4/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+FeedingClient.h"
#import "FeddingModel.h"

@implementation AFHttpClient (FeedingClient)

-(void)queryFeedingtimeWithMid:(NSString *)mid status:(NSString *)status complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryFeedingtime";
    params[@"mid"] = mid;

    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
              model.list = [FeddingModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}


-(void)addFeedingtimeWithMid:(NSString *)mid type:(NSString *)type times:(NSString *)times deviceno:(NSString *)deviceno termid:(NSString *)termid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"setFeedingtime";
    params[@"mid"] = mid;
    params[@"type"] = type;
    params[@"times"] = times;
    params[@"deviceno"] = deviceno;
    params[@"termid"] = termid;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {

        if (model){
//            model.list = [FeddingModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

}


-(void)cancelFeedingtimeWithbrid:(NSString *)brid complete:(void (^)(BaseModel *))completeBlock{
     NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"cancelFeedingtime";
    params[@"brid"] = brid;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (model){
            //            model.list = [FeddingModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];






}

@end
