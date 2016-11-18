//
//  MeViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setNavTitle:@"个人中心"];
}
-(void)setupView{
    [super setupView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIImageView * topImage = [[UIImageView alloc]init];
    topImage.backgroundColor= [UIColor redColor];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.superview);
        make.left.equalTo(topImage.superview);
        make.right.equalTo(topImage.superview);
        make.height.mas_equalTo(172);

    }];
    
    UIButton * headBtn = [[UIButton alloc]init];
    headBtn.backgroundColor = [UIColor blackColor];
    headBtn.layer.cornerRadius = 40;
    [self.view addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBtn.superview).offset(14);
        make.left.equalTo(headBtn.superview).offset(147);
        make.right.equalTo(headBtn.superview).offset(-147);
        make.height.mas_equalTo(80);
        
    }];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"陈大侠";
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headBtn.mas_centerX);
        make.top.equalTo(headBtn.mas_bottom).offset(9);
        
    }];

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linelabel];
    [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLabel.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).offset(16);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(topImage.mas_bottom).offset(-18);
    
    }];
    
    UILabel * wenzhangNum = [[UILabel alloc]init];
    wenzhangNum.textColor = [UIColor whiteColor];
    wenzhangNum.font = [UIFont systemFontOfSize:15];
    wenzhangNum.text = @"10";
    [self.view addSubview:wenzhangNum];
    [wenzhangNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(linelabel.mas_left).offset(-16);
        make.centerY.equalTo(linelabel.mas_centerY);
        
    }];
    
    UILabel * wenzhang = [[UILabel alloc]init];
    wenzhang.text = @"文章";
    wenzhang.textColor = [UIColor whiteColor];
    wenzhang.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:wenzhang];
    [wenzhang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wenzhangNum.mas_left).offset(-7);
        make.centerY.equalTo(wenzhangNum.mas_centerY);
        
    }];
    
    UILabel * haoyou = [[UILabel alloc]init];
    haoyou.text = @"好友";
    haoyou.textColor = [UIColor whiteColor];
    haoyou.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:haoyou];
    [haoyou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(linelabel.mas_right).offset(16);
        make.centerY.equalTo(linelabel.mas_centerY);
        
    }];
    
    UILabel * haoyouNum = [[UILabel alloc]init];
    haoyouNum.textColor = [UIColor whiteColor];
    haoyouNum.text = @"20";
    haoyouNum.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:haoyouNum];
    [haoyouNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(haoyou.mas_right).offset(7);
        make.centerY.equalTo(haoyou.mas_centerY);
        
    }];
    
    //第一坨
    UIView * firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom);
        make.left.equalTo(firstView.superview);
        make.right.equalTo(firstView.superview);
        make.height.mas_equalTo(120);
        
    }];

    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView.mas_centerY);
        make.left.equalTo(centerLabel.superview).offset(12);
        make.right.equalTo(centerLabel.superview).offset(-12);
        make.height.mas_equalTo(0.5);
    
    }];
    
    //第二坨
    UIView * secoendView = [[UIView alloc]init];
    secoendView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secoendView];
    [secoendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(12);
        make.left.equalTo(firstView.superview);
        make.right.equalTo(firstView.superview);
        make.height.mas_equalTo(120);

    }];
    
    UILabel * centerlabel2 = [[UILabel alloc]init];
    centerlabel2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:centerlabel2];
    [centerlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secoendView.mas_centerY);
        make.left.equalTo(centerLabel.superview).offset(12);
        make.right.equalTo(centerLabel.superview).offset(-12);
        make.height.mas_equalTo(0.5);
    
    }];
    
    UIView * lastView = [[UIView alloc]init];
    lastView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lastView];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secoendView.mas_bottom).offset(36);
        make.left.equalTo(firstView.superview);
        make.right.equalTo(firstView.superview);
        make.height.mas_equalTo(55);
    }];
    
    UILabel * loginoutLabel = [[UILabel alloc]init];
    loginoutLabel.text = @"登 出";
    loginoutLabel.textColor = [UIColor blackColor];
    loginoutLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginoutLabel];
    [loginoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lastView.mas_centerX);
        make.centerY.equalTo(lastView.mas_centerY);
        
    }];
    
    UIButton * loginoutBtn = [[UIButton alloc]init];
    loginoutBtn.backgroundColor = [UIColor clearColor];
    [loginoutBtn addTarget:self action:@selector(loginOutButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginoutBtn];
    [loginoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secoendView.mas_bottom).offset(36);
        make.left.equalTo(firstView.superview);
        make.right.equalTo(firstView.superview);
        make.height.mas_equalTo(55);
    }];
}

-(void)loginOutButtontouch{

    FuckLog(@"退出登录");
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];

     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStateChange object:@NO];
    [[AccountManager sharedAccountManager]logout];
    
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }

     }]];
    [self presentViewController:alert animated:YES completion:nil];

}



@end
