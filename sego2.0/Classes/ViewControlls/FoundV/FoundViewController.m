//
//  FoundViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "FoundViewController.h"
#import "SearchDoumaViewController.h"
#import "DouyidouViewController.h"

@interface FoundViewController ()

@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"发现"];
    self.view.backgroundColor = GRAY_COLOR;
}

-(void)setupView{
    [super setupView];
//    UIButton * topBtn = [[UIButton alloc]init];
//    topBtn.backgroundColor = [UIColor whiteColor];
//    topBtn.layer.cornerRadius = 5;
//    [topBtn addTarget:self action:@selector(topbuttontouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:topBtn];
//    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topBtn.superview).offset(4);
//        make.left.equalTo(topBtn.superview).offset(5);
//        make.right.equalTo(topBtn.superview).offset(-5);
//        make.height.mas_equalTo(35);
//    }];
//    
//    UIImageView * foundImage = [[UIImageView alloc]init];
//    foundImage.image = [UIImage imageNamed:@"find.png"];
//    [topBtn addSubview:foundImage];
//    [foundImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(foundImage.superview).offset(7);
//        make.width.mas_equalTo(18);
//        make.height.mas_equalTo(17);
//        make.top.equalTo(foundImage.superview).offset(8);
//        
//        
//    }];
//    
//    UILabel * placeholderLabel = [[UILabel alloc]init];
//    placeholderLabel.text = @"请输入逗码";
//    placeholderLabel.textColor = RGB(153, 153, 153);
//    placeholderLabel.font = [UIFont systemFontOfSize:18];
//    [topBtn addSubview:placeholderLabel];
//    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(foundImage.mas_right).offset(8);
//        make.centerY.equalTo(placeholderLabel.superview.mas_centerY);
//        
//    }];
    
    UIButton * whiteBtn = [[UIButton alloc]init];
    whiteBtn.backgroundColor = [UIColor whiteColor];
    [whiteBtn addTarget:self action:@selector(whtiebuttontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whiteBtn];
    [whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBtn.superview);
        make.right.equalTo(whiteBtn.superview);
        make.top.equalTo(whiteBtn.superview);
        make.height.mas_equalTo(60);
        
    }];
    
    UIImageView * douImage = [[UIImageView alloc]init];
    douImage.image = [UIImage imageNamed:@"douyidou.png"];
    [whiteBtn addSubview:douImage];
    [douImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(douImage.superview).offset(12);
        make.top.equalTo(douImage.superview).offset(10);
        make.bottom.equalTo(douImage.superview).offset(-10);
        make.width.mas_equalTo(40);

    }];
    
    UILabel * douLabel = [[UILabel alloc]init];
    douLabel.text = @"逗一逗";
    douLabel.textColor = [UIColor blackColor];
    douLabel.font = [UIFont systemFontOfSize:18];
    [whiteBtn addSubview:douLabel];
    [douLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(douLabel.superview.mas_centerY);
        make.left.equalTo(douImage.mas_right).offset(8);
    
    }];
    
    UIImageView * rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:@"jiantou.png"];
    [whiteBtn addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImage.superview).offset(-12);
        make.top.equalTo(rightImage.superview).offset(22.5);
        make.bottom.equalTo(rightImage.superview).offset(-22.5);
        make.width.mas_equalTo(9);
        
    }];
    
  
}
-(void)topbuttontouch{
    SearchDoumaViewController * searchVc = [[SearchDoumaViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:NO];
    
    

}
-(void)whtiebuttontouch{
    DouyidouViewController * douVc = [[DouyidouViewController alloc]init];
    [self.navigationController pushViewController:douVc animated:NO];


}






@end
