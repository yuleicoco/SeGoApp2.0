//
//  WifiViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "WifiViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BindingViewController.h"
#import "SetViewController.h"


@interface WifiViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CBPeripheralManagerDelegate>

{
    UITextField *  wifiPsTF ;
    UITextField *  incodeTF;
    UITableView * tabWIFI;
    UIButton*  btnBind;
    NSString *curEncryption; // 当前加密选项
    UIButton * btn;
    
    CBPeripheralManager *peripheralManager;
    int serviceNum;          // 添加成功的service数量
    BOOL isAccecptOk;        // 是否接收结果成功
    NSTimer * timer;
    NSInteger  timeEnd;
    
    
    
    
    
    
}
@end


@implementation WifiViewController
@synthesize listArr;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"wifiTitle",nil)];
    listArr = @[ @"无加密", @"WPA/WPA2", @"WEP" ];
    curEncryption = [NSString stringWithFormat:@"1"];
    
    
    
    
}

- (void)setupView
{
    [super setupView];
    
    UIView * devNum =[UIView new];
    UIView * wifiView =[UIView new];
    UIView * wifiCode =[UIView new];
    UIView * methodView =[UIView new];
    methodView.backgroundColor = [UIColor whiteColor];
  //  methodView.layer.cornerRadius =4;
    methodView.layer.borderWidth =1;
    methodView.layer.borderColor =GRAY_COLOR.CGColor;
    
    devNum.backgroundColor = [UIColor whiteColor];
    wifiView.backgroundColor = [UIColor whiteColor];
    wifiCode.backgroundColor = [UIColor whiteColor];
    devNum.layer.cornerRadius =4;
    devNum.layer.borderWidth =0.4;
    devNum.layer.borderColor =GRAY_COLOR.CGColor;
    wifiView.layer.cornerRadius =4;
    wifiView.layer.borderWidth =0.4;
    wifiView.layer.borderColor = GRAY_COLOR.CGColor;
    wifiCode.layer.cornerRadius =4;
    wifiCode.layer.borderWidth =0.4;
    wifiCode.layer.borderColor = GRAY_COLOR.CGColor;
    wifiCode.userInteractionEnabled = YES;
    [self.view addSubview:wifiCode];
    [self.view addSubview:devNum];
    [self.view addSubview:wifiView];
    [self.view addSubview:methodView];
    
    [devNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(wifiView);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(8);
    }];
    
    [wifiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(66);
        
    }];
    
    [wifiCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.width.equalTo(devNum);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view).offset(124);
        
    }];
    
    btnBind =[UIButton new];
    btnBind.layer.cornerRadius = 4;
    btnBind.backgroundColor = GREEN_COLOR;
    [btnBind setTitle:@"确定" forState:UIControlStateNormal];
    [btnBind addTarget:self action:@selector(Surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBind];
    [btnBind mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@55);
        make.top.equalTo(wifiCode.mas_bottom).offset(75);
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.width.equalTo(wifiCode);
        
    }];
    
    
    UILabel * labelMess=[UILabel new];
    labelMess.text =@"加密方式";
    labelMess.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:labelMess];
    
    [labelMess mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wifiCode.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(29);
        
    }];
    
    
    
    
    
    UILabel * deveLB= [UILabel new];
    UILabel * wifiLB =[UILabel new];
    UILabel * wifips =[UILabel new];
    
    deveLB.text =@"设备号:";
    deveLB.font = [UIFont systemFontOfSize:18];
    wifiLB.text =@"WIFI名称:";
    wifiLB.font =[UIFont systemFontOfSize:18];
    
    wifips.text =@"WIFI密码:";
    wifips.font =[UIFont systemFontOfSize:18];
    
    
    [devNum addSubview:deveLB];
    [wifiView addSubview:wifiLB];
    [wifiCode addSubview:wifips];
    
    
    
    [deveLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(devNum.mas_left).with.offset(26);
        make.centerY.equalTo(devNum.mas_centerY);
        
        
        
    }];
    
    [wifiLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiView).offset(12);
        make.centerY.equalTo(wifiView.mas_centerY);
        
    }];
    
    [wifips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wifiCode).offset(12);
        make.centerY.equalTo(wifiCode.mas_centerY);
        
    }];
    
    
    
    UITextField *  deviceTF =[UITextField new];
    incodeTF =[UITextField new];
    wifiPsTF =[UITextField new];
     NSString * str  =  [Defaluts objectForKey:PREF_DEVICE_NUMBER];
    if ([AppUtil isBlankString:str]) {
         deviceTF.text = self.strDevice;
    }else
    {
        deviceTF.text = str;
    }
   
    incodeTF.text =[self fetchSSIDInfo];
    wifiPsTF.text =@"";
    wifiPsTF.delegate = self;
    
    deviceTF.enabled = NO;
    incodeTF.enabled = NO;
    wifips.userInteractionEnabled = YES;
    deviceTF.borderStyle = UITextBorderStyleNone;
    incodeTF.borderStyle =UITextBorderStyleNone;
    wifiPsTF.borderStyle =UITextBorderStyleNone;
    
    deviceTF.font = [UIFont systemFontOfSize:18];
    incodeTF.font = [UIFont systemFontOfSize:18];
    wifiPsTF.font =[UIFont systemFontOfSize:18];
    [devNum addSubview:deviceTF];
    [wifiView addSubview:incodeTF];
    [wifiCode addSubview:wifiPsTF];
    
    [deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deveLB.mas_right).offset(13);
        make.centerY.equalTo(devNum.mas_centerY);
        
    }];
    
    [incodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wifiLB.mas_right).with.offset(13);
        make.centerY.equalTo(wifiView.mas_centerY);
        
    }];
    
    
    [wifiPsTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wifips.mas_right).with.offset(13);
        make.centerY.equalTo(wifiCode.mas_centerY);
        make.width.mas_equalTo(250);
        
    }];
    
    
    
    
    [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(labelMess.mas_right).offset(147);
        make.top.equalTo(wifiCode.mas_bottom).offset(24);
//        make.bottom.equalTo(btnBind.mas_top).offset(-36);
        make.height.mas_equalTo(20);
        
        make.right.equalTo(self.view).offset(-17);
        
        
        
    }];
    
    
    btn =[UIButton new];
    [btn setTitle:@"WAP/WAP2" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(openOrclose:) forControlEvents:UIControlEventTouchUpInside];
    [methodView addSubview:btn];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(methodView).offset(5);
        make.height.equalTo(methodView);
        make.top.equalTo(methodView.mas_top).offset(1);
        
        
        
    }];
    
    UIImageView * imaeV = [UIImageView new];
    [imaeV setImage:[UIImage imageNamed:@"xiala"]];
    [methodView addSubview:imaeV];
    
    
    [imaeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(methodView.mas_right).offset(-12);
        make.height.equalTo(methodView);
        make.top.equalTo(methodView.mas_top).offset(1);

        
    }];
    
    
    // tab
    tabWIFI =[UITableView new];
    tabWIFI.hidden = YES;
    tabWIFI.delegate = self;
    tabWIFI.dataSource = self;
    tabWIFI.backgroundColor =[UIColor whiteColor];
    if ([tabWIFI respondsToSelector:@selector(setSeparatorInset:)]) {
        [tabWIFI setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([tabWIFI respondsToSelector:@selector(setLayoutMargins:)]) {
        [tabWIFI setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self.view addSubview:tabWIFI];

    [tabWIFI mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(methodView.mas_bottom).offset(0);
        make.width.equalTo(methodView);
        make.left.equalTo(labelMess.mas_right).offset(147);
        make.height.mas_equalTo(@100);
        
        
    }];
    

    
    
    
    
//    if ([AppUtil isBlankString:wifiPsTF.text]) {
//        
//         btnBind.enabled = FALSE;
//         return;
//    }else
//    {
//        
//        btnBind.enabled = TRUE;
//        btnBind.backgroundColor = GREEN_COLOR;
//        
//    }
    
    
    
    
}

#pragma mark - Blooth


/**
 *  蓝牙状态更新回调
 *
 *  @param peripheral 蓝牙周边管理器
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
            // 蓝牙开启时，启动sego配置服务。
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"Bluetooth powered on");
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在配置设备网络，请等待...";
            [self setUpBleDevice];
            
            break;
            
            // 蓝牙关闭时，提示用户打开蓝牙。
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"Bluetooth powered off");
            
            [self showNeedBluetoothWaringDialog];
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
 *  创建ble设备
 */
- (void)setUpBleDevice {
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timestart:) userInfo:nil repeats:YES];

    [timer setFireDate:[NSDate distantPast]];
    if ([AppUtil isBlankString:incodeTF.text] || [AppUtil isBlankString:wifiPsTF.text]) {
        return;
    }
    
    // setwifi请求的参数json对象。
    NSString *strUserid =[AccountManager sharedAccountManager].loginModel.mid;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"setwifi", @"action", incodeTF.text, @"wifi", wifiPsTF.text, @"pass", strUserid, @"userid", curEncryption, @"sec", nil];
    
    NSString *str = [self dictionaryToJson:params];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 结果特征：接收设置结果。
    // 创建特征2：结果特征。
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableCharacteristic *resultCharacteristic =
    [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RESULT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    CBMutableDescriptor *resultCharacteristicDescription = [[CBMutableDescriptor alloc] initWithType:CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [resultCharacteristic setDescriptors:@[ resultCharacteristicDescription ]];
    
    // 请求特征：广播setwifi请求。
    // 创建特征1：请求特征。
    CBMutableCharacteristic *requestCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:REQUEST_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
    
    // 创建配置服务，加入上述2个特征。
    CBMutableService *configService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CONFIG_SERVICE_UUID] primary:YES];
    [configService setCharacteristics:@[ resultCharacteristic, requestCharacteristic ]];
    [peripheralManager addService:configService];
}




/**
 *  蓝牙添加服务完成回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param service    服务
 *  @param error      错误描述
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error != nil) {
        NSLog(@"Add service error: %@", error);
        return;
    }
    serviceNum++;
    
    // 添加服务成功后，广播蓝牙ble设备。
    [peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[ [CBUUID UUIDWithString:CONFIG_SERVICE_UUID] ], CBAdvertisementDataLocalNameKey : SEGOPASS_BLE_DEVICE_NAME }];
}

/**
 *  读特征回调
 *
 *  @param peripheral 蓝牙周边管理器
 *  @param request    请求
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"didReceiveReadRequest");
    
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
    NSLog(@"didReceiveWriteRequests");
    
    CBATTRequest *request = requests[0];
    // 尚未收到应答，解析之。
    if (!isAccecptOk) {
        // 判断特征是否有写权限。
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *vchar = (CBMutableCharacteristic *)request.characteristic; // 转换成CBMutableCharacteristic才能写
            vchar.value = request.value;
            Byte *bytes = (Byte *)[vchar.value bytes];
            NSString *strResult = [[NSString alloc] initWithBytes:bytes length:vchar.value.length encoding:NSUTF8StringEncoding];
            FuckLog(@"Get result: %@", strResult);
            
            [hud hide:TRUE];
            
            // 将字符串分割为2个元素的数组。
            NSArray *array = [strResult componentsSeparatedByString:@","];
            if (array == nil || array.count != 2) {
                [self showWarningTip:@"配置失败，请重新设置网络"];
                [self stopSever];
                return;
            }
            strResult = array[0];
            // 出错了。
            if (![strResult isEqualToString:@"OK"]) {
                [self showWarningTip:@"配置失败，请重新设置网络"];
                [self stopSever];
                return;
            }
            
            // 设备号以segoegg打头。
            NSString *strNumber = array[1];
            if ([strNumber hasPrefix:SEGOEGG_PREFIX]) {
                isAccecptOk = YES;
                
                // 保持已配置状态。
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:@"1" forKey:PREF_WIFI_CONFIGURED];
                [defaults synchronize];
                [self stopSever];
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            
                
            } else {
                [self showWarningTip:@"配置失败，请重新设置网络"];
                [self stopSever];
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
 * 超时
 *
 *
 */
- (void)timestart:(NSTimer*)sender
{
    timeEnd++;
    if (timeEnd>35) {
        // 关闭服务
        [hud hide:TRUE];
        [self showWarningTip:@"配置失败，请确保打开设备蓝牙"];
        timeEnd =0;
    }
    
}




/**
 *  获取当前连接WIFI的名称
 *
 *  @return
 */
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    if (info == nil) {
        return @"";
    }
    
    return [info objectForKey:@"SSID"];
}


- (void)Surebtn:(UIButton *)sender
{
    
    
    //链接wifi
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    serviceNum = 0;
    isAccecptOk = NO;
  

}


// 点击下拉可选加密方式
- (void)openOrclose:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 显示加密方式下拉列表。
    if (sender.selected) {
        tabWIFI.hidden = NO;
    }
    // 隐藏加密方式下拉列表。
    else if (!sender.selected) {
        tabWIFI.hidden = YES;
    }

    
    
    
}


#pragma mark -textFieldDelegate


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    if([AppUtil isBlankString:textField.text])
//    {
//        btnBind.enabled = FALSE;
//        btnBind.backgroundColor = GRAY_COLOR;
//        
//    }else{
//    btnBind.enabled = TRUE;
//    btnBind.backgroundColor = GREEN_COLOR;
//    }
    
}


#pragma mark -TabDelegate



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  32;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *showUserInfoCellIdentifier = @"ShowUserInfoCell123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font =[UIFont systemFontOfSize:11];
    // 设置单元格文本。
    cell.textLabel.text = listArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    curEncryption = [NSString stringWithFormat:@"%ld", indexPath.row];
    // 更新选择按钮的文本。
    // OPEN
    if (indexPath.row == 0) {
        [btn setTitle:@"无加密" forState:UIControlStateNormal];
    }
    // WPA/WPA2
    else if (indexPath.row == 1) {
        [btn setTitle:@"WPA/WAP2" forState:UIControlStateNormal];
    }
    // WEP
    else if (indexPath.row == 2) {
        [btn setTitle:@"WEP" forState:UIControlStateNormal];
    }
    
    // 隐藏加密方式列表。
      tabWIFI.hidden = YES;
      btn.selected = YES;
}



/**
 *  显示警告提示
 */
- (void)showWarningTip:(NSString *)str {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.minSize = CGSizeMake(132.f, 66.0f);
    [hud hide:YES afterDelay:1.0];
}


/**
 *  关闭服务
 */
- (void)stopSever
{
    [timer setFireDate:[NSDate distantFuture]];
    [peripheralManager stopAdvertising];
    [peripheralManager removeAllServices];
    

    
}

- (void)doLeftButtonTouch
{
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
