//
//  AppUtil.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil

//赛果2.0测试接口
static NSString * getServer3 =@"http://180.97.80.227:8082/";


+ (NSString *)getServerSego3
{
    return getServer3;
    
}




+ (UIViewController *)appTopViewController{
    UIViewController *appRootVC = ApplicationDelegate.window.rootViewController;
    
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return true;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return true;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return true;
    }
    return false;
}

@end
