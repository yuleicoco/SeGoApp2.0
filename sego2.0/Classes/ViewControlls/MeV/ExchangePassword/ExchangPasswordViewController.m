//
//  ExchangPasswordViewController.m
//  sego2.0
//
//  Created by czx on 16/12/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ExchangPasswordViewController.h"
#import "AFHttpClient+Account.h"


@interface ExchangPasswordViewController ()
@property (nonatomic,strong)UIButton * vercationBtn;
@property (nonatomic,strong)UIButton * registBtn;
@property (nonatomic,strong)UITextField * numberTextfield;
@property (nonatomic,strong)UITextField * vercationTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@property (nonatomic,strong)UITextField * surepasswordTextfield;

@end

@implementation ExchangPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"修改密码"];
    self.view.backgroundColor = GRAY_COLOR;
    
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
    numberLabel.text = @"  原密码:";
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.font = [UIFont systemFontOfSize:18];
    [numberView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberView.mas_centerY);
        make.left.equalTo(numberLabel.superview).offset(16);
        
    }];
    _numberTextfield = [[UITextField alloc]init];
    _numberTextfield.font = [UIFont systemFontOfSize:18];
    _numberTextfield.placeholder = @"请输入原密码";
    _numberTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_numberTextfield];
    [_numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right).offset(13);
        make.centerY.equalTo(numberView.mas_centerY).offset(1);
        
    }];
    

    
    UIView * passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.cornerRadius = 5;
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberView.mas_left);
        make.right.equalTo(numberView.mas_right);
        make.top.equalTo(numberView.mas_bottom).offset(8);
        make.height.mas_equalTo(55);
    }];
    
    UILabel * passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"新密码:";
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.mas_centerY);
        make.right.equalTo(numberLabel.mas_right);
        
    }];
    
    _passwordTextfield = [[UITextField alloc]init];
    _passwordTextfield.font = [UIFont systemFontOfSize:18];
    _passwordTextfield.placeholder = @"请输入新密码";
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
    [_registBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_registBtn addTarget:self action:@selector(regiestButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registBtn];
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(surepasswordView.mas_bottom).offset(25);
        make.left.equalTo(passwordView.mas_left);
        make.right.equalTo(passwordView.mas_right);
        make.height.mas_equalTo(55);
        
    }];


}

-(void)regiestButtontouch{
    if ([AppUtil isBlankString:_numberTextfield.text]) {
         [[AppUtil appTopViewController]showHint:@"请输入原密码"];
        return;
    }
    if (![[AccountManager sharedAccountManager].loginModel.password isEqualToString:_numberTextfield.text]) {
        [[AppUtil appTopViewController]showHint:@"原密码输入错误"];
        return;
    
    }
    
    if ([AppUtil isBlankString:_passwordTextfield.text]) {
          [[AppUtil appTopViewController]showHint:@"请输入新密码"];
        return;
    }
    if ([AppUtil isBlankString:_surepasswordTextfield.text]) {
          [[AppUtil appTopViewController]showHint:@"请再次输入密码"];
        return;
    }
  
    if (![_passwordTextfield.text isEqualToString:_surepasswordTextfield.text]) {
        [[AppUtil appTopViewController]showHint:@"两次输入密码不一致"];
        return;
    
    }
    
    [[AFHttpClient sharedAFHttpClient]exchangePasswordWithMid:[AccountManager sharedAccountManager].loginModel.mid password:_passwordTextfield.text complete:^(BaseModel *model) {
        if (model) {
               [[AppUtil appTopViewController]showHint:model.retDesc];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        
    }];

    
    
    

}










@end
