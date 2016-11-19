//
//  AFHttpClient+DeviceUseMember.h
//  sego2.0
//
//  Created by yulei on 16/11/18.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (DeviceUseMember)

/**
 *  设备使用记录
 */
-(void)DeviceUseMember:(NSString *)mid object :(NSString *)object deviceno:(NSString *)deviceno belong:(NSString *)belong starttime:(NSString *)starttime    complete:(void (^)(BaseModel *))completeBlock;

@end
