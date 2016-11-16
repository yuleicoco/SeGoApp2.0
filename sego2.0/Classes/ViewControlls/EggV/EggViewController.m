//
//  EggViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "EggViewController.h"
#import "InCallViewController.h"
#import "BindingViewController.h"


@interface EggViewController ()
{
    UIImageView * ImageBack;
    BindingViewController * bindVC;
    
    
    
    
}

@end

@implementation EggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    // sephone
  //  [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
   // self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
}



// sephone的通知
- (void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
    
}

// 注册消息处理
- (void)registrationUpdate:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    switch (state) {
            
        case SephoneRegistrationNone:
            
            NSLog(@"======开始");
            break;
        case SephoneRegistrationProgress:
            NSLog(@"=====注册进行");
            break;
        case SephoneRegistrationOk:
            
            NSLog(@"=======成功");
            break;
        case SephoneRegistrationCleared:
            break;
        case SephoneRegistrationFailed:
            NSLog(@"========OK 以外都是失败");
            break;
            
        default:
            break;
    }
    
}


// 通话状态处理
- (void)callUpdate:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    
    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功
            InCallViewController *   _incallVC =[[InCallViewController alloc]initWithNibName:@"InCallViewController" bundle:nil];
            [_incallVC setCall:call];
            [self presentViewController:_incallVC animated:YES completion:nil];
            break;
        }
            
        case SephoneCallStreamsRunning: {
            break;
        }
        case SephoneCallUpdatedByRemote: {
            break;
        }
            
        default:
            break;
    }
}



// 初始化界面
- (void)setupView
{
    [super  setupView];
    
    [self NodeviceImageUI];
    
    
    
}


// 数据
- (void)setupData
{
    [super setupData];
    
    
}



// 没有绑定设备

- (void)NodeviceImageUI
{
    
    
 
    
    
    
    
    
   
    // 背景图
    ImageBack = [[UIImageView alloc]init];
    [ImageBack setImage:[UIImage imageNamed:@"egg_nodevcie"]];
    [self.view addSubview:ImageBack];
    [ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(375, 603));
        make.top.left.right.equalTo(@0);
    
        
    }];
    // 300 150
    // 添加按钮
    UIButton * btnAdd =[[UIButton alloc]init];
    [btnAdd setImage:[UIImage imageNamed:@"egg_add"] forState:UIControlStateNormal];
    [self.view addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(btn_add:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAdd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(120);
        make.size.mas_equalTo(CGSizeMake(90, 60));
        make.left.equalTo(@150);
    }];
    
    
    
}

- (void)btn_add:(UIButton *)sender
{
    
    // 绑定设备界面
    bindVC  =[[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindVC animated:NO];
    
    
    
    
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
