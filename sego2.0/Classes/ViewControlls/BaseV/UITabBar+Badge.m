//
//  UITabBar+Badge.m
//  petegg
//
//  Created by yulei on 16/4/10.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 5.0

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 9, 9);
    [self addSubview:badgeView];

    
}

/**
 *  隐藏
 */
- (void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
    
}
/**
 *  移除
 *
 *  @param index tag值
 */
- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}
@end
