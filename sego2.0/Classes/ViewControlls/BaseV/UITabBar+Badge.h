//
//  UITabBar+Badge.h
//  petegg
//
//  Created by yulei on 16/4/10.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

/**
 *  显示小红点
 *
 */
- (void)showBadgeOnItemIndex:(int)index;
/**
 *  隐藏小红点
 *
 */
- (void)hideBadgeOnItemIndex:(int)index; 
@end
