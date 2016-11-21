//
//  InCallViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InCallViewController.h"
#import <CallKit/CXCallObserver.h>

@interface InCallViewController ()

//电话
@property (nonatomic, strong) CTCallCenter * center;
@property (nonatomic, assign) SephoneCall *call;
@end


@implementation InCallViewController

@synthesize call;
@synthesize videoView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.center = [[CTCallCenter alloc] init];
//  __weak InCallViewController *weakSelf = self;
//    self.center.callEventHandler = ^(CTCall * call)
//    {
//        //TODO:检测到来电后的处理
//        [weakSelf performSelectorOnMainThread:@selector(RefreshCellForLiveId)
//                                   withObject:nil
//                                waitUntilDone:NO];
//        
//        
//    };
    
    
    // 后台
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification
//                                              object:[UIApplication sharedApplication]];
    
    [self callStream:call];

    
    
}

- (void)callStream:(SephoneCall *)calls
{
    
    if (calls != NULL) {
        
//        sephone_call_set_next_video_frame_decoded_callback(calls, hideSpinner, (__bridge void *)(self));
    }
    
    
    if (![SephoneManager hasCall:calls]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    
}




- (void)initUserface
{
    
    UIButton * btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 40, 100, 50)];
    [btn setTitle:@"横屏" forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor redColor];
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UIButton * btn1 =[[UIButton alloc]initWithFrame:CGRectMake(0, 150, 100, 50)];
    [btn1 setTitle:@"竖屏" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor =[UIColor redColor];
    [self.view addSubview:btn1];
    
    
}

- (void)setupView
{
    [super setupView];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // 视频界面
    videoView =[UIView new];
    videoView.backgroundColor =[UIColor redColor];
    [self.view addSubview:videoView];
    
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view);
        make.top.mas_equalTo(-8);
        make.height.mas_equalTo(300);
        
    }];
    
    // 返回按钮
    UIButton * btnBack =[UIButton new];
    [btnBack addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
    
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    
    // 横竖屏
    
    UIButton * HZbtn = [UIButton new];
    [HZbtn setImage:[UIImage imageNamed:@"hzbtn"] forState:UIControlStateNormal];
    [HZbtn addTarget:self action:@selector(HZView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:HZbtn];
    
    [HZbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(videoView.mas_right).offset(-12);
        make.bottom.equalTo(videoView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    
    
    
    
    
}


// 横竖屏切换

- (void)HZView:(UIButton *)sender
{
    
    videoView.transform=CGAffineTransformMakeRotation(M_PI/2);
   
    [videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(self.view.height);
        
        
        
    }];
    
    
    
//    videoView.frame =CGRectMake(0, 0, 667, 375);
//    videoView.center = self.view.center;
    
    
    
    NSLog(@"1232");
    [self.view layoutIfNeeded];
    
}

- (void)backBtn:(UIButton * )sender
{
    
     [SephoneManager terminateCurrentCallOrConference];
     [self dismissViewControllerAnimated:YES completion:nil];

    
}






#pragma mark -  横竖屏method **************************


- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)leftAction
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)rightAction
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}


#pragma mark -  横竖屏method **************************



- (void)setCall:(SephoneCall *)acall
{
    
    call = acall;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdateEvent:) name:kSephoneCallUpdate object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    // Update on show
    SephoneCall *call_ = sephone_core_get_current_call([SephoneManager getLc]);
    SephoneCallState state = (call != NULL) ? sephone_call_get_state(call_) : 0;
    [self callUpdate:call_ state:state animated:FALSE];
    
    
   // videoView.transform = CGAffineTransformScale(self.videoView.transform, 1.2, 1.0);
    // 视频
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)videoView);
    
    
    
    
}



// 通话监听

- (void)callUpdate:(SephoneCall *)call_ state:(SephoneCallState)state animated:(BOOL)animated {
    
    if (call_ == NULL) {
        return;
    }
    
    switch (state) {
            // 通话结束或出错时退出界面。
        case SephoneCallEnd:
        case SephoneCallError: {
            call = NULL;
            NSLog(@"超时返回");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }

    
    
}


- (void)callUpdateEvent:(NSNotification *)notif {
    SephoneCall *call_ = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    [self callUpdate:call_ state:state animated:TRUE];
}



- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    // Clear windows
    //  必须清除，否则会因为arc导致再次视频通话时crash。
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)NULL);
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
