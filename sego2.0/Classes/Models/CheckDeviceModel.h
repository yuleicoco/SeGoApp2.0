//
//  CheckDeviceModel.h
//  sebot
//
//  Created by yulei on 16/6/20.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface CheckDeviceModel : JSONModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
+ (instancetype)modelWithDictionary: (NSDictionary *) data;


@property (nonatomic,copy)NSString *activationtime;//
@property (nonatomic,copy)NSString *channelid;
@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *createuser;
@property (nonatomic,copy)NSString *deviceno;
@property (nonatomic,copy)NSString *deviceremark;
@property (nonatomic,copy)NSString * did;
@property (nonatomic,copy)NSString * isactivation;
@property (nonatomic,copy)NSString * sipno;
@property (nonatomic,copy)NSString * sippw;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * termid;
@property (nonatomic,copy)NSString * type;


@end
