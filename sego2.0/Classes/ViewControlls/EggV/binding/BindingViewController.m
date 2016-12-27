//
//  BindingViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/15.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "BindingViewController.h"
#import "Reachability.h"
#import "WifiViewController.h"
#import "AFHttpClient+AddDeviceInformation.h"
#import "AFHttpClient+RemoveDevice.h"


NSString * const TERMID_DEVICNUMER =@"termid";

// 设备号配置项
NSString *const PREF_DEVICE_NUMBER = @"deviceNumber";
// wifi是否已设置配置项
NSString *const PREF_WIFI_CONFIGURED = @"wifiConfigured";


// sego配置设备名
NSString *const SEGOPASS_BLE_DEVICE_NAME = @"segopass";
// 蓝牙配置服务UUID
NSString *const CONFIG_SERVICE_UUID = @"1f0b6a86-0dd6-440f-8aa6-8d11f3486af0";
// 请求特征
NSString *const REQUEST_CHARACTERISTIC_UUID = @"a2e8d661-0bba-4a61-91e8-dd7ff3d55b27";
// 结果特征
NSString *const RESULT_CHARACTERISTIC_UUID = @"aa78471c-257b-49f6-93a1-8686cadb1fe6";
// 正确结果设备号前缀
NSString *const SEGOEGG_PREFIX = @"segoegg";

@interface BindingViewController ()<ShowDelegate>
{
     CBPeripheralManager *peripheralManager;
    int serviceNum;   // 添加成功的service数量
    BOOL isAccecptOk; // 是否接收结果成功
    BOOL isOpenPerOK; // 判断是否从机开始广播
    NSString * strTT;
    NSString * strYY;
    NSTimer * timerCheck;
    NSInteger  timerEnd;
    
    

    }

@end


@implementation BindingViewController

@synthesize btnBind;
@synthesize deviceTF;
@synthesize incodeTF;
@synthesize ShowView;
@synthesize hud;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabBinding_title",nil)];
    self.view.backgroundColor =GRAY_COLOR;
    isOpenPerOK = NO;
    
   
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 创建蓝牙从机。
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    serviceNum = 0;
    isAccecptOk = NO;
    
    
    
}

/**
 *  检查网络状态
 *
 *  @return 是否联网
 */
- (BOOL)checkConnectionAvailable {
    BOOL hasNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
            // wifi网络可用。
        case ReachableViaWiFi:
            hasNetwork = YES;
            break;
            // 网络不可用。
        case NotReachable:
            hasNetwork = NO;
            [self showWarningTip:NSLocalizedString(@"INFO_NetNoReachable", nil)];
            break;
            // 3G网可用。
        case ReachableViaWWAN:
            hasNetwork = YES;
            [self showWarningTip:NSLocalizedString(@"INFO_ReachableViaWWAN", nil)];
            break;
    }
    return hasNetwork;
}





- (void)setupView
{
    
    NSString * strBing =[Defaluts objectForKey:PREF_DEVICE_NUMBER];
    NSString * strLogin =[AccountManager sharedAccountManager].loginModel.deviceno;
    
   NSString * st1 =[Defaluts objectForKey:@"incodeNum"];
   NSString * st2 =[AccountManager sharedAccountManager].loginModel.termid;
    
    
    
    strTT = strBing.length>strLogin.length?strBing:strLogin;
    strYY = st1.length>st2.length?st1:st2;
    
    
    
    

    
    [super setupView];
    
    UIView * devNum =[UIView new];
    UIView * inCode =[UIView new];
    devNum.backgroundColor = [UIColor whiteColor];
    inCode.backgroundColor = [UIColor whiteColor];
    devNum.layer.cornerRadius =4;
    devNum.layer.borderWidth =0.4;
    devNum.layer.borderColor =GRAY_COLOR.CGColor;
    inCode.layer.cornerRadius =4;
    inCode.layer.borderWidth =0.4;
    inCode.layer.borderColor = GRAY_COLOR.CGColor;
    [self.view addSubview:devNum];
    [self.view addSubview:inCode];
    
    [devNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(inCode);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(8);
    }];
    
    [inCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(66);

    }];

    
    btnBind =[UIButton new];
    btnBind.layer.cornerRadius = 4;
    btnBind.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    if ([AppUtil isBlankString:strTT]) {
         [btnBind setTitle:@"绑定设备" forState:UIControlStateNormal];
         btnBind.backgroundColor = LIGHT_GRAYdcdc_COLOR;
         btnBind.enabled = FALSE;
    }else
    {
         [btnBind setTitle:@"解除绑定" forState:UIControlStateNormal];
         btnBind.enabled = TRUE;
        btnBind.backgroundColor = GREEN_COLOR;
        
    }
   
    [btnBind addTarget:self action:@selector(BindTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnBind];
    [btnBind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@55);
        make.top.equalTo(inCode.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.width.equalTo(inCode);
        
    }];
    
    UILabel * deveLB= [UILabel new];
    UILabel * incoLB =[UILabel new];
    deveLB.text =@"设备号:";
    deveLB.font = [UIFont systemFontOfSize:18];
    incoLB.text =@"接入码:";
    incoLB.font =[UIFont systemFontOfSize:18];
    
    [devNum addSubview:deveLB];
    [inCode addSubview:incoLB];
    
    [deveLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devNum.mas_left).with.offset(12);
        make.centerY.equalTo(devNum.mas_centerY);
        
        
        
    }];
    
    [incoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inCode).offset(12);
        make.centerY.equalTo(inCode.mas_centerY);
        
    }];
    
    
    deviceTF =[UITextField new];
    incodeTF =[UITextField new];
    
    
   
    if ([AppUtil isBlankString:strTT]) {
        deviceTF.text =@"";
        incodeTF.text =@"";
    }else
    {
        deviceTF.text =strTT;
        incodeTF.text =strYY;
        

        
    }
    
    incodeTF.secureTextEntry = TRUE;
    deviceTF.enabled = NO;
    incodeTF.enabled = NO;
    
    
    deviceTF.borderStyle = UITextBorderStyleNone;
    incodeTF.borderStyle =UITextBorderStyleNone;
    deviceTF.font = [UIFont systemFontOfSize:18];
    incodeTF.font = [UIFont systemFontOfSize:18];
    [devNum addSubview:deviceTF];
    [inCode addSubview:incodeTF];
    
    [deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deveLB.mas_right).offset(13);
        make.centerY.equalTo(devNum.mas_centerY);

    }];
    
    [incodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.equalTo(incoLB.mas_right).with.offset(13);
         make.centerY.equalTo(inCode.mas_centerY);

    }];
    
    
    
    
    
    
    
   
    
}




/**
 *  绑定设备
 */
- (void)BindTouch:(UIButton *)sender
{
    
    
    // 检查网络是否可用。
    BOOL hasNetwork = [self checkConnectionAvailable];
    if (!hasNetwork) {
        return;
    }
    NSString *strNumber = deviceTF.text;
    if ([AppUtil isBlankString:strNumber]) {
        [self showWarningTip:@"设备号不存在"];
        return;
    }
    if ([AppUtil isBlankString:strTT]) {
        [[AFHttpClient sharedAFHttpClient]AddDeviceStats:[AccountManager sharedAccountManager].loginModel.mid deviceno:deviceTF.text complete:^(BaseModel *model) {
            FuckLog(@"%@",model);
            
            if ([model.retCode isEqualToString:@"0000"]) {
                [self showWarningTip:@"绑定成功"];
                [Defaluts setObject:model.content forKey:TERMID_DEVICNUMER];
                [Defaluts setObject:deviceTF.text forKey:PREF_DEVICE_NUMBER];
                [Defaluts setValue:incodeTF.text forKey:@"incodeNum"];
                [Defaluts setObject:@"ok" forKey:@"setimage"];
                
                
                // PREF_DEVICE_NUMBER DeviceNum
                [Defaluts synchronize];
                
            
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                // 错误提示
               // [self wariring];
                
                return ;
                
                
            }
            
            
        }];
    }else
    {
        
        UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"确定解除绑定吗" preferredStyle:UIAlertControllerStyleAlert];
        
      
      
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self jiechuband];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}




- (void)jiechuband
{
    
    // 解除绑定
    
    [[AFHttpClient sharedAFHttpClient]RemoveDevice:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel * model) {
        if ([model.retCode isEqualToString:@"0000"]) {
            // 解除绑定成功
            // 提示
            [self showWarningTip:@"解绑成功"];
            
            [Defaluts removeObjectForKey:PREF_DEVICE_NUMBER];
            [AccountManager sharedAccountManager].loginModel.deviceno=nil;
            [Defaluts removeObjectForKey:@"incodeNum"];
            [Defaluts synchronize];
            deviceTF.text =@"";
            incodeTF.text =@"";
            [self.navigationController popViewControllerAnimated:NO];
            
            
        }
        
        
    }];

    
}




- (void)SearchDevice
{
    // hud
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在搜索设备请稍等...";

    
}


// 提示框
- (void)wariring
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    ShowView = [[ShowWarView alloc] initWithFrame:CGRectMake(0, 0,0 ,0)];
    ShowView.delegate = self;
    [self.view addSubview:ShowView];
    [ShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@255);
        make.height.equalTo(@162);
        make.left.equalTo(self.view.mas_left).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(btnBind.mas_bottom).offset(43);
        
    }];
    
    

    
    
    
}

#pragma mark - ShowDelegate
- (void)CancelMethod
{
    [ShowView removeFromSuperview];
    
    
    
}
- (void)TryAgainMethod
{
     [ShowView removeFromSuperview];
    
}


// 断掉服务
- (void)timestart:(NSTimer *)timer
{
    timerEnd++;
    if (timerEnd>35 && [AppUtil isBlankString:deviceTF.text]) {
        // 关闭服务
        [hud hide:TRUE];
        [self showWarningTip:@"配置失败，请确保打开设备蓝牙"];
        timerEnd=0;
    }
    
    
    
}


#pragma mark - CBPeripheralManagerDelegate


/**
 *  创建ble设备
 *
 *  创建模拟的ble设备，收发绑定请求。
 */
- (void)setUpBleDevice {
    
        timerCheck =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timestart:) userInfo:nil repeats:YES];
    [timerCheck setFireDate:[NSDate distantPast]];
    
    // bind请求的参数json对象。
    NSString *strUserid = [AccountManager sharedAccountManager].loginModel.mid;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"bind", @"action", strUserid, @"userid", nil];
    NSString *str = [self dictionaryToJson:params];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 请求特征：广播bind请求。
    // 创建特征1：请求特征。
    CBMutableCharacteristic *readCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:REQUEST_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
    
    // 结果特征：接收设备号。
    // 创建特征2：结果特征。
    CBMutableCharacteristic *resultCharacteristic =
    [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RESULT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableDescriptor *resultCharacteristicDescription = [[CBMutableDescriptor alloc] initWithType:CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [resultCharacteristic setDescriptors:@[ resultCharacteristicDescription ]];
    
    // 创建配置服务，加入上述2个特征。
    CBMutableService *configService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CONFIG_SERVICE_UUID] primary:YES];
    [configService setCharacteristics:@[ readCharacteristic, resultCharacteristic ]];
    [peripheralManager addService:configService];
}


/**
 *  将字典对象转为json串
 *
 *  @param dic 字典
 *
 *  @return json串
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/**
 *  蓝牙状态更新回调
 *
 *  @param peripheral 蓝牙周边管理器
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
            // 蓝牙开启时，启动sego配置服务。
        case CBPeripheralManagerStatePoweredOn:
            FuckLog(@"Bluetooth powered on");
            
            if ([AppUtil isBlankString:strTT]) {
                [self SearchDevice];
                [self setUpBleDevice];


            }
            break;
            
            // 蓝牙关闭时，提示用户打开蓝牙。
        case CBPeripheralManagerStatePoweredOff:
            FuckLog(@"Bluetooth powered off");
             if ([AppUtil isBlankString:strTT]) {
                  [self showNeedBluetoothWaringDialog];
             }
            break;
            
        default:
            break;
    }
}

/**
 *  显示打开蓝牙提示窗
 */
- (void)showNeedBluetoothWaringDialog {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你尚未打开蓝牙" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  提示窗消息处理
 *
 *  @param alertView   提示窗
 *  @param buttonIndex 按钮序号 IOS 10 不允许跳转到系统设置界面
 */


/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 进入蓝牙设置窗口。
    if (buttonIndex == 1) {
        self.view.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
            }];
        }
    }
}
*/




/**
 *  蓝牙添加服务完成回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param service    服务
 *  @param error      错误描述
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error != nil) {
        FuckLog(@"Add service error: %@", error);
        return;
    }
    serviceNum++;
    
    // 添加服务成功后，广播蓝牙ble设备。
    [peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[ [CBUUID UUIDWithString:CONFIG_SERVICE_UUID] ], CBAdvertisementDataLocalNameKey : SEGOPASS_BLE_DEVICE_NAME }];
}

/**
 *  蓝牙开始发送广播
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param error      错误描述
 */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    FuckLog(@"peripheralManagerDidStartAdvertisiong");
    FuckLog(@"%@",error);
    
}

/**
 *  特征订阅回调
 *
 *  @param peripheral     蓝牙周边管理器
 *  @param central        中心
 *  @param characteristic 被订阅的特征
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    FuckLog(@"didSubscribeToCharacteristic %@", characteristic.UUID);
}

/**
 *  取消特征订阅回调
 *
 *  @param peripheral     蓝牙周边管理器
 *  @param central        中心
 *  @param characteristic 被取消订阅的特征
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    FuckLog(@"didUnsubscribeFromCharacteristic %@", characteristic.UUID);
}

/**
 *  读特征回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param request    请求
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    FuckLog(@"didReceiveReadRequest");
    
    // 判断特征是否有读权限。
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        // 设置特征值。
        NSData *data = request.characteristic.value;
        [request setValue:data];
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
    // 无读权限，拒绝之。
    else {
        [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}


/**
 *  写特征回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param requests   请求
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    FuckLog(@"didReceiveWriteRequests");
    isOpenPerOK = YES;
    
    CBATTRequest *request = requests[0];
    // 尚未收到应答，解析之。
    if (isAccecptOk == NO) {
        // 判断特征是否有写权限。
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *vchar = (CBMutableCharacteristic *)request.characteristic; // 转换成CBMutableCharacteristic才能写
            vchar.value = request.value;
            Byte *bytes = (Byte *)[vchar.value bytes];
            NSString *strResult = [[NSString alloc] initWithBytes:bytes length:vchar.value.length encoding:NSUTF8StringEncoding];
            FuckLog(@"Get result: %@", strResult);
            
            [hud hide:YES];
            
            // 将字符串分割为2个元素的数组。
            NSArray *array = [strResult componentsSeparatedByString:@","];
            if (array == nil || array.count != 2) {
                [self showWarningTip:@"配置失败，请重新搜索设备"];
                [self stopOverService];
                return;
            }
            strResult = array[0];
            // 出错了。
            if (![strResult isEqualToString:@"OK"]) {
                [self showWarningTip:@"配置失败，请重新搜索设备"];
                [self stopOverService];
                return;
                
            }
            
            // 设备号以segoegg打头。
            NSString *strNumber = array[1];
            if ([strNumber hasPrefix:SEGOEGG_PREFIX]) {
                isAccecptOk = YES;
                
                // 取出设备号，更新界面。
           NSString * deviceoNum = [strNumber substringFromIndex:SEGOEGG_PREFIX.length];
                 deviceTF.text = deviceoNum;
                 incodeTF.text = @"123456";
                [self enableBindButton];
                // 关闭
                
                [self stopOverService];
            }
            
            else {
                [self showWarningTip:@"配置失败，请重新搜索设备"];
                
                deviceTF.text = @"";
                incodeTF.text = @"";
                btnBind.enabled = FALSE;
                [self stopOverService];
                return;
            }
            
            [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        }
        // 无写权限，拒绝之。
        else {
            [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }
    // 忽略多次收到的应答。
    else {
    }
}

/**
 *  蓝牙准备更新订阅者回调
 *
 *  @param peripheral 蓝牙周边管理器
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    FuckLog(@"peripheralManagerIsReadyToUpdateSubscribers");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  使能绑定按钮
 */
- (void)enableBindButton {
    btnBind.backgroundColor = GREEN_COLOR;
    btnBind.enabled = TRUE;
    
}


/**
 *  显示警告提示
 */
- (void)showWarningTip:(NSString *)strWarring {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = strWarring;
    hud.minSize = CGSizeMake(132.f, 66.0f);
    [hud hide:YES afterDelay:1.0];
    
}

/**
 *  停止蓝牙和时间服务
 */

- (void)stopOverService
{
    [timerCheck setFireDate:[NSDate distantFuture]];
    [peripheralManager stopAdvertising];
    [peripheralManager removeAllServices];
    
    
}

@end
