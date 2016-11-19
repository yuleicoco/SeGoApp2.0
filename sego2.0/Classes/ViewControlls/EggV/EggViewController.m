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
#import "AFHttpClient+DeviceUseMember.h"


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
    UIButton * btnOpen;
    
    
    
    
    
    
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
        btnOpen.hidden = YES;
        return;
        
    }else
    {
        btnAdd.hidden = YES;
        
        
    }
    // 在线
    if ([str isEqualToString:@"ds001"]) {
        [ImageBack setImage:[UIImage imageNamed:@"online"]];
       
            //在线
            btnOpen.backgroundColor = GREEN_COLOR;
            btnOpen.enabled = TRUE;
            btnOpen.hidden = NO;
            
      

        
          return;
    }
    //离线
    if ([str isEqualToString:@"ds002"]) {
        [ImageBack setImage:[UIImage imageNamed:@"offline"]];
        [self openGray];
        
          return;
    }
    //通话中
    if ([str isEqualToString:@"ds003"]) {
        [ImageBack setImage:[UIImage imageNamed:@"incall"]];
        [self openGray];
          return;
    }
    // 正在上传文件
    if ([str isEqualToString:@"ds004"]) {
        [ImageBack setImage:[UIImage imageNamed:@"egg_up"]];
        [self openGray];
          return;
    }
    
}


- (void)openGray
{
    
    btnOpen.backgroundColor = GRAY_COLOR;
    btnOpen.hidden = NO;
    btnOpen.enabled = FALSE;
    
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

    btnOpen =[UIButton new];
    btnOpen.layer.cornerRadius = 4;
   
    [btnOpen setTitle:@"开启互动" forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(OpenTouch:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    
    // 设置
    UIImageView * setImage =[UIImageView new];
    setImage.image =[UIImage imageNamed:@"egg_ prompt"];
    [self.view addSubview:setImage];
    
    
    [setImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@115);
        make.height.equalTo(@129);
        make.right.equalTo(self.view).offset(-11);
        make.top.equalTo(self.view).offset(1);
        
        
    }];
    
    // 三个buton
    UIButton * wifiBtn =[UIButton new];
    [wifiBtn setTitle:@"WIFI设置" forState:UIControlStateNormal];
    UIButton * foodBtn =[UIButton new];
    [foodBtn setTitle:@"喂食设置" forState:UIControlStateNormal];
    UIButton * bdinBtn =[UIButton new];
    [bdinBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [setImage addSubview:wifiBtn];
    [setImage addSubview:foodBtn];
    [setImage addSubview:bdinBtn];
    
    
    NSArray * arrBtn =[NSArray array];
    arrBtn =@[wifiBtn,foodBtn,bdinBtn];
    
    [arrBtn mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:80 leadSpacing:60 tailSpacing:60];
    [arrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(setImage).offset(20);
        make.right.equalTo(setImage).offset(-20);
        make.top.equalTo(setImage.mas_top).offset(10);
        
        
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
    
    if ([str isEqualToString:@"ds001"]) {
        
        // 设备号 需要判断
        //时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        NSString * strDevice = [Defaluts objectForKey:@"DeviceNum"];

        
      [[AFHttpClient sharedAFHttpClient]DeviceUseMember:[AccountManager sharedAccountManager].loginModel.mid object:@"self" deviceno:strDevice belong:[AccountManager sharedAccountManager].loginModel.mid starttime:locationString complete:^(BaseModel *model) {
        
        
    }];
        
        
        
    }else
    {
        
        //提示信息
        return;
        
    }
    
    
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
    [self showBarButton:NAV_RIGHT title:@"设置" fontColor:GREEN_COLOR hide:YES];
    
    


}

- (void)doRightButtonTouch
{
    
    
    
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



#pragma mark - Event Functions

//  call
//
/*
 @dialerNumber 别人的账号
 @sipName 自己的账号
 @ 视频通话
 */
- (void)sipCall:(NSString*)dialerNumber sipName:(NSString *)sipName
{
    
    NSString *  displayName  =nil;
    [[SephoneManager instance] call:dialerNumber displayName:displayName transfer:FALSE];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
