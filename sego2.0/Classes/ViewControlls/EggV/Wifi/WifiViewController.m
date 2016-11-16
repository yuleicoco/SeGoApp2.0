//
//  WifiViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "WifiViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface WifiViewController ()

{
    UITextField *  wifiPsTF ;
    UITableView * tabWIFI;
    
    
    
}
@end

@implementation WifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"wifiTitle",nil)];
    
    
}

- (void)setupView
{
    [super setupView];
    
    UIView * devNum =[UIView new];
    UIView * wifiView =[UIView new];
    UIView * wifiCode =[UIView new];
    UIView * methodView =[UIView new];
    methodView.backgroundColor = [UIColor whiteColor];
  //  methodView.layer.cornerRadius =4;
    methodView.layer.borderWidth =1;
    methodView.layer.borderColor =GRAY_COLOR.CGColor;
    
    devNum.backgroundColor = [UIColor whiteColor];
    wifiView.backgroundColor = [UIColor whiteColor];
    wifiCode.backgroundColor = [UIColor whiteColor];
    devNum.layer.cornerRadius =4;
    devNum.layer.borderWidth =0.4;
    devNum.layer.borderColor =GRAY_COLOR.CGColor;
    wifiView.layer.cornerRadius =4;
    wifiView.layer.borderWidth =0.4;
    wifiView.layer.borderColor = GRAY_COLOR.CGColor;
    wifiCode.layer.cornerRadius =4;
    wifiCode.layer.borderWidth =0.4;
    wifiCode.layer.borderColor = GRAY_COLOR.CGColor;
    [self.view addSubview:wifiCode];
    [self.view addSubview:devNum];
    [self.view addSubview:wifiView];
    [self.view addSubview:methodView];
    
    [devNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(wifiView);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(8);
    }];
    
    [wifiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(66);
        
    }];
    
    [wifiCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(124);
        
    }];
    
    UIButton*  btnBind =[UIButton new];
    btnBind.layer.cornerRadius = 4;
    btnBind.backgroundColor = GRAY_COLOR;
    [btnBind setTitle:@"确定" forState:UIControlStateNormal];
    [btnBind addTarget:self action:@selector(Surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBind];
    [btnBind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@55);
        make.top.equalTo(wifiCode.mas_bottom).offset(75);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.width.equalTo(wifiCode);
        
    }];
    
    
    UILabel * labelMess=[UILabel new];
    labelMess.text =@"加密方式";
    labelMess.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:labelMess];
    
    [labelMess mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wifiCode.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(29);
        
    }];
    
    
    
    
    
    UILabel * deveLB= [UILabel new];
    UILabel * wifiLB =[UILabel new];
    UILabel * wifips =[UILabel new];
    
    deveLB.text =@"设备号:";
    deveLB.font = [UIFont systemFontOfSize:18];
    wifiLB.text =@"WIFI名称:";
    wifiLB.font =[UIFont systemFontOfSize:18];
    
    wifips.text =@"WIFI密码:";
    wifips.font =[UIFont systemFontOfSize:18];
    
    
    [devNum addSubview:deveLB];
    [wifiView addSubview:wifiLB];
    [wifiCode addSubview:wifips];
    
    
    
    [deveLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devNum.mas_left).with.offset(26);
        make.centerY.equalTo(devNum.mas_centerY);
        
        
        
    }];
    
    [wifiLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiView).offset(12);
        make.centerY.equalTo(wifiView.mas_centerY);
        
    }];
    
    [wifips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiCode).offset(12);
        make.centerY.equalTo(wifiCode.mas_centerY);
        
    }];
    
    
    
    UITextField *  deviceTF =[UITextField new];
    UITextField *  incodeTF =[UITextField new];
    wifiPsTF =[UITextField new];
    deviceTF.text =@"13540691705";
    incodeTF.text =[self fetchSSIDInfo];
    wifiPsTF.text =@"";
//    incodeTF.secureTextEntry = TRUE;
//    deviceTF.enabled = NO;
    
    deviceTF.borderStyle = UITextBorderStyleNone;
    incodeTF.borderStyle =UITextBorderStyleNone;
    wifiPsTF.borderStyle =UITextBorderStyleNone;
    
    deviceTF.font = [UIFont systemFontOfSize:18];
    incodeTF.font = [UIFont systemFontOfSize:18];
    wifiPsTF.font =[UIFont systemFontOfSize:18];
    [devNum addSubview:deviceTF];
    [wifiView addSubview:incodeTF];
    [wifiCode addSubview:wifiPsTF];
    
    [deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deveLB.mas_right).offset(13);
        make.centerY.equalTo(devNum.mas_centerY);
        
    }];
    
    [incodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wifiLB.mas_right).with.offset(13);
        make.centerY.equalTo(wifiView.mas_centerY);
        
    }];
    
    
    [wifiPsTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wifips.mas_right).with.offset(13);
        make.centerY.equalTo(wifiCode.mas_centerY);
        
    }];
    
    
    
    
    [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(labelMess.mas_right).offset(147);
        make.top.equalTo(wifiCode.mas_bottom).offset(24);
//        make.bottom.equalTo(btnBind.mas_top).offset(-36);
        make.height.mas_equalTo(20);
        
        make.right.equalTo(self.view).offset(-17);
        
        
        
    }];
    
    
    UIButton * btn =[UIButton new];
    [btn setTitle:@"WAP/WAP2" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:15];
    [methodView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(methodView).offset(5);
        make.height.equalTo(methodView);
        make.top.equalTo(methodView.mas_top).offset(1);
        
        
        
    }];
    
    UIImageView * imaeV = [UIImageView new];
    [imaeV setImage:[UIImage imageNamed:@"xiala"]];
    [methodView addSubview:imaeV];
    
    
    [imaeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(methodView.mas_right).offset(-12);
        make.height.equalTo(methodView);
        make.top.equalTo(methodView.mas_top).offset(1);

        
    }];
    
    
    
    if ([AppUtil isBlankString:wifiPsTF.text]) {
        
         btnBind.enabled = FALSE;
         return;
    }else
    {
        
        btnBind.enabled = TRUE;
        btnBind.backgroundColor = GREEN_COLOR;
        
    }
    
    
    
    
}


/**
 *  获取当前连接WIFI的名称
 *
 *  @return
 */
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    if (info == nil) {
        return @"";
    }
    
    return [info objectForKey:@"SSID"];
}


- (void)Surebtn:(UIButton *)sender
{
    
    
    //链接wifi
   
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
