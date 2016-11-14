//
//  LoginViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.

//
#import "LoginViewController.h"
#import "RegistViewController.h"


@interface LoginViewController ()
@property (nonatomic,strong)UIButton * loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(logingin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    //第一个框
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = [UIColor whiteColor].CGColor;
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(bigView.superview).offset(50);
       //  make.edges.equalTo(bigView.superview).insets(UIEdgeInsetsMake(231, 18, 30, 18));
        make.left.equalTo(topView.superview).offset(18);
        make.right.equalTo(topView.superview).offset(-18);
        make.top.equalTo(topView.superview).offset(231);
        make.height.mas_equalTo(55);
    }];
    
    //第二个框
    UIView * downView = [[UIView alloc]init];
    downView.backgroundColor = [UIColor clearColor];
    downView.layer.borderWidth = 1;
    downView.layer.borderColor = [UIColor whiteColor].CGColor;
    downView.layer.cornerRadius = 5;
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView.superview).offset(18);
        make.right.equalTo(downView.superview).offset(-18);
        make.top.equalTo(downView.superview).offset(298);
        //一般情况下，使用mas_equalTo来处理基本数据类型的封装
       // make.height.equalTo(@55);
        make.height.mas_equalTo(55);
    }];
    
    _loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = GREEN_COLOR;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:_loginBtn];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loginBtn.superview).offset(18);
        make.right.equalTo(_loginBtn.superview).offset(-18);
        //根据上一个视图来定位置，上一个视图的mas_ (top,bottom.left.right)
        make.top.equalTo(downView.mas_bottom).offset(25);
        make.height.mas_equalTo(55);
    }];
    
    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(32);
        //make.center.equalTo(_loginBtn.mas_centerX).offset(0);
        make.centerX.equalTo(_loginBtn.mas_centerX);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(16);
    }];
    
    UILabel * regiestLabel = [[UILabel alloc]init];
    regiestLabel.text = @"新用户注册";
    regiestLabel.textColor = [UIColor whiteColor];
    regiestLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:regiestLabel];
    [regiestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerLabel.mas_left).offset(-19);
       // make.top.equalTo(centerLabel.mas_top);
         make.top.equalTo(_loginBtn.mas_bottom).offset(30);
    }];
   
    
    
    UILabel * forgetPasswordlabel = [[UILabel alloc]init];
    forgetPasswordlabel.text = @"忘记密码?";
    forgetPasswordlabel.textColor = [UIColor whiteColor];
    forgetPasswordlabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:forgetPasswordlabel];
    [forgetPasswordlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLabel.mas_right).offset(19);
         make.top.equalTo(_loginBtn.mas_bottom).offset(30);
    
    }];
    
    
    UIButton * regiestBtn = [[UIButton alloc]init];
    [self.view addSubview:regiestBtn];
    [regiestBtn addTarget:self action:@selector(regiestButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [regiestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerLabel.mas_left).offset(-19);
        make.top.equalTo(_loginBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(100);
    }];
    
    UIButton * forgetpasswordBtn = [[UIButton alloc]init];
    [self.view addSubview:forgetpasswordBtn];
    [forgetpasswordBtn addTarget:self action:@selector(forgetpasswordButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [forgetpasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLabel.mas_right).offset(19);
        make.top.equalTo(_loginBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(100);
    }];
    
    
    
    
    

    
}

-(void)regiestButtonTouch{

    FuckLog(@"haha");
    RegistViewController * registVc = [[RegistViewController alloc]init];
    //registVc.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.navigationController pushViewController:registVc animated:NO];
    
}

-(void)forgetpasswordButtonTouch{
    FuckLog(@"heihei");

}


-(void)logingin:(UIButton *)sender{

     [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}





@end
