//
//  UIButton+Blocks.h
//  WaWaSchool
//
//  Created by ldp on 15/7/31.
//  Copyright (c) 2015年 Galaxy School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionButtonBlock)();

@interface UIButton (Blocks)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionButtonBlock)action;

@end
