//
//  RegistViewController.m
//  sego2.0
//
//  Created by czx on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "RegistViewController.h"
#import "GuideViewController.h"


@interface RegistViewController ()
@property (nonatomic,strong)UIButton * vercationBtn;
@property (nonatomic,strong)UIButton * registBtn;
@property (nonatomic,strong)UITextField * numberTextfield;
@property (nonatomic,strong)UITextField * vercationTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@property (nonatomic,strong)UITextField * surepasswordTextfield;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"注 册"];
    self.view.backgroundColor = RGB(236, 237, 241);
    
  
}
-(void)setupView{
    [super setupView];
    
    UIView * numberView = [[UIView alloc]init];
    numberView.backgroundColor = [UIColor whiteColor];
    numberView.layer.cornerRadius = 5;
    [self.view addSubview:numberView];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberView.superview).offset(17);
        make.right.equalTo(numberView.superview).offset(-17);
        make.top.equalTo(numberView.superview).offset(8);
        make.height.mas_equalTo(55);
        
    }];
 
    UILabel * numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"手机号码:";
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.font = [UIFont systemFontOfSize:18];
    [numberView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberView.mas_centerY);
        make.left.equalTo(numberLabel.superview).offset(13);
        
    }];
    _numberTextfield = [[UITextField alloc]init];
    _numberTextfield.font = [UIFont systemFontOfSize:18];
    _numberTextfield.placeholder = @"请输入手机号码";
    _numberTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_numberTextfield];
    [_numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right).offset(13);
        make.centerY.equalTo(numberView.mas_centerY).offset(1);
        
    }];
    
    
    _vercationBtn = [[UIButton alloc]init];
    _vercationBtn.backgroundColor = GREEN_COLOR;
    _vercationBtn.layer.cornerRadius = 5;
    
    [_vercationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vercationBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_vercationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    [self.view addSubview:_vercationBtn];
    [_vercationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_vercationBtn.superview).offset(-17);
        make.top.equalTo(numberView.mas_bottom).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(55);
    }];
    
    UIView * verificationView = [[UIView alloc]init];
    verificationView.backgroundColor = [UIColor whiteColor];
    verificationView.layer.cornerRadius = 5;
    [self.view addSubview:verificationView];
    [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberView.mas_left);
        make.right.equalTo(_vercationBtn.mas_left).offset(-10);
        make.top.equalTo(numberView.mas_bottom).offset(8);
        make.height.mas_equalTo(55);
    }];
    
    UILabel * verificationLabel = [[UILabel alloc]init];
    verificationLabel.text = @"验证码:";
    verificationLabel.textColor = [UIColor blackColor];
    verificationLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:verificationLabel];
    [verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationView.mas_centerY);
        make.right.equalTo(numberLabel.mas_right);
        
    }];
    
    _vercationTextfield = [[UITextField alloc]init];
    _vercationTextfield.font = [UIFont systemFontOfSize:18];
    _vercationTextfield.placeholder = @"请输入验证码";
    _vercationTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_vercationTextfield];
    [_vercationTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationLabel.mas_right).offset(13);
        make.centerY.equalTo(verificationView.mas_centerY).offset(1);
    }];
    
    
    
    
    
    
    UIView * passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.cornerRadius = 5;
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberView.mas_left);
        make.right.equalTo(numberView.mas_right);
        make.top.equalTo(verificationView.mas_bottom).offset(8);
        make.height.mas_equalTo(55);
    }];

    UILabel * passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"密码:";
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.mas_centerY);
        make.right.equalTo(numberLabel.mas_right);
        
    }];
    
    _passwordTextfield = [[UITextField alloc]init];
    _passwordTextfield.font = [UIFont systemFontOfSize:18];
    _passwordTextfield.placeholder = @"请输入密码";
    _passwordTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_passwordTextfield];
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.mas_right).offset(13);
        make.centerY.equalTo(passwordView.mas_centerY).offset(1);
    }];
    
    
    
    UIView * surepasswordView = [[UIView alloc]init];
    surepasswordView.backgroundColor = [UIColor whiteColor];
    surepasswordView.layer.cornerRadius = 5;
    [self.view addSubview:surepasswordView];
    [surepasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left);
        make.right.equalTo(passwordView.mas_right);
        make.top.equalTo(passwordView.mas_bottom).offset(8);
        make.height.mas_equalTo(55);
        
    }];
    
    UILabel * surepasswordLabel = [[UILabel alloc]init];
    surepasswordLabel.text = @"确认密码:";
    surepasswordLabel.textColor = [UIColor blackColor];
    surepasswordLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:surepasswordLabel];
    [surepasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(surepasswordView.mas_centerY);
        make.right.equalTo(numberLabel.mas_right);
    
    }];
    
    _surepasswordTextfield = [[UITextField alloc]init];
    _surepasswordTextfield.font = [UIFont systemFontOfSize:18];
    _surepasswordTextfield.placeholder = @"请再次输入密码";
    _surepasswordTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_surepasswordTextfield];
    [_surepasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surepasswordLabel.mas_right).offset(13);
        make.centerY.equalTo(surepasswordView.mas_centerY).offset(1);
    
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    _registBtn = [[UIButton alloc]init];
    _registBtn.backgroundColor = GREEN_COLOR;
    _registBtn.layer.cornerRadius = 5;
    
    [_registBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:_registBtn];
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(surepasswordView.mas_bottom).offset(25);
        make.left.equalTo(passwordView.mas_left);
        make.right.equalTo(passwordView.mas_right);
        make.height.mas_equalTo(55);
    
    }];
    
    UILabel * downLabel = [[UILabel alloc]init];
    downLabel.text = @"点击'注册'按钮，带白您已阅读并同意";
    downLabel.textColor = UIColorFromHex(333333);
    downLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downLabel.superview).offset(35);
       // make.top.equalTo(_registBtn.mas_bottom).offset(250);
        make.bottom.equalTo(downLabel.superview).offset(-23);
        
    }];
    
    UILabel * xieyiLabel = [[UILabel alloc]init];
    xieyiLabel.text = @"注册协议";
    xieyiLabel.textColor = [UIColor redColor];
    xieyiLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:xieyiLabel];
    [xieyiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xieyiLabel.superview).offset(-35);
        make.bottom.equalTo(downLabel.mas_bottom);
    }];
    
    UIButton * xieyibtn = [[UIButton alloc]init];
    xieyibtn.backgroundColor = [UIColor clearColor];
    [xieyibtn addTarget:self action:@selector(xieyibuttontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyibtn];
    [xieyibtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xieyiLabel.superview).offset(-35);
        make.bottom.equalTo(downLabel.mas_bottom);
    }];
    
    
    
    
    
    
    
    
    
}

-(void)xieyibuttontouch{
    FuckLog(@"hehhhh");
    GuideViewController * guideVc = [[GuideViewController alloc]init];
    [self.navigationController pushViewController:guideVc animated:NO];


}




@end
