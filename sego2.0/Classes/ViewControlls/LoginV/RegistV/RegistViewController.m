//
//  RegistViewController.m
//  sego2.0
//
//  Created by czx on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (nonatomic,strong)UIButton * vercationBtn;
@property (nonatomic,strong)UIButton * registBtn;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"注 册"];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
  
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
    

 
    
    _vercationBtn = [[UIButton alloc]init];
    _vercationBtn.backgroundColor = GREEN_COLOR;
    _vercationBtn.layer.cornerRadius = 5;
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
    
    _registBtn = [[UIButton alloc]init];
    _registBtn.backgroundColor = GREEN_COLOR;
    _registBtn.layer.cornerRadius = 5;
    [self.view addSubview:_registBtn];
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(surepasswordView.mas_bottom).offset(25);
        make.left.equalTo(passwordView.mas_left);
        make.right.equalTo(passwordView.mas_right);
        make.height.mas_equalTo(55);
    
    }];
    
    UILabel * downLabel = [[UILabel alloc]init];
    downLabel.text = @"点击""注册""按钮，带白您已阅读并同意";
    downLabel.textColor = [UIColor whiteColor];
    downLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downLabel.superview).offset(20);
       // make.top.equalTo(_registBtn.mas_bottom).offset(250);
        make.bottom.equalTo(downLabel.superview).offset(-23);
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
}






@end
