//
//  HomeViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "HomeViewController.h"
#import "AFHttpClient+TestNetWork.h"
#import "AFNetWorking.h"
#import "RegistViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    
    
    /*
    [[AFHttpClient sharedAFHttpClient]TestNet:@"13540691705" type:@"register" complete:^(BaseModel *model) {
        
        FuckLog(@"%@",model);
        
    }];
    
     */
    UIButton * bb = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bb.backgroundColor = [UIColor redColor];
    [self.view addSubview:bb];
    [bb addTarget:self action:@selector(hahaha) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

-(void)hahaha{
    RegistViewController * vc = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];



}

@end
