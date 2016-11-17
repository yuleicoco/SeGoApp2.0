//
//  EggViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "EggViewController.h"
#import "InCallViewController.h"
#import "BindingViewController.h"
#import "DeviceStats.h"
#import "AFHttpClient+DeviceStats.h"



@interface EggViewController ()
{
    UIImageView * ImageBack;
    BindingViewController * bindVC;
    
    // 引导view
    UIImageView * viewGuide;
    // 知道按钮
    UIButton * btn;
    // 添加按钮
    UIButton * btnAdd;
    
    
    
    
}

@end

@implementation EggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    // sephone
  //  [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
   // self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
}



// sephone的通知
- (void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
    [self checkWifi];
    [self checkDeviceStats];
    
    
    
}



- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
    // 检查设备状态
    
    
    /*
    mid : 会员标识
    retCode : 返回状态码（成功：0000，失败：1111，异常：2222）
    content : 投食总量
    retVal : 设备状态信息集合
    设备状态实体：
    deviceno;	//设备号
    status;		//状态信息(设备不存在：ds000,在线：ds001,离线：ds002,通话中：ds003,正在上传文件：ds004)
    signal;		//设备WIFI信号强度  取值范围为0~32，值越大信号强度越大，10以下就很弱了

     */
    

   
    
    
    
    
}
//检查用户wifi设置


- (void)checkWifi
{
    
    // 这个时候出现引导界面
    if ([[Defaluts objectForKey:@"succfulValue"] isEqualToString:@"ok"]) {
        btn.hidden = NO;
        viewGuide.hidden = NO;
        [btnAdd removeFromSuperview];
        [Defaluts removeObjectForKey:@"succfulValue"];
        [Defaluts synchronize];
        
    }

    
    
}

// 检查设备状态
- (void)checkDeviceStats
{
    
    [[AFHttpClient sharedAFHttpClient]DeviceStats: [AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        
        FuckLog(@"%@",model);
        
    }];
    
}



// 注册消息处理
- (void)registrationUpdate:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    switch (state) {
            
        case SephoneRegistrationNone:
            
            NSLog(@"======开始");
            break;
        case SephoneRegistrationProgress:
            NSLog(@"=====注册进行");
            break;
        case SephoneRegistrationOk:
            
            NSLog(@"=======成功");
            break;
        case SephoneRegistrationCleared:
            break;
        case SephoneRegistrationFailed:
            NSLog(@"========OK 以外都是失败");
            break;
            
        default:
            break;
    }
    
}


// 通话状态处理
- (void)callUpdate:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    
    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功
            InCallViewController *   _incallVC =[[InCallViewController alloc]initWithNibName:@"InCallViewController" bundle:nil];
            [_incallVC setCall:call];
            [self presentViewController:_incallVC animated:YES completion:nil];
            break;
        }
            
        case SephoneCallStreamsRunning: {
            break;
        }
        case SephoneCallUpdatedByRemote: {
            break;
        }
            
        default:
            break;
    }
}



// 初始化界面
- (void)setupView
{
    [super  setupView];
    
    [self NodeviceImageUI];
    // 背景图
    ImageBack = [[UIImageView alloc]init];
    // 300 150
    // 添加按钮
    btnAdd =[[UIButton alloc]init];
    btnAdd.hidden = NO;
    [btnAdd setImage:[UIImage imageNamed:@"egg_add"] forState:UIControlStateNormal];
   
    [btnAdd addTarget:self action:@selector(btn_add:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 指导界面
    viewGuide =[UIImageView new];
    viewGuide.image =[UIImage imageNamed:@"setb"];
    viewGuide.userInteractionEnabled = YES;
    viewGuide.hidden = YES;
    
  //  viewGuide.cli
    [ApplicationDelegate.window addSubview:viewGuide];
    [viewGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(ApplicationDelegate.window.mas_centerY);
        make.size.mas_equalTo(ApplicationDelegate.window);
      //  make.top.equalTo(@20);
        
    }];
    
    btn =[UIButton new];
    [btn setImage:[UIImage imageNamed:@"konw"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(disparrBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    
    [viewGuide addSubview:btn];
    
     [btn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(ApplicationDelegate.window).offset(191);
         make.right.equalTo(ApplicationDelegate.window).offset(-79);
         make.top.equalTo(@160);
         make.height.equalTo(@40);
         
         
         
     }];
    
       // 判断设备的状态
    if (nil) {
        
    }
    
    [ImageBack setImage:[UIImage imageNamed:@"egg_nodevcie"]];
    [self.view addSubview:ImageBack];
    [ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(self.view);
        make.top.left.right.equalTo(@0);
        
        
    }];
    
     [self.view addSubview:btnAdd];
     [btnAdd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(120);
        make.size.mas_equalTo(CGSizeMake(90, 60));
        make.left.equalTo(@150);
    }];
    
    
}


- (void)disparrBtn:(UIButton *)sender
{
    
    [sender removeFromSuperview];
    [viewGuide removeFromSuperview];
    
    
}



// 数据
- (void)setupData
{
    [super setupData];
    
    
}



// first

- (void)NodeviceImageUI
{
    
    UIButton * btnSet =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    [btnSet setImage:[UIImage imageNamed:@"new_egg_seting.png"] forState:UIControlStateNormal];
    btnSet.titleLabel.font =[UIFont systemFontOfSize:17];
    [btnSet addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settings =[[UIBarButtonItem alloc]initWithCustomView:btnSet];
    self.navigationItem.rightBarButtonItem = settings;
    
    
    
    
    
    
}

- (void)btn_add:(UIButton *)sender
{
    
    // 绑定设备界面
    bindVC  =[[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindVC animated:NO];
    
    
}


-(void)settings:(UIButton *)sender
{
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
