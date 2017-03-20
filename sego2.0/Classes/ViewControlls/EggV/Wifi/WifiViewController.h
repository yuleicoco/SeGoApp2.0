//
//  WifiViewController.h
//  sego2.0
//
//  Created by yulei on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BaseViewController.h"

@interface WifiViewController : BaseViewController
@property (nonatomic,strong)NSArray * listArr;
@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic,strong)NSString * strDevice;
@property (nonatomic,assign)BOOL is_Offline;



@end
