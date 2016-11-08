//
//  UIButton+Blocks.m
//  WaWaSchool
//
//  Created by ldp on 15/7/31.
//  Copyright (c) 2015年 Galaxy School. All rights reserved.
//

#import "UIButton+Blocks.h"

@implementation UIButton (Blocks)

static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionButtonBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionButtonBlock block = (ActionButtonBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end
