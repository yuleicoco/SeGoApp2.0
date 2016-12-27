//
//  RegistViewController.m
//  sego2.0
//
//  Created by czx on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "RegistViewController.h"
#import "AgreementViewController.h"
#import "AFHttpClient+Account.h"

@interface RegistViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * vercationBtn;
@property (nonatomic,strong)UIButton * registBtn;
@property (nonatomic,strong)UITextField * numberTextfield;
@property (nonatomic,strong)UITextField * vercationTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@property (nonatomic,strong)UITextField * surepasswordTextfield;

@property (nonatomic,copy)NSString * achieveString;
@property (nonatomic,copy)NSString * vercationNumber;

@property (nonatomic,strong)UIButton * firstShowBtn;
@property (nonatomic,strong)UIButton * secoendBtn;

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
        make.width.mas_equalTo(80);
    }];
    _numberTextfield = [[UITextField alloc]init];
    _numberTextfield.font = [UIFont systemFontOfSize:18];
    _numberTextfield.placeholder = @"请输入手机号码";
    _numberTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_numberTextfield];
    [_numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right).offset(13);
        make.centerY.equalTo(numberView.mas_centerY).offset(1);
        make.right.equalTo(numberView.mas_right);
        make.height.mas_equalTo(50);
        
    }];

    _vercationBtn = [[UIButton alloc]init];
    _vercationBtn.backgroundColor = GREEN_COLOR;
    _vercationBtn.layer.cornerRadius = 5;
    
    [_vercationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vercationBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_vercationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_vercationBtn addTarget:self action:@selector(vercationbuttontouch) forControlEvents:UIControlEventTouchUpInside];
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
    [verificationView addSubview:verificationLabel];
    [verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationView.mas_centerY);
       // make.left.equalTo(verificationLabel.superview.mas_left).offset(30);
        make.right.equalTo(numberLabel.mas_right);
        
    }];
    
    _vercationTextfield = [[UITextField alloc]init];
    _vercationTextfield.font = [UIFont systemFontOfSize:18];
    _vercationTextfield.placeholder = @"请输入验证码";
    _vercationTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _vercationTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_vercationTextfield];
    [_vercationTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationLabel.mas_right).offset(13);
        make.centerY.equalTo(verificationView.mas_centerY).offset(1);
        make.right.equalTo(verificationView.mas_right);
        make.height.mas_equalTo(50);
        
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
//
//    _firstShowBtn = [[UIButton alloc]init];
//    [_firstShowBtn setImage:[UIImage imageNamed:@"registbiyan.png"] forState:UIControlStateNormal];
//    [_firstShowBtn setImage:[UIImage imageNamed:@"registyan.png"] forState:UIControlStateSelected];
//    [_firstShowBtn addTarget:self action:@selector(firstButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [passwordView addSubview:_firstShowBtn];
//    [_firstShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_firstShowBtn.superview).offset(-14);
//        make.centerY.equalTo(_firstShowBtn.superview.mas_centerY);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(15);
//    
//    }];
    

    
    
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
    _passwordTextfield.secureTextEntry = NO;
    _passwordTextfield.textColor = [UIColor blackColor];
    [self.view addSubview:_passwordTextfield];
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.mas_right).offset(13);
        make.centerY.equalTo(passwordView.mas_centerY).offset(1);
        make.right.equalTo(passwordView.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    
//    
//    UIView * surepasswordView = [[UIView alloc]init];
//    surepasswordView.backgroundColor = [UIColor whiteColor];
//    surepasswordView.layer.cornerRadius = 5;
//    [self.view addSubview:surepasswordView];
//    [surepasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordView.mas_left);
//        make.right.equalTo(passwordView.mas_right);
//        make.top.equalTo(passwordView.mas_bottom).offset(8);
//        make.height.mas_equalTo(55);
//        
//    }];
//    
//    _secoendBtn = [[UIButton alloc]init];
//    [_secoendBtn setImage:[UIImage imageNamed:@"registbiyan.png"] forState:UIControlStateNormal];
//    [_secoendBtn setImage:[UIImage imageNamed:@"registyan.png"] forState:UIControlStateSelected];
//    [_secoendBtn addTarget:self action:@selector(secoendButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [surepasswordView addSubview:_secoendBtn];
//    [_secoendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_secoendBtn.superview).offset(-14);
//        make.centerY.equalTo(_secoendBtn.superview.mas_centerY);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(15);
//        
//    }];
//    
//    
//    UILabel * surepasswordLabel = [[UILabel alloc]init];
//    surepasswordLabel.text = @"确认密码:";
//    surepasswordLabel.textColor = [UIColor blackColor];
//    surepasswordLabel.font = [UIFont systemFontOfSize:18];
//    [self.view addSubview:surepasswordLabel];
//    [surepasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(surepasswordView.mas_centerY);
//        make.right.equalTo(numberLabel.mas_right);
//    
//    }];
//    
//    _surepasswordTextfield = [[UITextField alloc]init];
//    _surepasswordTextfield.font = [UIFont systemFontOfSize:18];
//    _surepasswordTextfield.placeholder = @"请再次输入密码";
//    _surepasswordTextfield.secureTextEntry = YES;
//    _surepasswordTextfield.textColor = [UIColor blackColor];
//    [self.view addSubview:_surepasswordTextfield];
//    [_surepasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(surepasswordLabel.mas_right).offset(13);
//        make.centerY.equalTo(surepasswordView.mas_centerY).offset(1);
//        make.width.mas_equalTo(230);
//        
//    }];
    
    _registBtn = [[UIButton alloc]init];
    _registBtn.backgroundColor = GREEN_COLOR;
    _registBtn.layer.cornerRadius = 5;
    [_registBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_registBtn addTarget:self action:@selector(regiestButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registBtn];
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(25);
        make.left.equalTo(passwordView.mas_left);
        make.right.equalTo(passwordView.mas_right);
        make.height.mas_equalTo(55);
    
    }];
    
    UILabel * downLabel = [[UILabel alloc]init];
    downLabel.text = @"点击'注册'按钮，代表您已阅读并同意";
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

-(void)regiestButtontouch{
    if ([AppUtil isBlankString:_numberTextfield.text]) {
          [[AppUtil appTopViewController] showHint:@"请输入账号"];
        return;
    }
    if (![AppUtil isValidateMobile:_numberTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"请输入正确格式的手机号码"];
        return;
    }
    if ([AppUtil isBlankString:_vercationTextfield.text]) {
          [[AppUtil appTopViewController] showHint:@"请输入验证码"];
        return;
    }
    if ([AppUtil isBlankString:_passwordTextfield.text]) {
          [[AppUtil appTopViewController] showHint:@"请输入密码"];
        return;
    }
    
    if (![_numberTextfield.text isEqualToString:_achieveString]) {
        [[AppUtil appTopViewController] showHint:@"请输入正确的手机号码"];
        return;
    }
    
    if (![_vercationTextfield.text isEqualToString:_vercationNumber]) {
           [[AppUtil appTopViewController] showHint:@"请输入正确的验证码"];
        return;
    }

    
    
    
     [self showHudInView:self.view hint:@"正在注册..."];
    [[AFHttpClient sharedAFHttpClient]regiestWithPhone:_numberTextfield.text password:_passwordTextfield.text complete:^(BaseModel *model) {
         [self hideHud];
         [[AppUtil appTopViewController] showHint:model.retDesc];
        if (model) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        
    }];
    
    
    
    
}
-(void)xieyibuttontouch{
    FuckLog(@"hehhhh");
    AgreementViewController * agreVc = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreVc animated:NO];
}

-(void)vercationbuttontouch{
    if ([AppUtil isBlankString:_numberTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"请输入账号"];
        return;
    }
    if (![AppUtil isValidateMobile:_numberTextfield.text]) {
        [[AppUtil appTopViewController] showHint:@"请输入正确格式的手机号码"];
        return;
    }
    
    [self provied];
}

-(void)provied{
    FuckLog(@"dada");
   
    
    [[AFHttpClient sharedAFHttpClient]getCheckWithPhone:_numberTextfield.text type:@"register" complete:^(BaseModel *model) {
      
        if ([model.retCode isEqualToString:@"0000"]) {
            _achieveString = model.totalrecords;
            _vercationNumber = model.content;
             [self timeout];
        }
      [[AppUtil appTopViewController] showHint:model.retDesc];
    }];
    
}
- (void)timeout
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);     dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                  _vercationBtn.titleLabel.font = [UIFont systemFontOfSize:18  ];
                [_vercationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _vercationBtn.userInteractionEnabled = YES;
                _vercationBtn.backgroundColor = GREEN_COLOR;
                   [_vercationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
        }else{
            // int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                 _vercationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [_vercationBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                  [_vercationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [UIView commitAnimations];
               
                _vercationBtn.userInteractionEnabled = NO;
                _vercationBtn.backgroundColor = [UIColor whiteColor];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

-(void)firstButtonTouch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _secoendBtn.selected = YES;
        _passwordTextfield.secureTextEntry = NO;
        _surepasswordTextfield.secureTextEntry = NO;
    }else{
        _secoendBtn.selected = NO;
        _passwordTextfield.secureTextEntry = YES;
        _surepasswordTextfield.secureTextEntry = YES;
        
    }
}

-(void)secoendButtonTouch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _firstShowBtn.selected = YES;
        _passwordTextfield.secureTextEntry = NO;
        _surepasswordTextfield.secureTextEntry = NO;
    }else{
        _firstShowBtn.selected = NO;
        _passwordTextfield.secureTextEntry = YES;
        _surepasswordTextfield.secureTextEntry = YES;
    }
}




@end
