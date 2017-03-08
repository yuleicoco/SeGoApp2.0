//
//  IncallViewController.m
//  Test_sephone
//
//  Created by czx on 16/8/4.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AIncallViewController.h"
#import "HWWeakTimer.h"
#import <CallKit/CXCallObserver.h>
#import "AFHttpClient+DeviceUseMember.h"

#define TARGET 60
#define DELTE_SCALE 16
#define MAX_MOVE 90


@interface AIncallViewController (){
    UIButton * top;
    UIButton * left;
    UIButton * down;
    UIButton * right;

    NSTimer * moveTimer;
     NSString * isEnlable;
}
@property (nonatomic, assign) SephoneCall *call;

@end


@implementation AIncallViewController
@synthesize call;
@synthesize otherView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    backButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(goBackk) forControlEvents:UIControlEventTouchUpInside];
    
    top = [[UIButton alloc]initWithFrame:CGRectMake(130, 360, 150, 40)];
    top.backgroundColor = [UIColor blackColor];
    //点击
    [top addTarget:self action:@selector(topbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    //长按
    [top addTarget:self action:@selector(topDownTOuch) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:top];
    
    
    left = [[UIButton alloc]initWithFrame:CGRectMake(90, 400, 40, 150)];
    left.backgroundColor = [UIColor redColor];
    [left addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [left addTarget:self action:@selector(leftDownTouch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:left];
    
    
    down = [[UIButton alloc]initWithFrame:CGRectMake(130, 550, 150, 40)];
    down.backgroundColor = [UIColor greenColor];
    [down addTarget:self action:@selector(downButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [down addTarget:self action:@selector(downDownTouch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:down];
    
    right = [[UIButton alloc]initWithFrame:CGRectMake(280, 400, 40, 150)];
    right.backgroundColor = [UIColor whiteColor];
    [right addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [right addTarget:self action:@selector(rightDownTouch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:right];
    
}

-(void)topDownTOuch{

        [self MoveRobot:@"4"];
}


-(void)leftDownTouch{

        [self MoveRobot:@"2"];

}

-(void)downDownTouch{
        [self MoveRobot:@"3"];

}

-(void)rightDownTouch{
        [self MoveRobot:@"1"];
    
}


-(void)MoveRobot:(NSString *)str
{
     NSInteger i = [str integerValue];
    
    if ([isEnlable isEqualToString:@"2"]
        || [AppUtil isBlankString:isEnlable]) {
        
        switch (i) {
            case 1:
                right.userInteractionEnabled = YES;
                left.userInteractionEnabled = NO;
               top.userInteractionEnabled = NO;
               down.userInteractionEnabled = NO;
            
                break;
                
            case 2:
                right.userInteractionEnabled = NO;
                left.userInteractionEnabled = YES;
                top.userInteractionEnabled = NO;
                down.userInteractionEnabled = NO;
                
                break;
            case 3:
                right.userInteractionEnabled = NO;
                left.userInteractionEnabled = NO;
                top.userInteractionEnabled = NO;
                down.userInteractionEnabled = YES;

                
                break;
            case 4:
                
                right.userInteractionEnabled = NO;
                left.userInteractionEnabled = NO;
                top.userInteractionEnabled = YES;
                down.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }

        moveTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0*0.2 block:^(id userInfo) {
            [self sendInfomation:str];
        } userInfo:@"Fire" repeats:YES];
        [moveTimer fire];
    }else
    {
        
        return;
    }
    

}

- (void)sendInfomation:(NSString *)sender
{
    NSLog(@"=======%@",isEnlable);
    
    NSString * msg =[NSString stringWithFormat:@"control_servo,0,0,1,%d,200",[sender intValue]];
    [self sendMessage:msg];
    //
    isEnlable =@"1";
}


-(void) sendMessage:(NSString *)mess{
    const char * message =[mess UTF8String];
    sephone_core_send_user_message([SephoneManager getLc], message);
    
}





-(void)topbuttonTouch{
    
    [self overTime];
}

-(void)leftButtonTouch{
    [self overTime];

}
-(void)downButtonTouch{
    [self overTime];
}

-(void)rightButtonTouch{
    [self overTime];

}

- (void)overTime
{
    NSLog(@"结束");
    isEnlable =@"2";
    [moveTimer invalidate];
    top.userInteractionEnabled = YES;
    left.userInteractionEnabled = YES;
    down.userInteractionEnabled = YES;
    right.userInteractionEnabled = YES;
    
    
}





-(void)goBackk{
    //要结束视频
    [SephoneManager terminateCurrentCallOrConference];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //这是返回

}




- (void)setCall:(SephoneCall *)acall {
    call = acall;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdateEvent:) name:kSephoneCallUpdate object:nil];
    
    // Update on show
    SephoneCall *call_ = sephone_core_get_current_call([SephoneManager getLc]);
    SephoneCallState state = (call != NULL) ? sephone_call_get_state(call_) : 0;
    [self callUpdate:call_ state:state animated:FALSE];
    
    otherView.transform = CGAffineTransformScale(self.otherView.transform, 1.2, 1.0);
    // 视频 
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)otherView);
   // [self.ActView startAnimating];
    // 创建定时器更新通话时间 (以及创建时间显示)

}

-(void)viewDidDisappear:(BOOL)animated{
    //  必须清除，否则会因为arc导致再次视频通话时crash。
    sephone_core_set_native_video_window_id([SephoneManager getLc], (unsigned long)NULL);
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
}



// 通话监听

- (void)callUpdate:(SephoneCall *)call_ state:(SephoneCallState)state animated:(BOOL)animated {

    // Fake call update
    if (call_ == NULL) {
        return;
    }
    
    switch (state) {
            // 通话结束或出错时退出界面。
        case SephoneCallEnd:
        case SephoneCallError: {
            call = NULL;
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


- (void)callStream:(SephoneCall *)calls
{
    
    if (calls != NULL) {
        
    //sephone_call_set_next_video_frame_decoded_callback(calls, hideSpinner, (__bridge void *)(self));
    }
    //
    if (![SephoneManager hasCall:calls]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}


@end
