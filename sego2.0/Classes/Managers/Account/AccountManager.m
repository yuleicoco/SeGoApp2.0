//
//  AccountManager.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AccountManager.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#define KEY_LOGIN_INFO     @"LoginInfo"

@implementation AccountManager

singleton_implementation(AccountManager)

- (instancetype)init{
    if (self = [super init]) {
        
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        self.loginModel = [defaults rm_customObjectForKey:KEY_LOGIN_INFO];
    }
    
    return self;
}

/**
 *  登录
 */
-(void)login:(LoginModel*) model{
    
    _loginModel = model;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults rm_setCustomObject:self.loginModel forKey:KEY_LOGIN_INFO];
}

/**
 *  登出
 */
-(void)logout{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.loginModel.mid = @"";
    
    [defaults rm_setCustomObject:self.loginModel forKey:KEY_LOGIN_INFO];
}

/**
 *  是否登录
 */
-(BOOL)isLogin{
    // return NO;
    return self.loginModel && self.loginModel.mid && ![self.loginModel.mid isEqualToString:@""];
}


@end
