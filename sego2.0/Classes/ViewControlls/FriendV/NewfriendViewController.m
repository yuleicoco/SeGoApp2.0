//
//  NewfriendViewController.m
//  sego2.0
//
//  Created by czx on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "NewfriendViewController.h"
#import "SearchFriendViewController.h"

@interface NewfriendViewController ()

@end

@implementation NewfriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"新的朋友"];
    self.view.backgroundColor = GRAY_COLOR;
    
}

-(void)setupView{
    [super setupView];
    UIButton * topBtn = [[UIButton alloc]init];
    topBtn.backgroundColor = [UIColor whiteColor];
    topBtn.layer.cornerRadius = 5;
    [topBtn addTarget:self action:@selector(topbuttontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBtn.superview).offset(68);
        make.left.equalTo(topBtn.superview).offset(5);
        make.right.equalTo(topBtn.superview).offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView * foundImage = [[UIImageView alloc]init];
    foundImage.image = [UIImage imageNamed:@"find.png"];
    [topBtn addSubview:foundImage];
    [foundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.superview).offset(7);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(17);
        make.top.equalTo(foundImage.superview).offset(8);
        
        
    }];
    
    UILabel * placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.text = @"手机号/昵称/设备号";
    placeholderLabel.textColor = RGB(153, 153, 153);
    placeholderLabel.font = [UIFont systemFontOfSize:18];
    [topBtn addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.mas_right).offset(8);
        make.centerY.equalTo(placeholderLabel.superview.mas_centerY);
        
    }];
    
}
-(void)topbuttontouch{
    
    SearchFriendViewController * search = [[SearchFriendViewController alloc]init];
   // [self presentViewController:search animated:YES completion:nil];
    [self.navigationController pushViewController:search animated:NO];


}


@end
