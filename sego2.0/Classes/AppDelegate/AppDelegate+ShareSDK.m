//
//  AppDelegate+ShareSDK.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"

@implementation AppDelegate (ShareSDK)

- (void)shareSDKApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ShareSDK registerApp:@"85d250655d35" activePlatforms:
     @[
       @(SSDKPlatformTypeWechat),
       @(SSDKPlatformTypeQQ)]onImport:^(SSDKPlatformType platformType) {
           
           switch (platformType)
           {
               case SSDKPlatformTypeWechat:
                   [ShareSDKConnector connectWeChat:[WXApi class]];
                   break;
               case SSDKPlatformTypeQQ:
                   [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                   
                   break;
                
               default:
                   break;
           }
       } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
           
           
           switch (platformType)
           {
            
               case SSDKPlatformTypeWechat:
                   [appInfo SSDKSetupWeChatByAppId:@"wx33a86d5926a50bdd"
                                         appSecret:@"6a3d1ca67089314014fc273f58ff960f"];
                   break;
                   
               case SSDKPlatformTypeQQ:
                   
                   
                   // 41E6DFD7
                   [appInfo SSDKSetupQQByAppId:@"1105649623"
                                        appKey:@"ib1rJ6NEUIon3k0o"
                                      authType:SSDKAuthTypeBoth];
                   break;
               default:
                   break;
           }        
       }];
    
}
@end
