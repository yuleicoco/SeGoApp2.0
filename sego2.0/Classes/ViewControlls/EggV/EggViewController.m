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
#import "DeviceStats.h"
#import "AFHttpClient+VideoQuiltChoose.h"


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
    // 设备状态
    NSString *str;
    // 视频质量
    NSString *typeStr;
    UIButton * btnClean ;
    UIButton * btnFluency;
    
    
    
    
    
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
        if ([model.retCode isEqualToString:@"0000"]) {
            str = [NSString stringWithFormat:@"%@",model.retVal[@"status"]];
            
            [self ReshUI];
        }
        
        
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

// 刷新UI
- (void)ReshUI
{
    
    
    // 设备不存在线
    if ([str isEqualToString:@"ds000"]) {
        
        [ImageBack setImage:[UIImage imageNamed:@"egg_nodevcie"]];
        btnAdd.hidden = NO;
        return;
        
    }else
    {
        btnAdd.hidden = YES;
        
        
    }
    // 在线
    if ([str isEqualToString:@"ds001"]) {
        [ImageBack setImage:[UIImage imageNamed:@"online"]];
          return;
    }
    //离线
    if ([str isEqualToString:@"ds002"]) {
        [ImageBack setImage:[UIImage imageNamed:@"offline"]];
          return;
    }
    //通话中
    if ([str isEqualToString:@"ds003"]) {
        [ImageBack setImage:[UIImage imageNamed:@"incall"]];
          return;
    }
    // 正在上传文件
    if ([str isEqualToString:@"ds004"]) {
        [ImageBack setImage:[UIImage imageNamed:@"egg_up"]];
          return;
    }
    
}





// 初始化界面
- (void)setupView
{
    [super  setupView];
    
    [self NodeviceImageUI];
   
                 
    // 300 150
    // 添加按钮
    btnAdd =[[UIButton alloc]init];
    
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
    
    
    
    
    
  
    // 背景图
    ImageBack = [UIImageView new];
    [self.view addSubview:ImageBack];
    
    
    if ([str isEqualToString:@"ds000"]) {
        [ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(self.view);
            make.top.left.right.equalTo(@0);
            
            
        }];
    }else
        
    {
        
        [ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(50);
            make.bottom.equalTo(self.view.mas_bottom).offset(-220);
            
    
           
        }];

        
    }
   

    // 画面质量
    
    UILabel * qualityLB =[UILabel new];
    qualityLB.text = @"画面质量:";
    qualityLB.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:qualityLB];
    
    
    [qualityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(90);
        make.top.equalTo(ImageBack.mas_bottom).offset(44);
        
        
    }];
    
    // 画面质量

    UIButton * btnOpen =[UIButton new];
    btnOpen.layer.cornerRadius = 4;
    btnOpen.backgroundColor = GRAY_COLOR;
    [btnOpen setTitle:@"开启互动" forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(OpenTouch:) forControlEvents:UIControlEventTouchUpInside];
    btnOpen.enabled = FALSE;
    [self.view addSubview:btnOpen];
    [btnOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@45);
        make.top.equalTo(qualityLB.mas_bottom).offset(43);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        
    }];
    
    
    
     btnClean =[UIButton new];
     btnFluency= [UIButton new];
    btnClean.tag = 1001;
    btnFluency.tag = 1002;
    [btnClean setTitle:@"清晰" forState:UIControlStateNormal];
    btnClean.layer.cornerRadius = 2;
    btnClean.layer.borderWidth =0.6;
    
    [btnClean addTarget:self action:@selector(ChooseCleanbtn:) forControlEvents:UIControlEventTouchUpInside];
    btnClean.titleLabel.font =[UIFont systemFontOfSize:15];
    [btnFluency setTitle:@"流畅" forState:UIControlStateNormal];
    btnFluency.layer.cornerRadius = 2;
    btnFluency.layer.borderWidth =0.6;
    [btnFluency addTarget:self action:@selector(ChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnFluency.titleLabel.font =[UIFont systemFontOfSize:15];
    
    
    // 这里还差一个条件 用户手动选择了
    NSString * typeStr1 =  [Defaluts objectForKey:@"VC_Choose"];
    NSString * typeStr2 =     [AccountManager sharedAccountManager].loginModel.resolution;
    if ([AppUtil isBlankString:typeStr1]) {
        
        typeStr =typeStr2;
        
    }else
    {
        
         typeStr =typeStr1;
    }
    
    
    if ([typeStr isEqualToString:@"r1"]) {
        
        // 流畅
        btnFluency.selected =YES;
        btnClean.selected = NO;
        
        
    }else
    {
        btnFluency.selected =NO;
        btnClean.selected = YES;
        
    }
    
    

    [self colorChoose];
    
    
    [self.view addSubview:btnClean];
    [self.view addSubview:btnFluency];
    
    [btnClean mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(qualityLB.mas_centerY);
        make.left.equalTo(qualityLB.mas_right).offset(15);
        make.top.equalTo(ImageBack.mas_bottom).offset(40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        
        
    }];
    
    [btnFluency mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(qualityLB.mas_centerY);
        make.left.equalTo(btnClean.mas_right).offset(-1);
        make.top.equalTo(ImageBack.mas_bottom).offset(40);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        
    }];
    
    
    
     [self.view addSubview:btnAdd];
     [btnAdd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(120);
        make.size.mas_equalTo(CGSizeMake(90, 60));
        make.left.equalTo(@150);
         
    }];
    
    
}

- (void)colorChoose
{
    
    // 只有在线的时候为可点
    
    if ([str isEqualToString:@"ds001"]) {
        
        if (btnClean.selected) {
            btnClean.backgroundColor =GREEN_COLOR;
            btnClean.layer.borderColor =GRAY_COLOR.CGColor;
            [btnClean  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            btnFluency.backgroundColor =[UIColor whiteColor];
            btnFluency.layer.borderColor =GRAY_COLOR.CGColor;
            [btnFluency  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else
        {
            
            
            btnFluency.backgroundColor =GREEN_COLOR;
            btnFluency.layer.borderColor =GRAY_COLOR.CGColor;
            [btnFluency  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            btnClean.backgroundColor =[UIColor whiteColor];
            btnClean.layer.borderColor =GRAY_COLOR.CGColor;
            [btnClean  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }
        
        
    }else
    {
        
        // 为灰色
        
        if (btnClean.selected) {
            
            btnClean.backgroundColor =GRAY_COLOR;
            btnClean.layer.borderColor =GRAY_COLOR.CGColor;
            btnFluency.backgroundColor =[UIColor whiteColor];
            btnFluency.layer.borderColor =GRAY_COLOR.CGColor;
            [btnClean  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnFluency  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else
        {
            
            btnFluency.backgroundColor =GRAY_COLOR;
            btnFluency.layer.borderColor =GRAY_COLOR.CGColor;
            [btnFluency  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnClean.backgroundColor =[UIColor whiteColor];
            btnClean.layer.borderColor =GRAY_COLOR.CGColor;
            
            [btnClean  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
        
        
    }
    
}

// 选择视频质量
// 流畅
- (void)ChooseBtn:(UIButton *)sender
{
   UIButton * btnF =  (UIButton *)[self.view viewWithTag:1001];
    
   
    if (sender.selected) {
    
        btnF.selected = NO;
        
    }else
    {
        sender.selected = YES;
        [self NetWorkUpChoose:@"r1"];
        
    }
    
    [self colorChoose];
    
    
}

// 清晰
- (void)ChooseCleanbtn:(UIButton *)sender
{
    UIButton * btnCl =  (UIButton *)[self.view viewWithTag:1002];
  
    
    if (sender.selected) {
        btnCl.selected = NO;
        
        
    }else
    {
        sender.selected = YES;
        [self NetWorkUpChoose:@"r2"];
        
    }
    
    [self colorChoose];
    
    
}

- (void)NetWorkUpChoose:(NSString *)strQu
{
    
    [[AFHttpClient sharedAFHttpClient]VideoQuiltChoose:[AccountManager sharedAccountManager].loginModel.mid vtype:strQu complete:^(BaseModel * model) {
        
        FuckLog(@"%@",model.retCode);
        if ([model.retCode isEqualToString:@"0000"]) {
            [Defaluts setValue:strQu forKey:@"VC_Choose"];
            [Defaluts synchronize];
            
            
            
        }
        
    }];
    
    
    

    
    
}


// 开启互动

- (void)OpenTouch:(UIButton *)sender
{
    
    
    
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
