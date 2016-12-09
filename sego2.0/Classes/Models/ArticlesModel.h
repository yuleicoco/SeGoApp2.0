//
//  ArticlesModel.h
//  sego2.0
//
//  Created by czx on 16/12/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BaseModel.h"

@interface ArticlesModel : BaseModel
@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * publishtime;
@property (nonatomic,copy)NSString <Optional> * publishuser;
@property (nonatomic,copy)NSString <Optional> * resources;
@property (nonatomic,copy)NSString <Optional> * thumbnails;
@property (nonatomic,copy)NSString <Optional> * type;


@end
