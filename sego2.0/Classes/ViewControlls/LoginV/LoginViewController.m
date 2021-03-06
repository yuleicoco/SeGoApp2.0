//
//  LoginViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.

//
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CompletionViewController.h"
#import "AFHttpClient+Account.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "PhoneTestViewController.h"

#import "AIncallViewController.h"
@interface LoginViewController ()
{
    //   CBPeripheralManager *peripheralManager;
    UITextField * _numberTextfield;
    UIButton * _loginBtn;

}
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UITextField * numberTextfield;
@property (nonatomic,strong)UITextField * passwordTextfield;
@end

@implementation LoginViewController

-(void)dadadwwsaodjwojdowd{
    PhoneTestViewController * tex = [[PhoneTestViewController alloc]init];
   // [self presentViewController:tex animated:NO completion:nil];
    [self.navigationController pushViewController:tex animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.navigationController.navigationBarHidden = YES;
   // self.view.backgroundColor = [UIColor blackColor];
    UIImageView * loginbackImage = [[UIImageView alloc]init];
    loginbackImage.image = [UIImage imageNamed:@"loginback.png"];
    [self.view addSubview:loginbackImage];
    [loginbackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(loginbackImage.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    UIButton * TextBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    TextBtn.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:TextBtn];
//    [TextBtn addTarget:self action:@selector(dadadwwsaodjwojdowd) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    
    UIImageView * numberImage = [[UIImageView alloc]init];
    numberImage.image = [UIImage imageNamed:@"numbertu.png"];
    [self.view addSubview:numberImage];
    [numberImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(13);
        make.top.equalTo(topView.mas_top).offset(18);
        make.bottom.equalTo(topView.mas_bottom).offset(-18);
        make.width.mas_equalTo(17);
    }];
    
    _numberTextfield = [[UITextField alloc]init];
    _numberTextfield.font = [UIFont systemFontOfSize:18];
    _numberTextfield.keyboardAppearance = UIKeyboardAppearanceDark;
    _numberTextfield.placeholder = NSLocalizedString(@"login_acc", nil);
    _numberTextfield.tintColor = [UIColor whiteColor];
    _numberTextfield.textColor = [UIColor whiteColor];
    _numberTextfield.keyboardType = UIKeyboardTypeNumberPad;
     [_numberTextfield setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_numberTextfield];
    [_numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberImage.mas_right).offset(14);
        make.centerY.equalTo(topView.mas_centerY).offset(1);
        make.right.equalTo(topView.mas_right);
        make.height.mas_equalTo(50);
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
        make.top.equalTo(topView.mas_bottom).offset(12);
        //一般情况下，使用mas_equalTo来处理基本数据类型的封装
       // make.height.equalTo(@55);
        make.height.mas_equalTo(55);
    }];
    
//    UIButton * showPassBtn = [[UIButton alloc]init];
//    [showPassBtn setImage:[UIImage imageNamed:@"loginbiyan.png"] forState:UIControlStateNormal];
//    [showPassBtn setImage:[UIImage imageNamed:@"loginyan.png"] forState:UIControlStateSelected];
//    [showPassBtn addTarget:self action:@selector(showpasswordButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:showPassBtn];
//    [showPassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(showPassBtn.superview).offset(-14);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(15);
//        make.centerY.equalTo(showPassBtn.superview);
//        
//        
//    }];
    

    UIImageView * passImage = [[UIImageView alloc]init];
    passImage.image = [UIImage imageNamed:@"passtu.png"];
    [self.view addSubview:passImage];
    [passImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView.mas_left).offset(13);
        make.top.equalTo(downView.mas_top).offset(18);
        make.bottom.equalTo(downView.mas_bottom).offset(-18);
        make.width.mas_equalTo(18);
        
    }];
    
    _passwordTextfield = [[UITextField alloc]init];
    _passwordTextfield.font = [UIFont systemFontOfSize:18];
    _passwordTextfield.placeholder = NSLocalizedString(@"login_ps", nil);
    _passwordTextfield.keyboardAppearance = UIKeyboardAppearanceDark;
    _passwordTextfield.tintColor = [UIColor whiteColor];
    _passwordTextfield.textColor = [UIColor whiteColor];
    _passwordTextfield.secureTextEntry = NO;
    [_passwordTextfield setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_passwordTextfield];
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passImage.mas_right).offset(14);
        make.centerY.equalTo(downView.mas_centerY).offset(1);
        //make.width.mas_equalTo(200);
        make.right.equalTo(downView.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    _loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = GREEN_COLOR;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [_loginBtn addTarget:self action:@selector(loginbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
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
    regiestLabel.text = NSLocalizedString(@"login_regist", nil);
    regiestLabel.textColor = [UIColor whiteColor];
    regiestLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:regiestLabel];
    [regiestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerLabel.mas_left).offset(-19);
       // make.top.equalTo(centerLabel.mas_top);
         make.top.equalTo(_loginBtn.mas_bottom).offset(30);
    }];
   
    UILabel * forgetPasswordlabel = [[UILabel alloc]init];
    forgetPasswordlabel.text =NSLocalizedString(@"login_forget", nil);
    forgetPasswordlabel.textColor = [UIColor whiteColor];
    forgetPasswordlabel.font = [UIFont systemFontOfSize:14];
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
    
    UILabel * disanfangLabel = [[UILabel alloc]init];
    disanfangLabel.text =NSLocalizedString(@"login_3rd", nil);
    disanfangLabel.textColor = [UIColor whiteColor];
    disanfangLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:disanfangLabel];
    [disanfangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginBtn.mas_centerX);
        make.top.equalTo(regiestBtn.mas_bottom).offset(55);
        
    }];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.superview).offset(17);
        make.right.equalTo(disanfangLabel.mas_left).offset(-6);
        make.centerY.equalTo(disanfangLabel.mas_centerY);
        make.height.mas_equalTo(1);
        
     }];
    
    UILabel * rightLabel = [[UILabel alloc]init];
    rightLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disanfangLabel.mas_right).offset(6);
        make.right.equalTo(rightLabel.superview).offset(-17);
        make.centerY.equalTo(disanfangLabel.mas_centerY);
        make.height.mas_equalTo(1);
        
    }];
    
    UIImageView * qqImage = [[UIImageView alloc]init];
    qqImage.image = [UIImage imageNamed:@"qq.png"];
    [self.view addSubview:qqImage];
    [qqImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqImage.superview).offset(133);
        make.top.equalTo(disanfangLabel.mas_bottom).offset(29);
        make.bottom.equalTo(qqImage.superview).offset(-35);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(28);
    }];
    
    UIImageView * weixinImage = [[UIImageView alloc]init];
    weixinImage.image = [UIImage imageNamed:@"weixin.png"];
    [self.view addSubview:weixinImage];
    [weixinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weixinImage.superview).offset(-133);
        make.bottom.equalTo(qqImage.superview).offset(-35);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(28);
    }];

    UIButton * qqBtn = [[UIButton alloc]init];
    qqBtn.backgroundColor = [UIColor clearColor];
    [qqBtn addTarget:self action:@selector(qqbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqImage.superview).offset(133);
//        make.top.equalTo(disanfangLabel.mas_bottom).offset(29);
        make.bottom.equalTo(qqImage.superview).offset(-35);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(26);
    }];
    
    UIButton * weixinBtn = [[UIButton alloc]init];
    weixinBtn.backgroundColor = [UIColor clearColor];
    [weixinBtn addTarget:self action:@selector(weixinbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weixinImage.superview).offset(-133);
        make.bottom.equalTo(qqImage.superview).offset(-35);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(28);

    }];
    
    
    

}

-(void)qqbuttonTouch{
    //qq登录
    FuckLog(@"11");
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
        
         
         if (state == SSDKResponseStateSuccess)
         {
             
             [self loginRepace:@"q" Secretkey:user.uid nick:user.nickname headportrait:user.icon];
             
             [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
             user.credential = nil;
             user.uid = nil;
            
         }
         else
         {
             NSLog(@"%@",error);
         }
         
     }];

}


- (void)loginRepace:(NSString *)type Secretkey:(NSString *)secretkey nick:(NSString *)nickname headportrait:(NSString *)headportrait
{
    
    [[AFHttpClient sharedAFHttpClient]Trlogin:nickname secretkey:secretkey headportrait:headportrait rtype:type complete:^(BaseModel * model) {
        // 会员基本信息
        FuckLog(@"==%@",model.retVal);
        if ([model.retCode isEqualToString:@"0000"]) {
            
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];
        }else{
            [[AppUtil appTopViewController]showHint:model.retDesc];
            
        }
        
        
        
    }];
    
    
    
    
}



-(void)weixinbuttonTouch{
    //微信登录
    FuckLog(@"22");

    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {

         if (state == SSDKResponseStateSuccess)
         {
            
             
            [self loginRepace:@"w" Secretkey:user.uid nick:user.nickname headportrait:user.icon];
              [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
             
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
    
    
}



-(void)loginbuttonTouch{
    if ([AppUtil isBlankString:_numberTextfield.text]) {
        [[AppUtil appTopViewController] showHint:NSLocalizedString(@"login_acc", nil)];
        return;
    }
    if ([AppUtil isBlankString:_passwordTextfield.text]) {
        [[AppUtil appTopViewController]showHint:NSLocalizedString(@"login_ps", nil)];
        return;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"login_ing", nil)];
    [[AFHttpClient sharedAFHttpClient]loginWithAccounynumber:_numberTextfield.text password:_passwordTextfield.text complete:^(BaseModel * model) {
        if (model) {
            if ([model.retCode isEqualToString:@"0000"]) {

                LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
                
                [[AccountManager sharedAccountManager]login:loginModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@YES];
            }else{
            [[AppUtil appTopViewController]showHint:model.retDesc];
            
            }
          
     
        }
         [self hideHud];
    }];
   
}


-(void)regiestButtonTouch{

 
//    RegistViewController * registVc = [[RegistViewController alloc]init];
//    //registVc.navigationController.navigationBar.tintColor = [UIColor redColor];
//    [self.navigationController pushViewController:registVc animated:NO];
    
    // [self getCurrentLanguage];
    //NSArray *languages = [NSLocale preferredLanguages];
  //  NSString *currentLanguage = [languages objectAtIndex:0];
//    NSLog( @"%@" , currentLanguage);
    //if ([currentLanguage isEqualToString:@"zh-Hans-CN"]) {

        RegistViewController * registVc = [[RegistViewController alloc]init];
            //registVc.navigationController.navigationBar.tintColor = [UIColor redColor];
        [self.navigationController pushViewController:registVc animated:NO];

   // }

    
}

-(void)forgetpasswordButtonTouch{
    FuckLog(@"heihei");
    CompletionViewController * commVc = [[CompletionViewController alloc]init];
    [self.navigationController pushViewController:commVc animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    // textField.keyboardType = UIKeyboardTypeDefault;
}

-(void)showpasswordButtonTouch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _passwordTextfield.secureTextEntry = NO;
    }else{
        _passwordTextfield.secureTextEntry = YES;
    }
    
    

}



@end
