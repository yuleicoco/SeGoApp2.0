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

@property (nonatomic,strong)NSArray * nameArray;
@property (nonatomic,strong)UIButton * bigBtn;
@property (nonatomic,strong)UIView * centerwhteView;
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
    [headBtn addTarget:self action:@selector(headbtuttonTouch) forControlEvents:UIControlEventTouchUpInside];
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
    self.tableView.scrollEnabled = NO;
    
    
    

}
- (void)loadDataSourceWithPage:(int)page {


}


-(void)setupData{
    [super setupData];
    _nameArray = [[NSArray alloc]init];
    _nameArray = @[@"帐号",@"昵称",@"性别",@"家族",@"生日",@"签名"];
    
    

}

-(void)headbtuttonTouch{
   // FuckLog([AccountManager sharedAccountManager].loginModel.pet_sex);


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
    cell.nameLabel.text = _nameArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.accountnumber;
    }
    if (indexPath.row == 1) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    }
    if (indexPath.row == 2) {
        if ([[AccountManager sharedAccountManager].loginModel.pet_sex isEqualToString:@"公"]) {
            cell.rightLabel.text = @"公";
        }else{
            cell.rightLabel.text = @"母";
        }
    }
    if (indexPath.row == 3) {
        if ([[AccountManager sharedAccountManager].loginModel.pet_race isEqualToString:@"汪"]) {
            cell.rightLabel.text = @"汪星人";
        }else{
            cell.rightLabel.text = @"喵星人";
        }
    }
    if (indexPath.row == 4) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.pet_birthday;
    }
    if (indexPath.row == 5) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.signature;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // InformationTableViewCell * cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        [self exchangename];
    }
    if (indexPath.row == 2) {
        [self exchangesex];
    }
    if (indexPath.row == 3) {
        [self exchangerace];
    }
    if (indexPath.row == 4) {
        [self exchangebrithday];
    }
    if (indexPath.row == 5) {
        [self exchangsigner];
    }
    
}

-(void)exchangename{
    // 通过数据控制界面
    //[AccountManager sharedAccountManager].loginModel.nickname = @"dadada";
    //[self.tableView reloadData];
    FuckLog(@"修改昵称");
    [self bigButtonOpen:1];
}


-(void)exchangesex{
    FuckLog(@"修改性别");
    [self bigButtonOpen:2];
}

-(void)exchangerace{
    FuckLog(@"修改属性");
}

-(void)exchangebrithday{
    FuckLog(@"修改生日");

}

-(void)exchangsigner{
    FuckLog(@"修改签名");
}



-(void)bigButtonOpen:(NSInteger)i{
    _bigBtn = [[UIButton alloc]init];
    _bigBtn.backgroundColor = [UIColor blackColor];
    _bigBtn.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_bigBtn];
    [_bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigBtn.superview);
        make.bottom.equalTo(_bigBtn.superview);
        make.left.equalTo(_bigBtn.superview);
        make.right.equalTo(_bigBtn.superview);
    }];
    [_bigBtn addTarget:self action:@selector(bigbuttonTouch) forControlEvents:UIControlEventTouchUpInside];

    _centerwhteView = [[UIView alloc]init];
    _centerwhteView.backgroundColor = [UIColor whiteColor];
    _centerwhteView.layer.cornerRadius = 5;
    [[UIApplication sharedApplication].keyWindow addSubview:_centerwhteView];
    [_centerwhteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerwhteView.superview).offset(60);
        make.right.equalTo(_centerwhteView.superview).offset(-60);
        make.top.equalTo(_centerwhteView.superview).offset(245);
        make.height.mas_equalTo(162);
    }];
    if (i == 1) {
        [self exchangnameview];
    }
    if (i == 2) {
        
    }
    
}
-(void)bigbuttonTouch{
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
}

-(void)exchangnameview{
    //_centerwhteView.backgroundColor = [UIColor redColor];
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"修改昵称";
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    nameLabel.font = [UIFont systemFontOfSize:17.5];
    [_centerwhteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLabel.superview.mas_centerX);
        make.top.equalTo(nameLabel.superview).offset(14);
        
    }];
    
    UITextField * exchangeTextfield = [[UITextField alloc]init];
    exchangeTextfield.placeholder = @"请输入昵称";
    exchangeTextfield.textColor = [UIColor blackColor];
    exchangeTextfield.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:exchangeTextfield];
    [exchangeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(exchangeTextfield.superview.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).offset(26);
        
        
    }];
    
    UILabel * henglineLabel = [[UILabel alloc]init];
    henglineLabel.backgroundColor =[UIColor grayColor];
    [_centerwhteView addSubview:henglineLabel];
    [henglineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(henglineLabel.superview);
        make.right.equalTo(henglineLabel.superview);
        make.top.equalTo(exchangeTextfield.mas_bottom).offset(28);
        make.height.mas_equalTo(0.5);
    }];

    UILabel * shuLabel = [[UILabel alloc]init];
    shuLabel.backgroundColor = [UIColor grayColor];
    [_centerwhteView addSubview:shuLabel];
    [shuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(henglineLabel.mas_bottom);
        make.bottom.equalTo(shuLabel.superview);
        make.centerX.equalTo(shuLabel.superview.mas_centerX);
        make.width.mas_equalTo(0.5);
        
    }];

    UILabel * danceLabel = [[UILabel alloc]init];
    danceLabel.text = @"取消";
    danceLabel.textColor = [UIColor blackColor];
    danceLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:danceLabel];
    [danceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shuLabel.mas_left).offset(-48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UILabel * sureLabel = [[UILabel alloc]init];
    sureLabel.text = @"确定";
    sureLabel.textColor = [UIColor blackColor];
    sureLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right).offset(48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UIButton * danceBtn = [[UIButton alloc]init];
    danceBtn.backgroundColor = [UIColor clearColor];
    [danceBtn addTarget:self action:@selector(namedancebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:danceBtn];
    [danceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(danceBtn.superview);
    // make.top.equalTo(exchangeTextfield.mas_bottom).offset(28.5);
        make.right.equalTo(shuLabel.mas_left);
        make.bottom.equalTo(danceBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn addTarget:self action:@selector(namesurebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right);
        make.right.equalTo(sureBtn.superview);
        make.bottom.equalTo(sureBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
}

-(void)namedancebuttonTouch{
    FuckLog(@"不改名字了");
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
}

-(void)namesurebuttonTouch{
    FuckLog(@"还是改个名字吧");
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;

}










@end
