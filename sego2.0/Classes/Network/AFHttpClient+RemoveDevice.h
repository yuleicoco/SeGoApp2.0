//
//  AFHttpClient+RemoveDevice.h
//  sego2.0
//
//  Created by yulei on 16/11/19.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (RemoveDevice)

/**
 *  解除绑定
 */
-(void)RemoveDevice:(NSString *)mid   complete:(void (^)(BaseModel *))completeBlock;

@end
