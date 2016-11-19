//
//  AFHttpClient+VideoQuiltChoose.h
//  sego2.0
//
//  Created by yulei on 16/11/18.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (VideoQuiltChoose)
/**
 *  视频画质选择
 */

-(void)VideoQuiltChoose:(NSString *)mid vtype:(NSString *)vtype   complete:(void (^)(BaseModel *))completeBlock;

@end
