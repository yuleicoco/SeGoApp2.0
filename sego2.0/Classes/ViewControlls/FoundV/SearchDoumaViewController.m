//
//  SearchDoumaViewController.m
//  sego2.0
//
//  Created by czx on 16/11/27.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "SearchDoumaViewController.h"

@interface SearchDoumaViewController ()
@property (nonatomic,strong)UITextField * topTextfield;

@end

@implementation SearchDoumaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"搜索"];
    self.view.backgroundColor = GRAY_COLOR;

}
-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview).offset(5);
        make.right.equalTo(topView.superview).offset(-5);
        make.top.equalTo(topView.superview).offset(4);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView * foundImage = [[UIImageView alloc]init];
    foundImage.image = [UIImage imageNamed:@"find.png"];
    [topView addSubview:foundImage];
    [foundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.superview).offset(7);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(17);
        make.top.equalTo(foundImage.superview).offset(8);
    
    }];

    _topTextfield = [[UITextField alloc]init];
    _topTextfield.placeholder = @"请输入逗码";
    _topTextfield.font = [UIFont systemFontOfSize:18];
    _topTextfield.textColor = [UIColor blackColor];
    [topView addSubview:_topTextfield];
    [_topTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.mas_right).offset(9);
        make.centerY.equalTo(_topTextfield.superview.mas_centerY);
        make.width.mas_equalTo(300);
    }];
    
    UILabel * searechLabel = [[UILabel alloc]init];
    searechLabel.text = @"搜索";
    searechLabel.textColor = GREEN_COLOR;
    searechLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:searechLabel];
    [searechLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searechLabel.superview).offset(-7);
        make.centerY.equalTo(searechLabel.superview.mas_centerY);
        
    }];
    
    UIButton * searchBtn = [[UIButton alloc]init];
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searechLabel.superview).offset(-7);
        make.centerY.equalTo(searechLabel.superview.mas_centerY);
        make.width.mas_equalTo(100);
    }];

}

-(void)searchButtontouch{
    FuckLog(@"dad");

}









@end
