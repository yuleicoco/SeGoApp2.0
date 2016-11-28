//
//  AFHttpClient+Found.m
//  sego2.0
//
//  Created by czx on 16/11/28.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+Found.h"

@implementation AFHttpClient (Found)
-(void)searchPlaycodeWithPlaycode:(NSString *)playcode complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"searchPlaycodeOwner";
    params[@"playcode"] = playcode;
    
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
