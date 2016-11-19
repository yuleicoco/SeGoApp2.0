//
//  InformationViewController.m
//  sego2.0
//
//  Created by czx on 16/11/19.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"

static NSString * cellId = @"InformationCellId";
@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:[AccountManager sharedAccountManager].loginModel.nickname];
}

-(void)setupView{
    [super setupView];
    self.view.backgroundColor = GRAY_COLOR;
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview).offset(12);
        make.height.mas_offset(80);
    }];
    
    UILabel * headLabel = [[UILabel alloc]init];
    headLabel.text = @"头像";
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(headLabel.superview).offset(12);

    }];
    
    UIButton * headBtn = [[UIButton alloc]init];
    //headBtn.backgroundColor = [UIColor blackColor];
    [headBtn.layer setMasksToBounds:YES];
    headBtn.layer.cornerRadius = 33;
    UIImage * btnImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AccountManager sharedAccountManager].loginModel.headportrait]]];
    [headBtn setImage:btnImage forState:UIControlStateNormal];
    [self.view addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headBtn.superview).offset(-12);
        make.top.equalTo(topView.mas_top).offset(7);
        make.bottom.equalTo(topView.mas_bottom).offset(-7);
        make.width.mas_offset(66);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.height.mas_equalTo(330);
        
    }];
    
  //  self .tableView.frame =  CGRectMake(0, 0, self.view.width, self.view.height);

     [self.tableView registerClass:[InformationTableViewCell class] forCellReuseIdentifier:cellId];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  // [self initRefreshView];
    self.tableView.scrollEnabled = NO;
    
    
    

}
- (void)loadDataSourceWithPage:(int)page {


}


-(void)setupData{
    [super setupData];

}
#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       InformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    return cell;

}

@end
