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
#import "WifiViewController.h"



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
    //清晰按钮
    UIButton * btnClean ;
    // 流畅按钮
    UIButton * btnFluency;
    // 开启互动按钮
    UIButton * btnOpen;
    // 背景图
    UIImageView * setImage;
    // 画面质量
    UILabel * qualityLB;
    // btn数组
    NSArray * arrBtn;
    
    
    
    
    
    
    
    
    
}

@end

@implementation EggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    // sephone
  //  [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
    
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FuckLog(@"pop");
    
    
}


// sephone的通知
- (void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
     [self checkDeviceStats];
   //  [self checkWifi];

    
    
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
        btnAdd.hidden = YES;
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
            [self updateviewMethod];
        
        }// 没有设备
        else if ([model.totalrecords isEqualToString:@"0"])
        {
            str = [NSString stringWithFormat:@"%@",@"ds000"];
            [self updateviewMethod];
            
        }
        
        [self ReshUI];
        
        
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
        [self hideSetTitle:YES];
        return;
        
    }else
    {
        btnAdd.hidden = YES;
        [self hideSetTitle:NO];
        setImage.hidden = NO;
        
        
    }
    // 在线
    if ([str isEqualToString:@"ds001"]) {
        [ImageBack setImage:[UIImage imageNamed:@"online"]];
       
            //在线
            btnOpen.backgroundColor = GREEN_COLOR;
            btnOpen.enabled = TRUE;
            btnOpen.hidden = NO;
            setImage.hidden = NO;
            [self hideSetTitle:NO];
      

        
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


- (void)hideSetTitle:(BOOL)hide;

{
    
    [self showBarButton:NAV_RIGHT title:@"设置" fontColor:GREEN_COLOR hide:hide];
    
}


- (void)openGray
{
    
    btnOpen.backgroundColor = GRAY_COLOR;
    btnOpen.hidden = NO;
    btnOpen.enabled = FALSE;
    setImage.hidden = NO;

    [self hideSetTitle:NO];
    
}



// 数据
- (void)setupData
{
    [super setupData];
    
    
    
}


// 初始化界面
- (void)setupView
{
    [super  setupView];
   
    
    
    // 指导界面
    viewGuide =[UIImageView new];
    viewGuide.image =[UIImage imageNamed:@"setb"];
    viewGuide.userInteractionEnabled = YES;
    viewGuide.hidden = YES;

    [ApplicationDelegate.window addSubview:viewGuide];
    [viewGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(ApplicationDelegate.window.mas_centerY);
        make.size.mas_equalTo(ApplicationDelegate.window);
        
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
    
    
    [self test];
    
    
    
  
   
    
    
   // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    
    
}

- (void)test
{
    
    // 背景图
    
    [ImageBack removeFromSuperview];
    ImageBack = [UIImageView new];
  
    [self.view addSubview:ImageBack];
    
    
    // 添加按钮
    btnAdd =[[UIButton alloc]init];
    
    [btnAdd setImage:[UIImage imageNamed:@"egg_add"] forState:UIControlStateNormal];
    
    [btnAdd addTarget:self action:@selector(btn_add:) forControlEvents:UIControlEventTouchUpInside];
    
    // 画面质量文字
    qualityLB =[UILabel new];
    btnOpen =[UIButton new];
    btnClean =[UIButton new];
    btnFluency= [UIButton new];
    setImage =[UIImageView new];
    UIButton * wifiBtn =[UIButton new];
    UIButton * foodBtn =[UIButton new];
    UIButton * bdinBtn =[UIButton new];
    
    
    qualityLB.text = @"画面质量:";
    qualityLB.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:qualityLB];
    
    //开启互动
    
    btnOpen.layer.cornerRadius = 4;
    
    [btnOpen setTitle:@"开启互动" forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(OpenTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOpen];
    
    
    
    
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
    NSString * typeStr2 =  [AccountManager sharedAccountManager].loginModel.resolution;
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
    [self.view addSubview:btnAdd];
   
    
    
    
    // 设置
   
    setImage.image =[UIImage imageNamed:@"egg_ prompt"];
    setImage.userInteractionEnabled = YES;
    setImage.hidden = YES;
    [self.view addSubview:setImage];
    
    
   
    
    
    // 三个buton
    
    [wifiBtn setTitle:@"WIFI设置" forState:UIControlStateNormal];
    [wifiBtn addTarget:self action:@selector(wifiTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [foodBtn addTarget:self action:@selector(foodTouch:) forControlEvents:UIControlEventTouchUpInside];
    [foodBtn setTitle:@"喂食设置" forState:UIControlStateNormal];
    
    [bdinBtn addTarget:self action:@selector(bdinTouch:) forControlEvents:UIControlEventTouchUpInside];
    [bdinBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [setImage addSubview:wifiBtn];
    [setImage addSubview:foodBtn];
    [setImage addSubview:bdinBtn];
    
    
    arrBtn =[NSArray array];
    arrBtn =@[wifiBtn,foodBtn,bdinBtn];
    
    
   

    
    
}


// 更新约束
- (void)updateviewMethod
{
    // 背景
    [ImageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ([str isEqualToString:@"ds000"]) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(self.view);
            make.top.left.right.equalTo(@0);
        }else
            
        {
            make.width.equalTo(self.view.superview);
            make.top.equalTo(self.view.superview.mas_top).offset(102);
            make.bottom.equalTo(self.view.superview.mas_bottom).offset(-220);
        }
    }];
 
    
    //画面质量文字
    [qualityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(90);
        make.top.equalTo(ImageBack.mas_bottom).offset(44);
        
        
    }];
    //开启互动按钮
    [btnOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view.superview.mas_bottom).offset(-67);
        make.left.equalTo(self.view.superview.mas_left).with.offset(18);
        make.right.equalTo(self.view.superview.mas_right).with.offset(-18);
        
    }];
    CGRect rectTab1 =  self.tabBarController.tabBar.frame;
    
    
    FuckLog(@"%f",rectTab1.size.height);
    
    // 流畅清晰
    
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

    //添加按钮
    [btnAdd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(120);
        make.size.mas_equalTo(CGSizeMake(90, 60));
        make.left.equalTo(@150);
        
    }];
    
    // 设置背景
    [setImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(115, 129));
        make.right.equalTo(self.view).offset(-11);
        make.top.equalTo(self.view).offset(1);
        
    }];
    // btn 数组
    
    [arrBtn mas_distributeViewsAlongAxis:MASAxisTypeVertical
                        withFixedSpacing:15
                             leadSpacing:10
                             tailSpacing:5];
    
    [arrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(setImage).offset(20);
        make.right.equalTo(setImage).offset(-20);
        
    }];

    
    
    
}




// 设置选项
// wifi
- (void)wifiTouch:(UIButton *)sender
{
    WifiViewController * wifiVC =[[WifiViewController alloc]init];
    [self.navigationController pushViewController:wifiVC animated:YES];
    
    
    
}
//喂食
- (void)foodTouch:(UIButton *)sender
{
    
    
}

// 解除绑定
- (void)bdinTouch:(UIButton *)sender
{
    
    bindVC =[[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindVC animated:YES];
    

    
}




-(void)handletapPressGesture:(UITapGestureRecognizer*)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        setImage.alpha=0.0;
    } completion:^(BOOL finished) {
       // [setImage removeFromSuperview];
    }];
        [self dismissViewControllerAnimated:YES
                                 completion:^{
            [self.view removeGestureRecognizer:sender];
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





// 设置按钮点击
- (void)doRightButtonTouch
{
    if (setImage.alpha<1) {
        setImage.alpha = 1;
      
    }else
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            setImage.alpha=0.0;
        } completion:^(BOOL finished) {
            // [setImage removeFromSuperview];
        }];
        return;
        
    }
    
}

- (void)btn_add:(UIButton *)sender
{
    
    // 绑定设备界面
    bindVC  =[[BindingViewController alloc]init];
    [self.navigationController pushViewController:bindVC animated:NO];
    
    
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
