//
//  LoginViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.

//
#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor redColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(logingin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)logingin:(UIButton *)sender{

     [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];


}







@end
