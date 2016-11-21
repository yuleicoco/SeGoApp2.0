//
//  InCallViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/21.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InCallViewControllerr.h"

@interface InCallViewControllerr ()

@end

@implementation InCallViewControllerr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //横竖屏
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
