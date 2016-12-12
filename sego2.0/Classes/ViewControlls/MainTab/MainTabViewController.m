//
//  MainTabViewController.m
//  petegg
//
//  Created by ldp on 16/3/14.
//  Copyright © 2016年 ldp. All rights reserved.
//

#import "MainTabViewController.h"

#import "HomeViewController.h"
#import "FoundViewController.h"
#import "EggViewController.h"
#import "FriendViewController.h"
#import "MeViewController.h"
@interface MainTabViewController()
{
    
  
    
}

//home
@property (nonatomic, strong) UINavigationController* navHomeVC;
//寻找
@property (nonatomic, strong) UINavigationController* navNearVC;
//不倒蛋
@property (strong, nonatomic) UINavigationController  *navEggVC;
//好友
@property (strong, nonatomic) UINavigationController  *navFriendVC;
//个人中心
@property (strong, nonatomic) UINavigationController  *navPersonalVC;

@end

@implementation MainTabViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
  
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}



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

//广场
- (UINavigationController *)navHomeVC{
    if (!_navHomeVC) {
        
        HomeViewController* vc = [[HomeViewController alloc] init];
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabSquare", nil)
                                      image:[[UIImage imageNamed:@"tab_squar"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_squar_dian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navHomeVC = [[UINavigationController alloc]initWithRootViewController:vc];
        
        
    }
    
    return _navHomeVC;
}

//附近
- (UINavigationController *)navNearVC{
    if (!_navNearVC) {
        
       FoundViewController * vc = [[FoundViewController alloc] init];
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabNear", nil)
                                      image:[[UIImage imageNamed:@"tab_faxian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_faxian_dian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navNearVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navNearVC;
}

//不倒蛋
- (UINavigationController *)navEggVC{
    if (!_navEggVC) {
        
        EggViewController* vc = [[EggViewController alloc] init];
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabEgg", nil)
                                      image:[[UIImage imageNamed:@"tab_budaodan"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_budaodan_dian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navEggVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navEggVC;
}




//榜单
- (UINavigationController *)navFriendVC{
    if (!_navFriendVC) {
        
        FriendViewController* vc = [[FriendViewController alloc] init];
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabRank", nil)
                                      image:[[UIImage imageNamed:@"tab_bangdan"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_bangdan_dian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _navFriendVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navFriendVC;
}

//个人中心
- (UINavigationController *)navPersonalVC{
    
    if (!_navPersonalVC) {
        
        MeViewController* vc = [[MeViewController alloc] init];
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabPersonal", nil)
                                      image:[[UIImage imageNamed:@"tab_my"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_my_dian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _navPersonalVC = [[UINavigationController alloc]initWithRootViewController:vc];
        
    }
    
    return _navPersonalVC;
}




- (void)pushViewController:(UIViewController*)viewController {
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        [((UINavigationController*)self.selectedViewController) pushViewController:viewController animated:YES];
        
    }
    
}


#pragma mark ----- 横竖屏切换base












@end
