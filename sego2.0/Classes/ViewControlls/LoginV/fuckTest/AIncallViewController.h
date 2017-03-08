//
//  IncallViewController.h
//  Test_sephone
//
//  Created by czx on 16/8/4.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SephoneManager.h"
@interface AIncallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *otherView;
//这儿要传一个acll的状态过来
- (void)setCall:(SephoneCall *)acall;
@end
