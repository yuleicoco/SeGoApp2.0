//
//  AppDelegate.h
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabViewController.h"
#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainTabViewController* mainTabVC;
@property (nonatomic, strong) LoginViewController *loginVC;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

