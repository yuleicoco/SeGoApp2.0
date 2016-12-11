//
//  HomeDetailModel.h
//  sego2.0
//
//  Created by czx on 16/12/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BaseModel.h"

@interface HomeDetailModel : BaseModel
@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * headportrait;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * publishtime;
@property (nonatomic,copy)NSString <Optional> * publishuser;
@property (nonatomic,copy)NSString <Optional> * resources;
@property (nonatomic,copy)NSString <Optional> * thumbnails;
@property (nonatomic,copy)NSString <Optional> * type;



@property (nonatomic, strong) UIImage<Optional> *cutImage;





@end
