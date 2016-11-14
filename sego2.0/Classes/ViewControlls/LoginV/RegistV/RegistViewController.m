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
    
    
    
    
    
    
    
    
    
    
    
}






@end
