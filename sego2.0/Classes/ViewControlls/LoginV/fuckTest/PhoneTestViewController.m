//
//  PhoneTestViewController.m
//  sego2.0
//
//  Created by czx on 2017/1/18.
//  Copyright © 2017年 yulei. All rights reserved.
//

#import "PhoneTestViewController.h"
#import "SephoneManager.h"
#import "AIncallViewController.h"

@interface PhoneTestViewController ()
{

    UITextField * _numberTextfield;
    UIButton * _loginBtn;
}
@end

@implementation PhoneTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _numberTextfield = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 200, 30)];
    _numberTextfield.tintColor = [UIColor lightGrayColor];
    // _numberTextfield.backgroundColor = [UIColor blueColor];
    _numberTextfield.layer.borderWidth = 1;
    _numberTextfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_numberTextfield];
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, 150, 100, 30)];
    _loginBtn.backgroundColor = [UIColor blackColor];
    [_loginBtn setTitle:@"进去" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(gogogo) forControlEvents:UIControlEventTouchUpInside];
    
    //sip 上线
    [SephoneManager addProxyConfig:@"15800000436" password:@"140571" domain:@"www.segosip001.cn"];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
                    return ;
                    
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
    
    
    UIButton * bangdingBtn = [[UIButton alloc]initWithFrame:CGRectMake(100,300 , 100, 100)];
    [bangdingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bangdingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bangdingBtn addTarget:self action:@selector(bangdingding) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bangdingBtn];
    
}
-(void)bangdingding{
  //  bangdingViewController * bangdingVc = [[bangdingViewController alloc]init];
   // [self presentViewController:bangdingVc animated:NO completion:nil];
    
    
}



-(void)gogogo{
    
    //button点击事件，这儿传对方的号码
    [self sipCall:_numberTextfield.text sipName:nil];
}



- (void)sipCall:(NSString*)dialerNumber sipName:(NSString *)sipName
{
    
    NSString *  displayName  =nil;
  //  [[SephoneManager instance]call:dialerNumber displayName:displayName transfer:FALSE highDefinition:FALSE];
    
    [[SephoneManager instance]call:displayName displayName:displayName transfer:FALSE];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate11:) name:kSephoneCallUpdate object:nil];
    
     //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate11:) name:kSephoneRegistrationUpdate object:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
    
}


// 注册消息处理
- (void)registrationUpdate11:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    SephoneProxyConfig *cfg = [[notif.userInfo objectForKey:@"cfg"] pointerValue];
    // Only report bad credential issue
    
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
- (void)callUpdate11:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    
    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功才能转到视频的界面
            AIncallViewController * inallVc = [[AIncallViewController alloc]init];
            [inallVc setCall:call];
            
            [self presentViewController:inallVc animated:YES completion:nil];
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


@end
