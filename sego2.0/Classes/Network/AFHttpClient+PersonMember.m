//
//  AFHttpClient+PersonMember.m
//  sego2.0
//
//  Created by czx on 16/11/23.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient+PersonMember.h"

@implementation AFHttpClient (PersonMember)
-(void)modifyMemberWithMid:(NSString *)mid nickname:(NSString *)nickname address:(NSString *)address signature:(NSString *)signature pet_sex:(NSString *)pet_sex pet_birthday:(NSString *)pet_birthday pet_race:(NSString *)pet_race complete:(void (^)(BaseModel *))completeBlock
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyMember";
    params[@"mid"] = mid;
    params[@"nickname"] = nickname;
    params[@"address"] = address;
    params[@"signature"] = signature;
    params[@"pet_sex"] = pet_sex;
    params[@"pet_birthday"] = pet_birthday;
    params[@"pet_race"] = pet_race;
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        
        if (completeBlock) {
            completeBlock(model);
        }
        
    }];
    

}

-(void)modifyHeadportraitWithMid:(NSString *)mid picture:(NSString *)picture complete:(void (^)(BaseModel *))completeBlock{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"common"] = @"modifyHeadportrait";
    params[@"mid"] = mid;
    params[@"picture"] = picture;
    
    [self POST:@"clientAction.do" parameters:params result:^(BaseModel *model) {
        if (model){
            // model.list = [InformationModel arrayOfModelsFromDictionaries:model.list];
        }
        if (completeBlock) {
            completeBlock(model);
        }
    }];
    
    
}







@end
