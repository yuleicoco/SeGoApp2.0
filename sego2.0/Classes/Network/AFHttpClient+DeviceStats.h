//
//  AFHttpClient+DeviceStats.h
//  sego2.0
//
//  Created by yulei on 16/11/17.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (DeviceStats)

/**
 *  查询设备状态
 */

-(void)DeviceStats:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock;

@end
