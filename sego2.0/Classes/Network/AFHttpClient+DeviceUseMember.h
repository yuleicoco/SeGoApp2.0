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


/**
 *  更新设备使用记录
 */

- (void)OverDeviceMember:(NSString *)did  complete:(void (^)(BaseModel *))completeBlock;


/**
 *  开关灯
 */
- (void)LightOn:(NSString *)action deviceno:(NSString *)deviceno termid:(NSString *)termid complete:(void (^)(BaseModel *))completeBlock;


/**
 *  投食
 */
- (void)Rollfood:(NSString *)Did deviceno:(NSString *)deviceno termid:(NSString *)termid complete:(void (^)(BaseModel *))completeBlock;


/**
 *  喂食
 */
- (void)Sendfood:(NSString *)deviceno  termid:(NSString *)termid complete:(void (^)(BaseModel *))completeBlock;

/**
 *  抓拍
 */
- (void)Takephoto:(NSString *)deviceno  termid:(NSString *)termid complete:(void (^)(BaseModel *))completeBlock;

@end
