//
//  AboutViewController.m
//  sego2.0
//
//  Created by czx on 16/12/10.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AboutViewController.h"
#import "AgreementViewController.h"
#import "IntroduceViewController.h"

#import "SuggestViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"me_aobout", nil)];
    self.view.backgroundColor = GRAY_COLOR;
}

-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.superview);
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.height.mas_equalTo(210);
    
    }];
    
    UIImageView * aboutImage = [[UIImageView alloc]init];
    aboutImage.image = [UIImage imageNamed:@"aboutlogo.png"];
    [topView addSubview:aboutImage];
    [aboutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutImage.superview).offset(28);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(111);
       // make.left.equalTo(aboutImage.superview).offset(137);
        make.centerX.equalTo(aboutImage.superview.mas_centerX);
        
    }];
    
    UILabel * banbenLabel = [[UILabel alloc]init];
    banbenLabel.text = @"SEGO  V2.0";
    banbenLabel.textColor = [UIColor blackColor];
    banbenLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:banbenLabel];
    [banbenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(banbenLabel.superview.mas_centerX);
        make.bottom.equalTo(banbenLabel.superview).offset(-34);
        
    }];
    
    
    UIView * downView = [[UIView alloc]init];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.left.equalTo(downView.superview);
        make.right.equalTo(downView.superview);
        make.height.mas_equalTo(165);

    }];
    
    
    UILabel * chanpinLabel = [[UILabel alloc]init];
    chanpinLabel.text = @"产品简介";
    chanpinLabel.textColor = [UIColor blackColor];
    chanpinLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:chanpinLabel];
    [chanpinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(chanpinLabel.superview.mas_centerX);
        make.top.equalTo(chanpinLabel.superview).offset(19);

    }];
    
    UILabel * lineLabel1 = [[UILabel alloc]init];
    lineLabel1.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [downView addSubview:lineLabel1];
    [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel1.superview).offset(12);
        make.right.equalTo(lineLabel1.superview).offset(-12);
        make.top.equalTo(lineLabel1.superview).offset(55);
        make.height.mas_equalTo(1);
    
    }];
    
    UILabel * yijianLabel = [[UILabel alloc]init];
    yijianLabel.text = @"意见反馈";
    yijianLabel.textColor = [UIColor blackColor];
    yijianLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:yijianLabel];
    [yijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(chanpinLabel.superview.mas_centerX);
        make.top.equalTo(lineLabel1.mas_bottom).offset(17);
        
    }];
    
    
    UILabel * lineLabel2 = [[UILabel alloc]init];
    lineLabel2.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [downView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel2.superview).offset(12);
        make.right.equalTo(lineLabel2.superview).offset(-12);
        make.top.equalTo(lineLabel2.superview).offset(110);
        make.height.mas_equalTo(1);
        
    }];
    
    UILabel * zhucexieyiLabel = [[UILabel alloc]init];
    zhucexieyiLabel.textColor = [UIColor blackColor];
    zhucexieyiLabel.text = @"注册协议";
    zhucexieyiLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:zhucexieyiLabel];
    [zhucexieyiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(chanpinLabel.superview.mas_centerX);
        make.top.equalTo(lineLabel2.mas_bottom).offset(17);
        
    }];
    
    UIButton * firstBtn = [[UIButton alloc]init];
    firstBtn.backgroundColor = [UIColor clearColor];
    [firstBtn addTarget:self action:@selector(firstButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:firstBtn];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBtn.superview);
        make.left.equalTo(firstBtn.superview);
        make.right.equalTo(firstBtn.superview);
        make.height.mas_equalTo(55);
    
    }];
    
    UIButton * seconedBtn = [[UIButton alloc]init];
    seconedBtn.backgroundColor = [UIColor clearColor];
    [seconedBtn addTarget:self action:@selector(secoendButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:seconedBtn];
    [seconedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBtn.mas_bottom);
        make.left.equalTo(seconedBtn.superview);
        make.right.equalTo(seconedBtn.superview);
        make.height.mas_equalTo(55);
    
    }];
    
    UIButton * lastBtn = [[UIButton alloc]init];
    lastBtn.backgroundColor = [UIColor clearColor];
    [lastBtn addTarget:self action:@selector(lastButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seconedBtn.mas_bottom);
        make.left.equalTo(lastBtn.superview);
        make.right.equalTo(lastBtn.superview);
        make.height.mas_equalTo(55);
    }];
    
    
    
}

-(void)firstButtonTouch{
    FuckLog(@"产品简介");
    IntroduceViewController * introVc = [[IntroduceViewController alloc]init];
    [self.navigationController pushViewController:introVc animated:NO];

}

-(void)secoendButtonTouch{
    FuckLog(@"意见反馈");
    SuggestViewController * suggerVc = [[SuggestViewController alloc]init];
    [self.navigationController pushViewController:suggerVc animated:NO];
}

-(void)lastButtonTouch{
    FuckLog(@"注册协议");
    AgreementViewController * agreVc = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreVc animated:NO];
    
}

@end
