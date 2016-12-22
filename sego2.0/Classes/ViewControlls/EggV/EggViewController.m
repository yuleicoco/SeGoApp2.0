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
#import "AFHttpClient+DeviceUseMember.h"
#import "FeedSetingViewController.h"
#import "HWWeakTimer.h"


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
    NSString *strState;
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
    
    //别人
    NSString * isOtherDevice;
    //
    NSString * isOherID;
    // 投食量
    NSString * isTsnum;
    
    NSTimer * moveTimer;
    
    
    
    
    
    
    
    
}

@end

@implementation EggViewController
@synthesize DouMid;
@synthesize SearchMid;
@synthesize isOther;
@synthesize CodeMid;






- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabEgg_title",nil)];
    
    // sephone
    [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    
  
    
    
    
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
    
    
    
    //麦克风
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            NSLog(@"用户同意获取麦克风");
            
        } else {
            
            // 用户不同意获取麦克风
            NSLog(@"用户不同意");
            
        }
        
    }];
    

   
    
    
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      self.navigationController.navigationBar.translucent = NO;
    /*
    CGRect rectTab1 =  self.tabBarController.tabBar.frame;
    CGRect rectTab2  = self.navigationController.navigationBar.frame;
    CGRect  rectTab3 = [[UIApplication sharedApplication] statusBarFrame];
   */
  
    
    
}


// sephone的通知
- (void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    
    moveTimer =[HWWeakTimer scheduledTimerWithTimeInterval:5.0 block:^(id userInfo) {
        [self checkDeviceStats];
    } userInfo:@"Fire" repeats:YES];
     [self checkDeviceStats];
     [self checkWifi];
    

    if (isOther) {
        NSString * d = SearchMid.length>DouMid.length?SearchMid:(DouMid.length>CodeMid.length?DouMid:CodeMid);
            [[AFHttpClient sharedAFHttpClient]checkMidFriend:d complete:^(BaseModel * model) {
                FuckLog(@"%@",model);
                isOtherDevice = model.retVal[@"deviceno"];
                isOherID = model.retVal[@"mid"];
                isTsnum = model.retVal[@"tsnum"];
            }];
        
        
        
    }else
    {
        
        return;
        
    }
    
    
}



- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
    [moveTimer invalidate];
    
    
    
}
//检查用户wifi设置


- (void)checkWifi
{
    
    // 这个时候出现引导界面
    if ([[Defaluts objectForKey:@"setimage"] isEqualToString:@"ok"]) {
        btn.hidden = NO;
        viewGuide.hidden = NO;
        btnAdd.hidden = YES;
        [Defaluts removeObjectForKey:@"setimage"];
        [Defaluts synchronize];
        
    }

    
    
}

// 检查设备状态
- (void)checkDeviceStats
{
    
    

    if (isOther) {
        
        NSString * midOther = SearchMid.length>DouMid.length?SearchMid:(DouMid.length>CodeMid.length?DouMid:CodeMid);
        
        [[AFHttpClient sharedAFHttpClient]DeviceStats: midOther complete:^(BaseModel *model) {
            
            FuckLog(@"%@",model);
            if ([model.retCode isEqualToString:@"0000"]) {
                strState = [NSString stringWithFormat:@"%@",model.retVal[@"status"]];
                [self updateviewMethod];
                
            }// 没有设备
            else if ([model.totalrecords isEqualToString:@"0"])
            {
                strState = [NSString stringWithFormat:@"%@",@"ds000"];
                [self updateviewMethod];
                
            }
            
            [self ReshUI];
            
            
        }];
    }else
    {
    [[AFHttpClient sharedAFHttpClient]DeviceStats: [AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        
        FuckLog(@"%@",model);
        if ([model.retCode isEqualToString:@"0000"]) {
            
            
            if ([AppUtil isBlankString:model.retVal[@"status"]]) {
                strState = [NSString stringWithFormat:@"%@",@"ds000"];
            }else{
            strState = [NSString stringWithFormat:@"%@",model.retVal[@"status"]];
            }
            [self updateviewMethod];
        
        }// 没有设备
        else if ([model.totalrecords isEqualToString:@"0"])
        {
            strState = [NSString stringWithFormat:@"%@",@"ds000"];
            [self updateviewMethod];
            
        }
        
        [self ReshUI];
        
        
    }];
    
    }
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
            
            if (isOther) {
                _incallVC.isOther = YES;
                _incallVC.isTurmNum = isTsnum;
                
            }
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
    
    [self colorChoose];
    
    // 设备不存在线
    if ([strState isEqualToString:@"ds000"]) {
        
        [ImageBack setImage:[UIImage imageNamed:@"egg_nodevcie"]];
        btnAdd.hidden = NO;
        btnOpen.hidden = YES;
        [self hideSetTitle:YES];
        setImage.hidden = YES;
        return;
        
    }else
    {
        btnAdd.hidden = YES;
        [self hideSetTitle:NO];
    
    }
    // 在线
    if ([strState isEqualToString:@"ds001"]) {
        [ImageBack setImage:[UIImage imageNamed:@"online"]];
       
            //在线
            btnOpen.backgroundColor = GREEN_COLOR;
            btnOpen.enabled = TRUE;
            btnOpen.hidden = NO;
            [self hideSetTitle:NO];
      

        
          return;
    }
    //离线
    if ([strState isEqualToString:@"ds002"]) {
        [ImageBack setImage:[UIImage imageNamed:@"offline"]];
        [self openGray];
        
          return;
    }
    //通话中
    if ([strState isEqualToString:@"ds003"]) {
        [ImageBack setImage:[UIImage imageNamed:@"incall"]];
        [self openGray];
          return;
    }
    // 正在上传文件
    if ([strState isEqualToString:@"ds004"]) {
        [ImageBack setImage:[UIImage imageNamed:@"egg_up"]];
        [self openGray];
          return;
    }
    
}


- (void)hideSetTitle:(BOOL)hide;

{
    
    if (isOther) {
        hide = YES;
    }else
    {
        hide = hide;
    }
    [self showBarButton:NAV_RIGHT title:@"设置" fontColor:GREEN_COLOR hide:hide];
    
}


- (void)openGray
{
    
    btnOpen.backgroundColor = GRAY_COLOR;
    btnOpen.hidden = NO;
    btnOpen.enabled = FALSE;
    setImage.hidden = YES;
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
        
        if ([strState isEqualToString:@"ds000"]) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(self.view);
            make.top.left.right.equalTo(@0);
        }else
            
        {
//            make.width.equalTo(self.view.superview);
//            make.top.equalTo(self.view.superview.mas_top).offset(102);
//            make.bottom.equalTo(self.view.superview.mas_bottom).offset(-220);
            
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(330);
            make.top.equalTo(self.view.superview.mas_top).offset(90);
            make.width.mas_equalTo(350);
            
            
            
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
        make.bottom.equalTo(qualityLB.mas_bottom).offset(90);
        make.left.equalTo(self.view.superview.mas_left).with.offset(18);
        make.right.equalTo(self.view.superview.mas_right).with.offset(-18);
        
    }];
   
    
    // 流畅清晰
    
    [btnClean mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(qualityLB.mas_centerY);
        make.left.equalTo(qualityLB.mas_right).offset(15);
        make.top.equalTo(ImageBack.mas_bottom).offset(40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(23);
        
        
    }];
    
    [btnFluency mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(qualityLB.mas_centerY);
        make.left.equalTo(btnClean.mas_right).offset(-1);
        make.top.equalTo(ImageBack.mas_bottom).offset(40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(23);
        
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
    setImage.hidden = YES;
    WifiViewController * wifiVC =[[WifiViewController alloc]init];
    [self.navigationController pushViewController:wifiVC animated:YES];
    
    
    
}
//喂食
- (void)foodTouch:(UIButton *)sender
{
    setImage.hidden = YES;
    FeedSetingViewController * feedVc = [[FeedSetingViewController alloc]init];
    [self.navigationController pushViewController:feedVc animated:NO];
    
    
    
}

// 解除绑定
- (void)bdinTouch:(UIButton *)sender
{
    setImage.hidden = YES;
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
    
    if ([strState isEqualToString:@"ds001"]) {
        
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
        [self NetWorkUpChoose:@"r1"];

        
    }else
    {
        sender.selected = YES;
        
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
    
    
    NSString * strDevicenume =[AccountManager sharedAccountManager].loginModel.deviceno;
    NSString * strDevicenume1 =[Defaluts objectForKey:PREF_DEVICE_NUMBER];
    NSString * strNum;
    
    
    if (isOther) {
        
          [self sipCall:isOtherDevice sipName:nil];
    }else
    {
    if ([AppUtil isBlankString:strDevicenume]) {
        strNum = strDevicenume1;
    }else
    {
        strNum = strDevicenume;
        
    }
      [self sipCall:strNum sipName:nil];
    }
  

    if ([strState isEqualToString:@"ds001"]) {
        
        // 设备号 需要判断
        //时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        
        if (isOther) {
            
            [[AFHttpClient sharedAFHttpClient]DeviceUseMember:[AccountManager sharedAccountManager].loginModel.mid object:@"other" deviceno:isOtherDevice belong:isOherID starttime:locationString complete:^(BaseModel *model) {
    
                [Defaluts setObject:model.content forKey:@"selfID"];
                [Defaluts synchronize];
                
                
            }];
            
        }else{
        [[AFHttpClient sharedAFHttpClient]DeviceUseMember:[AccountManager sharedAccountManager].loginModel.mid object:@"self" deviceno:strNum belong:[AccountManager sharedAccountManager].loginModel.mid starttime:locationString complete:^(BaseModel *model) {
            [Defaluts setObject:model.content forKey:@"selfID"];
            [Defaluts synchronize];
            

         }];
            
        }
        
        
    }else
    {
        
        //提示信息
        return;
        
    }
    
    
}


- (void)disparrBtn:(UIButton *)sender
{
    setImage.hidden = NO;
    [sender removeFromSuperview];
    [viewGuide removeFromSuperview];
    
    
}





// 设置按钮点击
- (void)doRightButtonTouch
{
    
    if (setImage.alpha<1) {
        setImage.alpha = 1;
        setImage.hidden = NO;
      
    }else
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            setImage.alpha=0.0;
            setImage.hidden = YES;
            
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
