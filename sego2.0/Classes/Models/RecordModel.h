//
//  RecordModel.h
//  petegg
//
//  Created by ldp on 16/6/28.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface RecordModel : JSONModel

@property (nonatomic, copy) NSString *thumbnails;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *opttime;

@property (nonatomic, copy) NSString *networkaddress;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *filename;

@property (nonatomic, copy) NSString *vid;

//数组
@property (nonatomic, copy) NSArray *networkaddressArray;

@property (nonatomic, copy) NSArray *thumbailsArray;

@property (nonatomic, copy) NSArray *typeArray;

@property (nonatomic, copy) NSArray * filenameArray;

@end
