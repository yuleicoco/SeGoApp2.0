//
//  MainTabViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

{
    
    
}

//广场
@property (nonatomic, strong) UINavigationController* navHomeVC;
//附近
@property (nonatomic, strong) UINavigationController* navNearVC;
//不倒蛋
@property (strong, nonatomic) UINavigationController  *navEggVC;
//好友
@property (strong, nonatomic) UINavigationController  *navFriendVC;
//个人中心
@property (strong, nonatomic) UINavigationController  *navPersonalVC;


@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
   
}

//子视图初始
- (void)setupSubviews
{
    self.tabBar.backgroundColor=[UIColor whiteColor];
    
    self.viewControllers = @[
                             self.navHomeVC,
                             self.navNearVC,
                             self.navEggVC,
                             self.navFriendVC,
                             self.navPersonalVC
                             ];
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.4;
    self.tabBar.layer.shadowRadius = 2;

    
}

- (UINavigationController *)navSquareVC
{
    if (!_navHomeVC) {
        
    }
    
    return _navHomeVC;
    
    
    
}

- (UINavigationController *)navNearVC
{
    if (!_navNearVC) {
        
    }
    return  _navNearVC;
    
    
}


- (UINavigationController * )navEggVC
{
    
    if (!_navEggVC) {
       
    }
    
    return _navEggVC;
    
    
}

- (UINavigationController *)navFriendVC
{
    if (_navFriendVC) {
        
    }
    
    return _navFriendVC;
    
}


- (UINavigationController *)navPersonalVC
{
    if (_navPersonalVC) {
        
        
        
    }
    return _navPersonalVC;
    
    
    
}




- (void)pushViewController:(UIViewController*)viewController {
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        [((UINavigationController*)self.selectedViewController) pushViewController:viewController animated:YES];
        
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
