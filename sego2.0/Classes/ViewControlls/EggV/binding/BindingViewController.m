//
//  BindingViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/15.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()<ShowDelegate>
{
    // 输入框
    UITextField * deviceTF;
    UITextField * incodeTF;
    
    // 绑定按钮
    UIButton * btnBind;
    ShowWarView * ShowView;
    
    
    
    
}

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabBinding_title",nil)];
    
    
    
    
}



- (void)setupView
{
    
    [super setupView];
    
    UIView * devNum =[UIView new];
    UIView * inCode =[UIView new];
    devNum.backgroundColor = [UIColor whiteColor];
    inCode.backgroundColor = [UIColor whiteColor];
    devNum.layer.cornerRadius =4;
    devNum.layer.borderWidth =0.4;
    devNum.layer.borderColor =GRAY_COLOR.CGColor;
    inCode.layer.cornerRadius =4;
    inCode.layer.borderWidth =0.4;
    inCode.layer.borderColor = GRAY_COLOR.CGColor;
    [self.view addSubview:devNum];
    [self.view addSubview:inCode];
    
    [devNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(inCode);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(8);
    }];
    
    [inCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(66);

    }];

    
    btnBind =[UIButton new];
    btnBind.layer.cornerRadius = 4;
    btnBind.backgroundColor = GRAY_COLOR;
    [btnBind setTitle:@"绑定设备" forState:UIControlStateNormal];
    [btnBind addTarget:self action:@selector(BindTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBind];
    [btnBind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@55);
        make.top.equalTo(inCode).offset(75);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.width.equalTo(inCode);
        
    }];
    
    UILabel * deveLB= [UILabel new];
    UILabel * incoLB =[UILabel new];
    deveLB.text =@"设备号:";
    deveLB.font = [UIFont systemFontOfSize:18];
    incoLB.text =@"接入码:";
    incoLB.font =[UIFont systemFontOfSize:18];
    
    [devNum addSubview:deveLB];
    [inCode addSubview:incoLB];
    
    [deveLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devNum.mas_left).with.offset(12);
        make.centerY.equalTo(devNum.mas_centerY);
        
        
        
    }];
    
    [incoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inCode).offset(12);
        make.centerY.equalTo(inCode.mas_centerY);
        
    }];
    
    
    deviceTF =[UITextField new];
    incodeTF =[UITextField new];
    deviceTF.text =@"13540691705";
    incodeTF.text =@"125800";
    
    deviceTF.borderStyle = UITextBorderStyleNone;
    incodeTF.borderStyle =UITextBorderStyleNone;
    deviceTF.font = [UIFont systemFontOfSize:18];
    incodeTF.font = [UIFont systemFontOfSize:18];
    [devNum addSubview:deviceTF];
    [inCode addSubview:incodeTF];
    
    [deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deveLB.mas_right).offset(13);
        make.centerY.equalTo(devNum.mas_centerY);

    }];
    
    [incodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.equalTo(incoLB.mas_right).with.offset(13);
         make.centerY.equalTo(inCode.mas_centerY);

    }];
    
    
    
    
    
    
    
   
    
}




//绑定设备按钮

- (void)BindTouch:(UIButton *)sender
{
    
    
    // hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在搜索设备请稍等...";
    

    
    
}



- (void)wariring
{
      [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    ShowView = [[ShowWarView alloc] initWithFrame:CGRectMake(0, 0,0 ,0)];
    ShowView.delegate = self;
    [self.view addSubview:ShowView];
    [ShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@255);
        make.height.equalTo(@162);
        make.left.equalTo(self.view.mas_left).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(btnBind.mas_bottom).offset(43);
        
    }];
    
    

    
    
    
}

// Delegate
- (void)CancelMethod
{
    [ShowView removeFromSuperview];
    
    
    
}
- (void)TryAgainMethod
{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
