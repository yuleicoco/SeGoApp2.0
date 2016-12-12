//
//  MeViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "MeViewController.h"
#import "InformationViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage-Extensions.h"
#import "ExchangPasswordViewController.h"
#import "AboutViewController.h"
#import "PermissionViewController.h"

@interface MeViewController ()
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UIButton * headBtn;
@property (nonatomic,strong)UIImageView * headImage;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setNavTitle:@"个人中心"];
    
  //  [self showBarButton:NAV_RIGHT title:@"设置" fontColor:GREEN_COLOR];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeName) name:@"meshuashua" object:nil];
}

-(void)changeName{
    _nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
      [_headImage sd_setImageWithURL:[NSURL URLWithString:[AccountManager sharedAccountManager].loginModel.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    



}

-(void)setupView{
    [super setupView];
    self.view.backgroundColor = GRAY_COLOR;
    UIImageView * topImage = [[UIImageView alloc]init];
   // topImage.backgroundColor= [UIColor redColor];
    topImage.image = [UIImage imageNamed:@"newpersonback.png"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.superview);
        make.left.equalTo(topImage.superview);
        make.right.equalTo(topImage.superview);
        make.height.mas_equalTo(172);

    }];
    
   _headBtn = [[UIButton alloc]init];
    _headBtn.backgroundColor = [UIColor clearColor];
    [_headBtn addTarget:self action:@selector(headbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headBtn];
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headBtn.superview).offset(14);
        make.left.equalTo(_headBtn.superview).offset(147);
        make.right.equalTo(_headBtn.superview).offset(-147);
        make.height.mas_equalTo(80);
        
    }];
    
    
    _headImage = [[UIImageView alloc]init];
    _headImage.backgroundColor = [UIColor clearColor];
    _headImage.layer.cornerRadius = 40;
    [_headImage.layer setMasksToBounds:YES];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[AccountManager sharedAccountManager].loginModel.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    [self.view addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.superview).offset(14);
        make.left.equalTo(_headImage.superview).offset(147);
        make.right.equalTo(_headImage.superview).offset(-147);
        make.height.mas_equalTo(80);
    }];
    
    
    
    
    
    
    
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBtn.mas_centerX);
        make.top.equalTo(_headBtn.mas_bottom).offset(9);
        
    }];

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linelabel];
    [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_nameLabel.mas_centerX);
        make.top.equalTo(_nameLabel.mas_bottom).offset(16);
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
    centerLabel.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView.mas_centerY);
        make.left.equalTo(centerLabel.superview).offset(12);
        make.right.equalTo(centerLabel.superview).offset(-12);
        make.height.mas_equalTo(0.5);
    
    }];
    
    UIImageView * doumaImage = [[UIImageView alloc]init];
    doumaImage.image = [UIImage imageNamed:@"douma.png"];
    [self.view addSubview:doumaImage];
    [doumaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doumaImage.superview).offset(13);
        make.top.equalTo(firstView.mas_top).offset(20);
        make.bottom.equalTo(centerLabel.mas_top).offset(-20);
        make.width.mas_equalTo(21);
        
        
    }];
    
    UILabel * doumaLabel = [[UILabel alloc]init];
    doumaLabel.text = @"逗码";
    doumaLabel.textColor = [UIColor blackColor];
    doumaLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:doumaLabel];
    [doumaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doumaImage.mas_right).offset(16);
        make.centerY.equalTo(doumaImage.mas_centerY);
        
    }];
    
    UIButton * doumaBtn = [[UIButton alloc]init];
    doumaBtn.backgroundColor = [UIColor clearColor];
    [doumaBtn addTarget:self action:@selector(doumabuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doumaBtn];
    [doumaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_top);
        make.bottom.equalTo(centerLabel.mas_top);
        make.left.equalTo(doumaBtn.superview);
        make.right.equalTo(doumaBtn.superview);
    }];
    
    UIImageView * quanxianImage = [[UIImageView alloc]init];
    quanxianImage.image=  [UIImage imageNamed:@"quanxian.png"];
    [self.view addSubview:quanxianImage];
    [quanxianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quanxianImage.superview).offset(13);
        make.top.equalTo(centerLabel.mas_bottom).offset(19);
        make.bottom.equalTo(firstView.mas_bottom).offset(-19);
        make.width.mas_offset(22);
    }];
    

    UILabel * quanxianLabel = [[UILabel alloc]init];
    quanxianLabel.text = @"权限设置";
    quanxianLabel.textColor = [UIColor blackColor];
    quanxianLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:quanxianLabel];
    [quanxianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quanxianImage.mas_right).offset(16);
        make.centerY.equalTo(quanxianImage.mas_centerY);
    }];
    UIButton * quanxianBtn = [[UIButton alloc]init];
    quanxianBtn.backgroundColor = [UIColor clearColor];
    [quanxianBtn addTarget:self action:@selector(quanxianbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quanxianBtn];
    [quanxianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerLabel.mas_bottom);
        make.bottom.equalTo(firstView.mas_bottom);
        make.left.equalTo(doumaBtn.superview);
        make.right.equalTo(doumaBtn.superview);
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
    centerlabel2.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [self.view addSubview:centerlabel2];
    [centerlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secoendView.mas_centerY);
        make.left.equalTo(centerLabel.superview).offset(12);
        make.right.equalTo(centerLabel.superview).offset(-12);
        make.height.mas_equalTo(0.5);
    
    }];
    
    UIImageView * exchangeImage = [[UIImageView alloc]init];
    exchangeImage.image = [UIImage imageNamed:@"exchangepassword.png"];
    [self.view addSubview:exchangeImage];
    [exchangeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exchangeImage.superview).offset(12);
        make.top.equalTo(secoendView.mas_top).offset(19);
        make.bottom.equalTo(centerlabel2.mas_top).offset(-19);
        make.width.mas_equalTo(22);
        
    }];
    
    UILabel * exchangeLabel = [[UILabel alloc]init];
    exchangeLabel.text = @"修改密码";
    exchangeLabel.textColor = [UIColor blackColor];
    exchangeLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:exchangeLabel];
    [exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exchangeImage.mas_right).offset(16);
        make.centerY.equalTo(exchangeImage.mas_centerY);
    }];
    
    UIButton * exchangBtn = [[UIButton alloc]init];
    exchangBtn.backgroundColor = [UIColor clearColor];
    [exchangBtn addTarget:self action:@selector(exchangebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangBtn];
    [exchangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secoendView.mas_top);
        make.bottom.equalTo(centerlabel2.mas_top);
        make.left.equalTo(doumaBtn.superview);
        make.right.equalTo(doumaBtn.superview);
    }];
    
    UIImageView * aboutImage = [[UIImageView alloc]init];
    aboutImage.image = [UIImage imageNamed:@"about.png"];
    [self.view addSubview:aboutImage];
    [aboutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aboutImage.superview).offset(13);
        make.top.equalTo(centerlabel2.mas_bottom).offset(20);
        make.bottom.equalTo(secoendView.mas_bottom).offset(-19);
        make.width.mas_equalTo(22);
    }];
    
    UILabel * aboutLabel = [[UILabel alloc]init];
    aboutLabel.text = @"关于";
    aboutLabel.textColor = [UIColor blackColor];
    aboutLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:aboutLabel];
    [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aboutImage.mas_right).offset(16);
        make.centerY.equalTo(aboutImage.mas_centerY);
        
    }];
    
    
    
    UIButton * aboutBtn = [[UIButton alloc]init];
    aboutBtn.backgroundColor = [UIColor clearColor];
    [aboutBtn addTarget:self action:@selector(aboutbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBtn];
    [aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerlabel2.mas_bottom);
        make.bottom.equalTo(secoendView.mas_bottom);
        make.left.equalTo(doumaBtn.superview);
        make.right.equalTo(doumaBtn.superview);
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


-(void)headbuttonTouch{
    FuckLog(@"点击头像");
    InformationViewController * inforVc =[[InformationViewController alloc]init];
    [self.navigationController pushViewController:inforVc animated:NO];
    
}

-(void)doumabuttonTouch{
    FuckLog(@"逗码");

}

-(void)quanxianbuttonTouch{
    FuckLog(@"权限设置");
    PermissionViewController * perVc = [[PermissionViewController alloc]init];
    [self.navigationController pushViewController:perVc animated:NO];
    
    
}
-(void)exchangebuttonTouch{
    FuckLog(@"修改密码");
    if ([AppUtil isBlankString: [AccountManager sharedAccountManager].loginModel.type ]) {
        ExchangPasswordViewController * exchangVc = [[ExchangPasswordViewController alloc]init];
        [self.navigationController pushViewController:exchangVc animated:NO];
        
    }else{
          [[AppUtil appTopViewController]showHint:@"第三方登录，不能修改密码哦亲"];
    }
    
    
    
}

-(void)aboutbuttonTouch{
    FuckLog(@"关于");
    AboutViewController * aboutVc = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVc animated:NO];
    
    
    
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
