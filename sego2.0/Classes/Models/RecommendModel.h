//
//  RecommendModel.h
//  sego2.0
//
//  Created by czx on 16/12/1.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendModel : BaseModel
@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * frontcover;
@property (nonatomic,copy)NSString <Optional> * opttime;
@property (nonatomic,copy)NSString <Optional> * optuser;
@property (nonatomic,copy)NSString <Optional> * title;
@property (nonatomic,copy)NSString <Optional> * type;



@end
