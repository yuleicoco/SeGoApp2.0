//
//  UIView+TapBlocks.h
//  WaWaSchool
//
//  Created by ldp on 15/7/31.
//  Copyright (c) 2015年 Galaxy School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (TapBlocks)

-(void) addTapGestureWithTarget:(id)target action:(SEL)action;
-(void) addTapGestureWithBlock:(void(^)(void))aBlock;

-(void) removeTapGesture;

@end
