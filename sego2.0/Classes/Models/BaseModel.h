//
//  BaseModel.h
//  sego2.0
//
//  Created by yulei on 16/11/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

//#import <MojoDatabase/MojoDatabase.h>
#import "JSONModel.h"


@interface BaseModel : JSONModel

@property (nonatomic, copy) NSDictionary<Optional> *retVal;

@property (nonatomic, copy) NSString<Optional> *content;

@property (nonatomic, copy) NSString<Optional> *retDesc;

@property (nonatomic, copy) NSString<Optional> *retCode;

@property (nonatomic, strong) NSArray<Optional> *list;

@property (nonatomic, copy) NSString<Optional> *totalrecords;

@end
