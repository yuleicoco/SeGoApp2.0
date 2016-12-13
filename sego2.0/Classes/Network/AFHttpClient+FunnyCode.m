//
//  AFHttpClient+FunnyCode.m
//  sego2.0
//
//  Created by czx on 16/12/13.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+FunnyCode.h"

@implementation AFHttpClient (FunnyCode)
-(void)generatePlayCodeWithMid:(NSString *)mid tsnum:(NSString *)tsnum complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"generatePlayCode";
    params[@"mid"] = mid;
    params[@"tsnum"] = tsnum;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
//        if (model) {
//            model.list = [PhotoGrapgModel arrayOfModelsFromDictionaries:model.list];
//        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];

    
    
    

}

-(void)queryPlayCodeWithMid:(NSString *)mid complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"queryPlayCode";
    params[@"mid"] = mid;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [PhotoGrapgModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}

-(void)dePlayCodeWithPlayCode:(NSString *)playCode complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"delPlayCode";
    params[@"playcode"] = playCode;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        //        if (model) {
        //            model.list = [PhotoGrapgModel arrayOfModelsFromDictionaries:model.list];
        //        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];


}



@end
