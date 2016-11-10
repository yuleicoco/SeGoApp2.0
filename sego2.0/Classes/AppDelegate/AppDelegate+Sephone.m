//
//  AppDelegate+Sephone.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AppDelegate+Sephone.h"

@implementation AppDelegate (Sephone)
- (void)initSephoneVoip:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Sephone  单向无须做太多操作(考虑到以后)
    [[SephoneManager instance]	startSephoneCore];

    
}
@end
