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

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)



#ifndef WAWAPAGEHD
- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//这里写你需要的方向。看好了，别写错了
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#endif

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHud
{
    if ([self HUD]) {
        [self hideHud];
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = iPhone5?-100.f:-50.f;
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint
{
    if ([self HUD]) {
        [self hideHud];
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    HUD.yOffset = iPhone5?-100.f:-50.f;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showCustomHudInView:(UIView *)view hint:(NSString *)hint withImage:(NSString *)image
{
    if ([self HUD]) {
        [self hideHud];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = hint;
    hud.yOffset = iPhone5?-100.f:-50.f;
    [view addSubview:hud];
    [hud show:YES];
    [self setHUD:hud];
    [[self HUD] hide:YES afterDelay:2];
}

- (void)showSuccessHudWithHint:(NSString *)hint
{
    if ([self HUD]) {
        [self hideHud];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = hint;
    hud.yOffset = iPhone5?-100.f:-50.f;
    [self.view addSubview:hud];
    [hud show:YES];
    [self setHUD:hud];
    [hud hide:YES afterDelay:3];
}

- (void)showMessageWarring:(NSString *)message view:(UIView *)view
{
    
    if ([self HUD]) {
        [self hideHud];
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success.png"]];
    HUD.mode =MBProgressHUDModeCustomView;
    HUD.labelText = message;
    HUD.yOffset = iPhone5?-100.f:-50.f;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
    [HUD hide:YES afterDelay:4];
    
    
    
}


- (void)showFailureHudWithHint:(NSString *)hint
{
    if ([self HUD]) {
        [self hideHud];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failure.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = hint;
    hud.yOffset = iPhone5?-100.f:-50.f;
    [self.view addSubview:hud];
    [hud show:YES];
    [self setHUD:hud];
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint {

    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = NSLocalizedString(hint, nil);
    hud.yOffset = - SCREEN_HEIGHT/2+200; //IS_IPHONE_5?-100.f:-50.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint afterTime:(float) time{
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = NSLocalizedString(hint, nil);
    hud.yOffset = - SCREEN_HEIGHT/2+100; //IS_IPHONE_5?-100.f:-50.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}


- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = iPhone5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide:YES];
    [self setHUD:nil];
}



@end
