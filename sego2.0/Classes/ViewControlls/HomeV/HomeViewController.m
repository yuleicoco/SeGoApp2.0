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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"",nil)];
    
    
    
    /*
    [[AFHttpClient sharedAFHttpClient]TestNet:@"13540691705" type:@"register" complete:^(BaseModel *model) {
        
        FuckLog(@"%@",model);
        
    }];
    
     */
  
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
