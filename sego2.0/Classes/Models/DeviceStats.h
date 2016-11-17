//
//  DeviceStats.h
//  sego2.0
//
//  Created by yulei on 16/11/17.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <MojoDatabase/MojoDatabase.h>

@interface DeviceStats : JSONModel

//设备号
@property (nonatomic, copy) NSString<Optional> *deviceno;
//状态信息
@property (nonatomic, copy) NSString<Optional> *status;
// WIFI信号
@property (nonatomic, copy) NSString<Optional> * signal;



@end
