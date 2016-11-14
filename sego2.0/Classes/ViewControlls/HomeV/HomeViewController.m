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
    [[AFHttpClient sharedAFHttpClient]TestNet:@"13540691705" type:@"register" complete:^(BaseModel *model) {
        
        FuckLog(@"%@",model);
        
        
    }];
    
  
    
//    NSString * str =@"clientAction.do?method=json&classes=appinterface&common=check";
//     NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
//    [dic setValue:@"13540691705" forKey:@"phone"];
//    [dic setValue:@"register" forKey:@"type"];
//    
//    
//    [AFNetWorking postWithApi:str parameters:dic success:^(id json) {
//        
//        NSLog(@"%@",json);
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
