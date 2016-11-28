//
//  BindingViewController.h
//  sego2.0
//
//  Created by yulei on 16/11/15.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

NSString * const TERMID_DEVICNUMER =@"termid";

// 设备号配置项
NSString *const PREF_DEVICE_NUMBER = @"deviceNumber";
// wifi是否已设置配置项
NSString *const PREF_WIFI_CONFIGURED = @"wifiConfigured";


// sego蓝牙配置服务常量
extern NSString *const SEGOPASS_BLE_DEVICE_NAME;
extern NSString *const CONFIG_SERVICE_UUID;
extern NSString *const REQUEST_CHARACTERISTIC_UUID;
extern NSString *const RESULT_CHARACTERISTIC_UUID;
extern NSString *const SEGOEGG_PREFIX;

@interface BindingViewController : BaseViewController<CBPeripheralManagerDelegate>


@property (nonatomic,strong) UITextField * deviceTF;
@property (nonatomic,strong)UITextField * incodeTF;
@property (nonatomic,strong)UIButton * btnBind;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong)ShowWarView * ShowView;




@end
