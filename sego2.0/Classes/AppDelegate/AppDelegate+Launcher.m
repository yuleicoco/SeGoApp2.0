//
//  AppDelegate+Launcher.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AppDelegate+Launcher.h"

@implementation AppDelegate (Launcher)


/**
 *  启动逻辑入口
 *
 */
- (void)launcherApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    self.mainTabVC =[[MainTabViewController alloc]init];
    self.window.rootViewController = self.mainTabVC;
    [self.window makeKeyWindow];
    
    
    
    
}

@end
