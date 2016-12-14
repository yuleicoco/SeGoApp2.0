//
//  FeddingModel.h
//  petegg
//
//  Created by czx on 16/4/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface FeddingModel : JSONModel
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * mid;
@property (nonatomic,copy)NSString <Optional> * times;
@property (nonatomic,copy)NSString <Optional> * type;
@property (nonatomic,copy)NSString <Optional> * brid;


@end
