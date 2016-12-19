//
//  AppDelegate+Launcher.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AppDelegate+Launcher.h"
#import "PopStartView.h"
#import "AFHttpClient+Account.h"
#import "EggViewController.h"
@interface AppDelegate()<GetScrollVDelegate>

@end

@implementation AppDelegate (Launcher)


/**
 *  启动逻辑入口
 *
 */
- (void)launcherApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       GREEN_COLOR,NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:NotificationLoginStateChange object:nil];
    
     [self checkLogin];
    
    
    
}

- (void)checkLogin{
    if ([AccountManager sharedAccountManager].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@NO];
    }
}

-(void)loginStateChange:(NSNotification *)notification{
    BOOL loginSuccess = [notification.object boolValue];

    if (loginSuccess) {
        [self enterMainTabVC];
    }else{
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        if (![[userdefaults objectForKey:@"STARTFLAG"] isEqualToString:@"1"]) {//第一次启动软件
            [self.window makeKeyAndVisible];
            [userdefaults setObject:@"1" forKey:@"STARTFLAG"];
            [userdefaults synchronize];
            PopStartView *popStartV = [[PopStartView alloc]initWithFrame:self.window.bounds];
            popStartV.delegate = self;
            popStartV.ParentView = self.window;
            [self.window addSubview:popStartV];
            
        }else {//不是第一次启动软件
            [self enterLoginVC];
            
        }
        
        
        
  //   [self enterLoginVC];
    
    
    
    }
    

}
//代理函数
- (void)getScrollV:(NSString *)popScroll
{
    
    [self enterLoginVC];
    
    
}

- (void)enterMainTabVC{
    
    if (self.loginVC) {
        self.loginVC = nil;
    }
    
    self.mainTabVC = [[MainTabViewController alloc]init];
    
    self.window.rootViewController = self.mainTabVC;
    
    [self.window makeKeyAndVisible];
    [self quermember];
    
}
-(void)quermember{
    [[AFHttpClient sharedAFHttpClient]queryByIdMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
        [[AccountManager sharedAccountManager]login:loginModel];
        
    }];


}




/**
 *  进入登陆界面
 */
- (void)enterLoginVC{
    
    if (self.mainTabVC) {
        self.mainTabVC = nil;
    }
    
    self.loginVC = [[LoginViewController alloc]init];
    
    UINavigationController * loginNaVc = [[UINavigationController alloc]initWithRootViewController:self.loginVC];
    self.window.rootViewController = loginNaVc;
    
    [self.window makeKeyAndVisible];
}


/**
 *  粘贴快捷
 *  直接跳到别人的视频开启界面逗宠
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    // 判断登录
    
    
    // 判断是否是自己
    
    
    
    if ([pboard.string length]>4  &&  [[pboard.string substringWithRange:NSMakeRange(0, 4)]  isEqualToString:@"赛果分享"]) {
        NSString * strPLAYcode = [pboard.string substringWithRange:NSMakeRange(5,14 )];
        [self checkPlayCode:strPLAYcode];
        pboard.string  =@"";
    }else
    {
        // 正常情况
        
        
    }
}

- (void)checkPlayCode:(NSString *)playStr
{
    
 
    
    
  [[AFHttpClient sharedAFHttpClient]CheckCode:playStr complete:^(BaseModel * model) {
      

        FuckLog(@"%@",model);
        if ([model.retVal[@"mid"] isEqualToString:[AccountManager sharedAccountManager].loginModel.mid]) {
            // 自己
            self.mainTabVC.selectedIndex =2;
            
        }else
        {
            
            if ([model.retVal[@"status"] isEqualToString:@"0"]) {
                // 失效
                 [self.window.rootViewController showSuccessHudWithHint:@"此逗码已经失效"];
            }else
            {
                
                EggViewController * eggVC = [[EggViewController alloc]init];
                eggVC.CodeMid = model.retVal[@"mid"];
                eggVC.isOther  = YES;
                eggVC.tsumNum = [model.retVal[@"tsnum"] integerValue];
                [self.mainTabVC pushViewController:eggVC];
            }
            
        }
    
        
    }];
    
    

    
}


@end
