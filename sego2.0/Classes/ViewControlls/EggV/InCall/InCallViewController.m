//
//  InCallViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InCallViewController.h"
#import <CallKit/CXCallObserver.h>
#import "AppDelegate.h"

@interface InCallViewController ()
{
    NSString * strHZ;
    
    // btn数组
    NSArray * btnList;
    //方向键
    NSArray * DriArr;
    //文本
    NSArray * LabeArr;
    //
    UIButton * pullBtn;
    
    
    
    
    
    
    
}

//电话
@property (nonatomic, strong) CTCallCenter * center;
@property (nonatomic, assign) SephoneCall *call;
@end


@implementation InCallViewController

@synthesize call;
@synthesize videoView;
@synthesize HZbtn;
@synthesize btnBack;
@synthesize flowUI;
@synthesize penSl;
@synthesize pesnBack;
@synthesize FiveView;







- (void)viewDidLoad {
    [super viewDidLoad];
    strHZ = @"1";
   
    

    self.center = [[CTCallCenter alloc] init];
   __weak InCallViewController *weakSelf = self;
    self.center.callEventHandler = ^(CTCall * call)
    {
        //TODO:检测到来电后的处理
        [weakSelf performSelectorOnMainThread:@selector(RefreshCellForLiveId)
                                   withObject:nil
                                waitUntilDone:NO];
        
        
    };
    
    
    // 后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification
                                              object:[UIApplication sharedApplication]];
    
   
   // [flowUI startAnimating];
    [self callStream:call];
    

    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    
    
}

- (void)callStream:(SephoneCall *)calls
{
    
    if (calls != NULL) {
        
        sephone_call_set_next_video_frame_decoded_callback(calls, hideSpinner, (__bridge void *)(self));
    }
    
    
    if (![SephoneManager hasCall:calls]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    
}
// 用户体验设置

- (void)hideSpinnerIndicator:(SephoneCall *)call {
    
    [flowUI stopAnimating];
    
}


static void hideSpinner(SephoneCall *call, void *user_data) {
    InCallViewController *thiz = (__bridge InCallViewController *)user_data;
    [thiz hideSpinnerIndicator:call];
    
}



// 初始化UI控件
- (void)setupView
{
    [super setupView];
    
   // [UIApplication sharedApplication].statusBarHidden = YES;

    // 视频界面
    videoView =[UIView new];
    videoView.backgroundColor =[UIColor redColor];
    [self.view addSubview:videoView];
    
    
    // 等待状态
    flowUI  =[UIActivityIndicatorView new];
    flowUI.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [videoView addSubview:flowUI];
    
    [flowUI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.center.mas_equalTo(videoView.center);
        
    }];
    
  
    
    
    // 返回按钮
    btnBack =[UIButton new];
    [btnBack addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"back_egg"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
    
    // 横竖屏
    
    HZbtn = [UIButton new];
    [HZbtn setImage:[UIImage imageNamed:@"hzbtn"] forState:UIControlStateNormal];
    [HZbtn addTarget:self action:@selector(HZView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:HZbtn];
    
    // 激光笔背景
    pesnBack =[UIImageView new];
    pesnBack.userInteractionEnabled = YES;
    pesnBack.image =[UIImage imageNamed:@"penPlace"];
    [self.view addSubview:pesnBack];
    
    
    
    // 滑动按钮 激光
    penSl =[UISlider new];
    penSl.minimumValue = 0.5;
    penSl.maximumValue = 2;
    penSl.userInteractionEnabled = YES;
    [penSl setThumbImage:[UIImage imageNamed:@"penNormal"] forState:UIControlStateNormal];
    [penSl setThumbImage:[UIImage imageNamed:@"penSelect"] forState:UIControlStateHighlighted];

    [ penSl addTarget:self action:@selector(penClicKbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [pesnBack addSubview:penSl];
    
    // 5个按钮背景
    FiveView =[UIImageView new];
    FiveView.userInteractionEnabled = YES;
    [self.view addSubview:FiveView];
    
    
    // 方向键
    UIButton * topBtn   =[UIButton new];
    UIButton * downBtn =[UIButton new] ;
    UIButton * leftBtn  =[UIButton new];
    UIButton * rightBtn = [UIButton new];
    UIButton * RtopBtn = [UIButton new];
    UIButton * RdownBtn =[UIButton new];
    
    [topBtn addTarget:self action:@selector(topClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn addTarget:self action:@selector(downClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(leftClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [RtopBtn addTarget:self action:@selector(RtopClickSt:) forControlEvents:UIControlEventTouchUpInside];
    [RdownBtn addTarget:self action:@selector(RdownClickSt:) forControlEvents:UIControlEventTouchUpInside];
    
    DriArr =@[topBtn,downBtn,leftBtn,rightBtn,RtopBtn,RdownBtn];
    for (NSInteger i =0; i<6; i++) {
        [self.view addSubview:DriArr[i]];
        
        
    }
    // 5个文本字体
      UILabel * label1 =[UILabel new];
      UILabel * label2 =[UILabel new];
      UILabel * label3 =[UILabel new];
      UILabel * label4 =[UILabel new];
      UILabel * label5 =[UILabel new];
       LabeArr =@[label1,label2,label3,label4,label5];
    for (NSInteger  i=0; i<5; i++) {
        
        
        [FiveView addSubview:LabeArr[i]];
        
    }
    
    // 推拉
    pullBtn =[UIButton new];
    pullBtn.userInteractionEnabled = YES;
    pullBtn.hidden = YES;
    [pullBtn setImage:[UIImage imageNamed:@"take_off"] forState:UIControlStateNormal];
    [pullBtn setImage:[UIImage imageNamed:@"take_on"] forState:UIControlStateSelected];
    [pullBtn addTarget:self action:@selector(pullBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [FiveView addSubview:pullBtn];
    
    
    // 小圆
    UIImageView * SmallImage =[UIImageView new];
    SmallImage.tag = 10000001;
    SmallImage.image =[UIImage imageNamed:@"small"];
    [self.view addSubview:SmallImage];
    
    
    
    
    
    // 5个按钮
    UIButton * voicebtn =[UIButton new];
    UIButton * lightbtn =[UIButton new];
    UIButton * foodbtn =[UIButton new];
    UIButton * rollbtn =[UIButton new];
    UIButton * takephoto =[UIButton new];
    
    [voicebtn addTarget:self action:@selector(VocieClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [lightbtn addTarget:self action:@selector(LightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [foodbtn addTarget:self action:@selector(FoodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [rollbtn addTarget:self action:@selector(RollClick:) forControlEvents:UIControlEventTouchUpInside];
    [takephoto addTarget:self action:@selector(PhotoClick:) forControlEvents:UIControlEventTouchUpInside];

    btnList =@[voicebtn,lightbtn,foodbtn,rollbtn,takephoto];
    for (NSInteger i =0; i<5; i++) {
       
        [FiveView addSubview:btnList[i]];
    }
    
    [self VviewUpdatRemove:NO];
    
    
    

    
   
    
    

    
    
    
}


// 横竖屏切换

- (void)HZView:(UIButton *)sender
{
    
    
    if ([strHZ isEqualToString:@"1"]) {
        
        [self rightAction];
        [self HviewUpdateView];
    }else
    {
        [self leftAction];
        [self VviewUpdatRemove:YES];
        
    }

    
}


#pragma  mark ----------严肃的分割线------------------------------------------------

/**
 *   横屏的切换 约束更新
 */
- (void)HviewUpdateView
{
    pullBtn.hidden = NO;
    
    

    
     videoView.transform = CGAffineTransformScale(self.videoView.transform, 1.32, 1.04);
    
    // 视频界面
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(0);
        
    }];
    
    
    //横竖屏按钮
    [HZbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    
    
    // 激光笔背景
    [pesnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(@0);
        
    
    }];
    
    penSl.hidden = YES;
    [penSl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(@0);

    }];
    FiveView.image =[UIImage imageNamed:@"halfAp"];
    FiveView.backgroundColor =[UIColor clearColor];
    FiveView.layer.borderWidth =0;
    
    // 5个按钮背景
    [FiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(83);
        make.top.bottom.right.mas_equalTo(0);
     

    }];

    // 5个按钮
    NSArray * imageListS=@[@"Lclick_light",@"Lclick_rool",@"Lclick_food",@"Lclick_photo",@"takep_on"];
    NSArray * imageListN=@[@"Lnormal_light",@"Lnormal_rool",@"Lnormal_food",@"Lnormal_photo",@"takep_off"];
    for (NSInteger i =0; i<5; i++) {
        
        [btnList[i] setImage:[UIImage imageNamed:imageListN[i]] forState:UIControlStateNormal];
        [btnList[i] setImage:[UIImage imageNamed:imageListS[i]] forState:UIControlStateSelected];
    }
    
   
   
    
    

    // 推拉
    [pullBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(FiveView.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 22));
        make.bottom.equalTo(self.view.mas_bottom).offset(-187);
        
        
        
        
    }];
    
    NSArray * arrText;
    arrText = @[@"开灯",@"喂食",@"投食",@"抓拍",@"声音"];
    for (NSInteger  i=0; i<5; i++) {
        UILabel * newLable =LabeArr[i];
        newLable.text =arrText[i];
        newLable.font =[UIFont systemFontOfSize:12];
        newLable.textColor =[UIColor whiteColor];
        
        
    }

    
    // 文本字体
    [LabeArr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(FiveView.mas_centerX).offset(8);
        make.height.mas_equalTo(12);
        
        
    }];
    
    [LabeArr mas_distributeViewsAlongAxis:MASAxisTypeVertical
                         withFixedSpacing:75
                              leadSpacing:105
                              tailSpacing:-69];
    
    NSArray * imageList =@[@"top_egg",@"down_egg",@"left_egg",@"right_egg",@"L_top",@"L_down"];
    
    for (NSInteger i =0; i<6; i++) {
        [DriArr[i] setImage:[UIImage imageNamed:imageList[i]] forState:UIControlStateNormal];
        
    }

  
    [btnList mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FiveView.mas_left).offset(28);
        make.right.equalTo(self.view.mas_right).offset(-13);
        

    }];
    
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeVertical
                        withFixedSpacing:40
                             leadSpacing:59
                             tailSpacing:-52];
    
    
    
    
    //方向按钮
    
    [DriArr[0] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-124);
        make.size.mas_equalTo(CGSizeMake(143*0.75,79*0.75));
        make.left.mas_equalTo(55);
        
        
        
        
    }];
    
    
    [DriArr[1] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-32);
        make.size.mas_equalTo(CGSizeMake(143*0.75,79*0.75));
        make.left.mas_equalTo(55);
        
        
        
        
    }];
    //左
    [DriArr[2] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-54);
        make.size.mas_equalTo(CGSizeMake(79*0.75,143*0.75));
        make.left.mas_equalTo(33);
        
        
        
        
    }];
    
    [DriArr[3] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-54);
        make.size.mas_equalTo(CGSizeMake(79*0.75,143*0.75));
        make.left.mas_equalTo(125);
        
        
        
        
        
    }];
    
    [DriArr[4] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-110);
        make.right.mas_equalTo(-393);
        make.height.mas_equalTo(78);
        make.width.mas_equalTo(53);
        
        
        
        
    }];
    
    [DriArr[5] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(videoView.mas_bottom).offset(-32);
        make.right.mas_equalTo(-393);
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(78);
        

        
    }];

    
    
    
}


/**
 *  竖屏的切换 约束还原
 */
- (void)VviewUpdatRemove:(BOOL)isTran
{

    videoView.transform = CGAffineTransformIdentity;
    penSl.hidden = NO;
    FiveView.backgroundColor =[UIColor whiteColor];
    FiveView.layer.borderWidth =0.6;
    FiveView.image =[UIImage imageNamed:@""];
    FiveView.layer.borderColor =GRAY_COLOR.CGColor;
    pullBtn.hidden = YES;
    
    // 视频界面
    [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view);
        make.top.mas_equalTo(-8);
        make.height.mas_equalTo(300);
        
    }];
    
    // 返回按钮
    [btnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(15, 25));
        
    }];
    
    //横竖屏按钮
    [HZbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.view.mas_top).offset(255);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    
    // 激光笔背景
    [pesnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(videoView.mas_bottom).offset(0);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(39);
        
        
    }];
    
    
    [penSl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(pesnBack.mas_centerY);
        make.height.mas_equalTo(31);
        make.width.equalTo(self.view);
        
    }];
    
    // 5个按钮背景
    [FiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(pesnBack.mas_bottom).offset(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(0);
        
    
    }];
    
    
    NSArray * imageListS=@[@"voice_on",@"light_on",@"food_on",@"rool_on",@"takep_on"];
    NSArray * imageListN=@[@"voice_off",@"light_off",@"food_off",@"rool_off",@"takep_off"];
    for (NSInteger i =0; i<5; i++) {
        
        [btnList[i] setImage:[UIImage imageNamed:imageListS[i]] forState:UIControlStateNormal];
        [btnList[i] setImage:[UIImage imageNamed:imageListN[i]] forState:UIControlStateSelected];
    }

    NSArray * arrText;
    arrText = @[@"声音",@"开灯",@"喂食",@"投食",@"抓拍"];
    for (NSInteger  i=0; i<5; i++) {
        UILabel * newLable =LabeArr[i];
        newLable.text =arrText[i];
        newLable.font  =[UIFont systemFontOfSize:12];
        newLable.textColor =[UIColor grayColor];
        
        
    }
    // 5个lable
    [LabeArr mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(12);
        make.bottom.equalTo(FiveView.mas_bottom).offset(-6);
        
        
        
        
    }];
    [LabeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:50 leadSpacing:20 tailSpacing:17];
 
    
    
    NSArray * imageList =@[@"top1",@"down1",@"left1",@"right1",@"Ltopbtn",@"Ldownbtn"];
   
    for (NSInteger i =0; i<6; i++) {
         [DriArr[i] setImage:[UIImage imageNamed:imageList[i]] forState:UIControlStateNormal];
        
    }

    
    // 5个按钮
    
    [btnList mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(36);
//        make.centerY.equalTo(FiveView.mas_centerY);
        make.top.equalTo(FiveView.mas_top).offset(12);
        
        
        
        
    }];
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:41 leadSpacing:15 tailSpacing:15];
   

    
    //方向按钮
    
    [DriArr[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(26);
        make.size.mas_equalTo(CGSizeMake(287/2,79));
        make.left.mas_equalTo(56);
        
        
        
        
    }];
    

    [DriArr[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(146);
        make.size.mas_equalTo(CGSizeMake(287/2,79));
        make.left.mas_equalTo(56);
        
        
        
        
    }];
    //左
    [DriArr[2] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(54);
        make.size.mas_equalTo(CGSizeMake(79,287/2));
        make.left.mas_equalTo(28);
        
        
        
        
    }];
    
    [DriArr[3] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(54);
        make.size.mas_equalTo(CGSizeMake(79,287/2));
        make.left.mas_equalTo(148);
        
        
        
        
    }];
    
    [DriArr[4] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(26);
        make.right.mas_equalTo(-33);
        make.size.mas_equalTo(CGSizeMake(72, 101));
        
        
        
    }];
    
    [DriArr[5] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FiveView.mas_bottom).offset(120);
        make.right.mas_equalTo(-33);
        make.size.mas_equalTo(CGSizeMake(72, 101));

        
    }];
    
    
    // 小圆
    
    UIImageView * imageS =[self.view viewWithTag:10000001];
    [imageS mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(FiveView.mas_bottom).offset(104);
        make.left.mas_equalTo(105);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        
    }];
    
    
    
    
}




#pragma mark  buttonMethod _________________各点击事件__________________________


//弹出 收回

- (void)pullBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        // 移动view
        [UIView animateWithDuration:0.5 animations:^{
            FiveView.center = CGPointMake(687, FiveView.center.y);
        } completion:^(BOOL finished) {
            //平移结束
            
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            FiveView.center = CGPointMake(625.5, FiveView.center.y);
        } completion:^(BOOL finished) {
            //平移结束
            
        }];

        
    }
   
    
    
}

// 返回
- (void)backBtn:(UIButton * )sender
{
    [self leftAction];
    [SephoneManager terminateCurrentCallOrConference];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
// 激光笔点击
-(void)penClicKbtn:(UISlider *)sender
{
    
    FuckLog(@"121241");
    
    
}

// 声音
- (void)VocieClick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    
}
//开灯
- (void)LightClick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;

}

//喂食
- (void)FoodClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    
}
//投食
- (void)RollClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    
}
//抓拍
- (void)PhotoClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    
}


/**
 *  上下左右 点击事件 1.单击 2.释放
 */

//*****************************点击**********************************
- (void)topClickSt:(UIButton *)sender
{
    
    
}

- (void)downClickSt:(UIButton *)sender
{
    
    
}

- (void)leftClickSt:(UIButton *)sender
{
    
    
}
- (void)rightClickSt:(UIButton *)sender
{
    
    
}
- (void)RtopClickSt:(UIButton *)sender
{
    
    
}
- (void)RdownClickSt:(UIButton *)sender
{
    
    
}

//*****************************释放**********************************

- (void)topClickFr:(UIButton *)sender
{
    
    
}


#pragma mark  buttonMethod _____________________各点击事件结尾____________________





#pragma  mark ----------严肃的结尾线------------------------------------------------










#pragma mark -  横竖屏method **************************


- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)leftAction
{
    strHZ = @"1";
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)rightAction
{
    strHZ =@"2";
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
  
    // Update on show
    SephoneCall *call_ = sephone_core_get_current_call([SephoneManager getLc]);
    SephoneCallState state = (call != NULL) ? sephone_call_get_state(call_) : 0;
    [self callUpdate:call_ state:state animated:FALSE];

 
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
   // [UIApplication sharedApplication].statusBarHidden = NO;
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
