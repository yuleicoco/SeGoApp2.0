//
//  AFHttpClient+Reposit.m
//  sego2.0
//
//  Created by czx on 16/12/2.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Reposit.h"

@implementation AFHttpClient (Reposit)
-(void)getVideoWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"getVideo";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
        model.list = [RecordModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
}

-(void)getPhotoGraphWithMid:(NSString *)mid page:(int)page complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"getPhotoGraph";
    params[@"mid"] = mid;
    params[@"page"] = @(page);
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model) {
            model.list = [PhotoGrapgModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];






}









@end
