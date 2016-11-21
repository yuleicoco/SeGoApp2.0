//
//  InCallViewController.h
//  sego2.0
//
//  Created by yulei on 16/11/14.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"

@interface InCallViewController : BaseViewController

- (void)setCall:(SephoneCall *)acall;

// 别人
@property (nonatomic,strong)UIView * videoView;

@end
