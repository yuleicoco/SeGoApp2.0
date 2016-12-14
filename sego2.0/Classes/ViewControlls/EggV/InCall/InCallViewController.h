//
//  InCallViewController.h
//  sego2.0
//
//  Created by yulei on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "BindingViewController.h"


@interface InCallViewController : BaseViewController

- (void)setCall:(SephoneCall *)acall;

// 别人
@property (nonatomic,strong)UIView * videoView;
//横竖屏
@property (nonatomic,strong)UIButton * HZbtn;
// 返回
@property (nonatomic,strong)UIButton * btnBack;
//等待
@property (nonatomic,strong)UIActivityIndicatorView * flowUI;
//激光笔
@property (nonatomic,strong)UISlider * penSl;
// 激光笔背景
@property (nonatomic,strong)UIImageView * pesnBack;
// 5个button背景
@property (nonatomic,strong)UIImageView * FiveView;

@property (nonatomic,strong)UIImageView * pointTouch;

@property (nonatomic,strong)NSString * isTurmNum;






@end
