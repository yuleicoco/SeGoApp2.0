/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface UIViewController (HUD)

- (MBProgressHUD *)HUD;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)showHud;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showCustomHudInView:(UIView *)view hint:(NSString *)hint withImage:(NSString *)image;

- (void)showSuccessHudWithHint:(NSString *)hint;

- (void)showFailureHudWithHint:(NSString *)hint;
- (void)showHint:(NSString *)hint afterTime:(float) time;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
/**
 *  余磊专用
 */
- (void)showMessageWarring:(NSString *)message view:(UIView *)view;


@end
