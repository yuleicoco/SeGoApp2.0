//
//  InformationViewController.m
//  sego2.0
//
//  Created by czx on 16/11/19.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "AFHttpClient+PersonMember.h"

static NSString * cellId = @"InformationCellId";
@interface InformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIButton * headBtn;
@property (nonatomic,strong)NSArray * nameArray;
@property (nonatomic,strong)UIButton * bigBtn;
@property (nonatomic,strong)UIView * centerwhteView;
@property (nonatomic,strong) UITextField * exchangeTextfield;

@property (nonatomic,strong)UIView * downWithView;
@property (nonatomic,strong)UIButton * coverButton;
@property (nonatomic,strong)UIView * littleDownView;
@property(nonatomic,strong)UIImagePickerController * imagePicker;
@property (nonatomic,strong)NSString * picstr;

@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)UIView * bigView;
@property (nonatomic,strong)UIButton * bigButton;
@property (nonatomic,strong)UIButton * wanchengBtn;

//选择器
@property (nonatomic,retain) NSMutableArray *yearArray;
@property (nonatomic,retain) NSMutableArray *monthArray;
@property (nonatomic,retain) NSMutableArray *daysArray;
@property (nonatomic,assign) long selectedYearRow;
@property (nonatomic,assign) long selectedMonthRow;
@property (nonatomic,assign) long selectedDayRow;
@property (nonatomic,retain) UIPickerView *pickViewList;




@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:[AccountManager sharedAccountManager].loginModel.nickname];
    _imagePicker =[[UIImagePickerController alloc]init];
    _imagePicker.delegate= self;
    }

-(void)setupView{
    [super setupView];
    self.view.backgroundColor = GRAY_COLOR;
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview).offset(12);
        make.height.mas_offset(80);
    }];
    
    UILabel * headLabel = [[UILabel alloc]init];
    headLabel.text = @"头像";
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(headLabel.superview).offset(12);

    }];
    
   _headBtn = [[UIButton alloc]init];
    //headBtn.backgroundColor = [UIColor blackColor];
    [_headBtn.layer setMasksToBounds:YES];
    _headBtn.layer.cornerRadius = 33;
    UIImage * btnImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AccountManager sharedAccountManager].loginModel.headportrait]]];
    [_headBtn setImage:btnImage forState:UIControlStateNormal];
    [_headBtn addTarget:self action:@selector(headbtuttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headBtn];
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headBtn.superview).offset(-12);
        make.top.equalTo(topView.mas_top).offset(7);
        make.bottom.equalTo(topView.mas_bottom).offset(-7);
        make.width.mas_offset(66);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.height.mas_equalTo(330);
        
    }];
    
  //  self .tableView.frame =  CGRectMake(0, 0, self.view.width, self.view.height);

     [self.tableView registerClass:[InformationTableViewCell class] forCellReuseIdentifier:cellId];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.scrollEnabled = NO;
    
    
    

}
- (void)loadDataSourceWithPage:(int)page {


}


-(void)setupData{
    [super setupData];
    _nameArray = [[NSArray alloc]init];
    _nameArray = @[@"帐号",@"昵称",@"性别",@"家族",@"生日",@"签名"];
    
    

}

-(void)headbtuttonTouch:(UIButton *)sender{
   // FuckLog([AccountManager sharedAccountManager].loginModel.pet_sex);
    _downWithView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    _littleDownView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 667 * W_Hight_Zoom)];
    _coverButton.backgroundColor = [UIColor blackColor];
    _coverButton.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverButton];
    [_coverButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 543 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 627 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
        _littleDownView.backgroundColor = [UIColor whiteColor];
        _downWithView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_littleDownView];
        [[UIApplication sharedApplication].keyWindow addSubview:_downWithView];
    }];
    NSArray * nameArray = @[NSLocalizedString(@"photograph", nil),NSLocalizedString(@"photoalbum", nil)];
    for (int i = 0; i < 2; i++) {
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabel.backgroundColor = GRAY_COLOR;
        [_downWithView addSubview:lineLabel];
        
        UIButton * downButtones = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        [downButtones setTitle:nameArray[i] forState:UIControlStateNormal];
        [downButtones setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downButtones.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downWithView addSubview:downButtones];
        downButtones.tag = i;
        [downButtones addTarget:self action:@selector(imageButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * quxiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    [quxiaoButton setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quxiaoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_littleDownView addSubview:quxiaoButton];
    [quxiaoButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)hideButton:(UIButton *)sender{
    _coverButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
    }];
}

-(void)imageButtonTouch:(UIButton *)sender{
    if (sender.tag == 0) {
        [self takePhoto];
    }else{
        [self loacalPhoto];
    }
    
}

- (void)takePhoto
{
    [self hideButton:nil];
    // 拍照
    NSArray * mediaty = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = @[mediaty[0]];
        //设置相机模式：1摄像2录像
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //使用前置还是后置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //闪光模式
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        _imagePicker.allowsEditing = YES;
    }else
    {
        NSLog(@"打开摄像头失败");
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
    
}


- (void)loacalPhoto
{
    [self hideButton:nil];
    NSArray * mediaTypers = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes = @[mediaTypers[0],mediaTypers[1]];
        _imagePicker.allowsEditing = YES;
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDateFormatter * formater =[[NSDateFormatter alloc]init];
    
    UIImage * showImage = info[UIImagePickerControllerEditedImage];
    NSLog(@"wocaocao:%@",showImage);
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"handImageText" object:showImage];
   // _headImage.image = showImage;
    [_headBtn setImage:showImage forState:UIControlStateNormal];
    
    NSData * data = UIImageJPEGRepresentation(showImage,1.0f);
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    [formater stringFromDate:[NSDate date]];
    NSString *picname1 = [NSString stringWithFormat:@"%@.jpg",[formater stringFromDate:[NSDate date]]];
    
    
    NSString * pictureDataString = [data base64EncodedStringWithOptions:0];
    // NSLog(@"%@",pictureDataString);
   
    _picstr = [NSString stringWithFormat:@"[{\"%@\":\"%@\",\"%@\":\"%@\"}]",@"name",picname1,@"content",pictureDataString];
    [self changgeheadRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)changgeheadRequest{
    
    [self showHudInView:self.view hint:@"正在修改..."];
    [[AFHttpClient sharedAFHttpClient]modifyHeadportraitWithMid: [AccountManager sharedAccountManager].loginModel.mid picture:_picstr complete:^(BaseModel *model) {
        [self hideHud];
        [[AppUtil appTopViewController] showHint:@"修改成功"];
        LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
        [[AccountManager sharedAccountManager]login:loginModel];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"meshuashua" object:nil];

    }];
    
}






#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       InformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.nameLabel.text = _nameArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.accountnumber;
    }
    if (indexPath.row == 1) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    }
    if (indexPath.row == 2) {
        if ([[AccountManager sharedAccountManager].loginModel.pet_sex isEqualToString:@"公"]) {
            cell.rightLabel.text = @"公";
        }else{
            cell.rightLabel.text = @"母";
        }
    }
    if (indexPath.row == 3) {
        if ([[AccountManager sharedAccountManager].loginModel.pet_race isEqualToString:@"汪"]) {
            cell.rightLabel.text = @"汪星人";
        }else{
            cell.rightLabel.text = @"喵星人";
        }
    }
    if (indexPath.row == 4) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.pet_birthday;
    }
    if (indexPath.row == 5) {
        cell.rightLabel.text = [AccountManager sharedAccountManager].loginModel.signature;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // InformationTableViewCell * cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        [self exchangename];
    }
    if (indexPath.row == 2) {
        [self exchangesex];
    }
    if (indexPath.row == 3) {
        [self exchangerace];
    }
    if (indexPath.row == 4) {
        [self exchangebrithday];
    }
    if (indexPath.row == 5) {
        [self exchangsigner];
    }
    
}

-(void)exchangename{
    // 通过数据控制界面
    //[AccountManager sharedAccountManager].loginModel.nickname = @"dadada";
    //[self.tableView reloadData];
    FuckLog(@"修改昵称");
    [self bigButtonOpen:1];
}


-(void)exchangesex{
    FuckLog(@"修改性别");
  //  [self bigButtonOpen:2];
    NSString * str = [AccountManager sharedAccountManager].loginModel.pet_sex;
    NSString * newstr = @"";
    if ([str isEqualToString:@"公"]) {
            newstr = @"母";
    }else{
            newstr = @"公";
    }
    
    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nickname:[AccountManager sharedAccountManager].loginModel.nickname address:[AccountManager sharedAccountManager].loginModel.address signature:[AccountManager sharedAccountManager].loginModel.signature pet_sex:newstr pet_birthday:[AccountManager sharedAccountManager].loginModel.pet_birthday pet_race:[AccountManager sharedAccountManager].loginModel.pet_race complete:^(BaseModel *model) {
        if (model) {
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [self.tableView reloadData];
        }

    }];

}

-(void)exchangerace{
    FuckLog(@"修改属性");
    NSString * str = [AccountManager sharedAccountManager].loginModel.pet_race;
    NSString * newstr = @"";
    if ([str isEqualToString:@"汪"]) {
        newstr = @"喵";
    }else{
        newstr = @"汪";
    }

    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nickname:[AccountManager sharedAccountManager].loginModel.nickname address:[AccountManager sharedAccountManager].loginModel.address signature:[AccountManager sharedAccountManager].loginModel.signature pet_sex:[AccountManager sharedAccountManager].loginModel.pet_sex pet_birthday:[AccountManager sharedAccountManager].loginModel.pet_birthday pet_race:newstr complete:^(BaseModel *model) {
        if (model) {
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [self.tableView reloadData];
        }

    }];

}

-(void)exchangebrithday{
    FuckLog(@"修改生日");
    [self bigButtonOpen:4];

}

-(void)exchangsigner{
    FuckLog(@"修改签名");
    [self bigButtonOpen:5];
}

-(void)bigButtonOpen:(NSInteger)i{
    _bigBtn = [[UIButton alloc]init];
    _bigBtn.backgroundColor = [UIColor blackColor];
    _bigBtn.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_bigBtn];
    [_bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigBtn.superview);
        make.bottom.equalTo(_bigBtn.superview);
        make.left.equalTo(_bigBtn.superview);
        make.right.equalTo(_bigBtn.superview);
    }];
    [_bigBtn addTarget:self action:@selector(bigbuttonTouch) forControlEvents:UIControlEventTouchUpInside];

    _centerwhteView = [[UIView alloc]init];
    _centerwhteView.backgroundColor = [UIColor whiteColor];
    _centerwhteView.layer.cornerRadius = 5;
    [[UIApplication sharedApplication].keyWindow addSubview:_centerwhteView];
    [_centerwhteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerwhteView.superview).offset(60);
        make.right.equalTo(_centerwhteView.superview).offset(-60);
        make.top.equalTo(_centerwhteView.superview).offset(245);
        make.height.mas_equalTo(162);
    }];
    if (i == 1) {
        [self exchangnameview];
    }
    if (i == 4) {
        [self exchangeBirthdayView];
    }
    if (i == 5) {
        [self exchangesignerView];
    }
    
    
}
-(void)bigbuttonTouch{
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
}

#pragma mark - 改名字
//修改名字
-(void)exchangnameview{
    //_centerwhteView.backgroundColor = [UIColor redColor];
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"修改昵称";
    nameLabel.textColor = [UIColor blackColor];
   // nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    nameLabel.font = [UIFont systemFontOfSize:17.5];
    [_centerwhteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLabel.superview.mas_centerX);
        make.top.equalTo(nameLabel.superview).offset(14);
        
    }];
    
    _exchangeTextfield = [[UITextField alloc]init];
    _exchangeTextfield.placeholder = @"请输入昵称";
    _exchangeTextfield.text = [AccountManager sharedAccountManager].loginModel.nickname;
    _exchangeTextfield.textAlignment = NSTextAlignmentCenter;
    _exchangeTextfield.textColor = [UIColor blackColor];
    _exchangeTextfield.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:_exchangeTextfield];
    [_exchangeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_exchangeTextfield.superview.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).offset(26);
        make.width.mas_equalTo(200);
        
    }];
    
    UILabel * henglineLabel = [[UILabel alloc]init];
    henglineLabel.backgroundColor =[UIColor grayColor];
    [_centerwhteView addSubview:henglineLabel];
    [henglineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(henglineLabel.superview);
        make.right.equalTo(henglineLabel.superview);
        make.top.equalTo(_exchangeTextfield.mas_bottom).offset(28);
        make.height.mas_equalTo(0.5);
    }];

    UILabel * shuLabel = [[UILabel alloc]init];
    shuLabel.backgroundColor = [UIColor grayColor];
    [_centerwhteView addSubview:shuLabel];
    [shuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(henglineLabel.mas_bottom);
        make.bottom.equalTo(shuLabel.superview);
        make.centerX.equalTo(shuLabel.superview.mas_centerX);
        make.width.mas_equalTo(0.5);
        
    }];

    UILabel * danceLabel = [[UILabel alloc]init];
    danceLabel.text = @"取消";
    danceLabel.textColor = [UIColor blackColor];
    danceLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:danceLabel];
    [danceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shuLabel.mas_left).offset(-48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UILabel * sureLabel = [[UILabel alloc]init];
    sureLabel.text = @"确定";
    sureLabel.textColor = [UIColor blackColor];
    sureLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right).offset(48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UIButton * danceBtn = [[UIButton alloc]init];
    danceBtn.backgroundColor = [UIColor clearColor];
    [danceBtn addTarget:self action:@selector(namedancebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:danceBtn];
    [danceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(danceBtn.superview);
    // make.top.equalTo(exchangeTextfield.mas_bottom).offset(28.5);
        make.right.equalTo(shuLabel.mas_left);
        make.bottom.equalTo(danceBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn addTarget:self action:@selector(namesurebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right);
        make.right.equalTo(sureBtn.superview);
        make.bottom.equalTo(sureBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
}

-(void)namedancebuttonTouch{
    FuckLog(@"不改名字了");
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
}

-(void)namesurebuttonTouch{
    FuckLog(@"还是改个名字吧");
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
        [self showHudInView:self.view hint:@"正在修改..."];
    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nickname:_exchangeTextfield.text address:[AccountManager sharedAccountManager].loginModel.address signature:[AccountManager sharedAccountManager].loginModel.signature pet_sex:[AccountManager sharedAccountManager].loginModel.pet_sex pet_birthday:[AccountManager sharedAccountManager].loginModel.pet_birthday pet_race:[AccountManager sharedAccountManager].loginModel.pet_race complete:^(BaseModel *model) {
        if (model) {
             [[AppUtil appTopViewController] showHint:@"修改成功"];
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"meshuashua" object:nil];

            
        }
          [self hideHud];
    }];
    
}

#pragma mark - 改生日
//修改生日
-(void)exchangeBirthdayView{
    
    self.pickViewList = [[UIPickerView alloc]init];
    self.pickViewList.showsSelectionIndicator = YES;
    self.pickViewList.delegate = self;
    self.pickViewList.dataSource = self;
    [_centerwhteView addSubview:self.pickViewList];
    [self.pickViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickViewList.superview).offset(38);
        make.right.equalTo(self.pickViewList.superview).offset(-38);
        make.top.equalTo(self.pickViewList.superview);
        make.height.mas_equalTo(112);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSDate * date = [NSDate date];
    NSString *currentYearString = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%ld月",(long)[[formatter stringFromDate:date] integerValue]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%ld日",(long)[[formatter stringFromDate:date] integerValue]];
    
    self.yearArray = [[NSMutableArray alloc] init];
    for (int i = 1990; i <= 2060 ; i++)
    {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
    self.monthArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12 ; i++)
    {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    
    self.daysArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 31; i++)
    {
        [self.daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
    }
    [self.pickViewList selectRow:[self.yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
    [self.pickViewList selectRow:[self.monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    [self.pickViewList selectRow:[self.daysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    

    UILabel * henglineLabel = [[UILabel alloc]init];
    henglineLabel.backgroundColor =[UIColor grayColor];
    [_centerwhteView addSubview:henglineLabel];
    [henglineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(henglineLabel.superview);
        make.right.equalTo(henglineLabel.superview);
        //make.top.equalTo(_exchangeTextfield.mas_bottom).offset(28);
        make.bottom.equalTo(henglineLabel.superview).offset(-50);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel * shuLabel = [[UILabel alloc]init];
    shuLabel.backgroundColor = [UIColor grayColor];
    [_centerwhteView addSubview:shuLabel];
    [shuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(henglineLabel.mas_bottom);
        make.bottom.equalTo(shuLabel.superview);
        make.centerX.equalTo(shuLabel.superview.mas_centerX);
        make.width.mas_equalTo(0.5);
        
    }];
    
    UILabel * danceLabel = [[UILabel alloc]init];
    danceLabel.text = @"取消";
    danceLabel.textColor = [UIColor blackColor];
    danceLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:danceLabel];
    [danceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shuLabel.mas_left).offset(-48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UILabel * sureLabel = [[UILabel alloc]init];
    sureLabel.text = @"确定";
    sureLabel.textColor = [UIColor blackColor];
    sureLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right).offset(48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UIButton * danceBtn = [[UIButton alloc]init];
    danceBtn.backgroundColor = [UIColor clearColor];
    [danceBtn addTarget:self action:@selector(namedancebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:danceBtn];
    [danceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(danceBtn.superview);
        // make.top.equalTo(exchangeTextfield.mas_bottom).offset(28.5);
        make.right.equalTo(shuLabel.mas_left);
        make.bottom.equalTo(danceBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn addTarget:self action:@selector(datesurebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right);
        make.right.equalTo(sureBtn.superview);
        make.bottom.equalTo(sureBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];

}

-(void)datesurebuttonTouch{
    
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
    [self showHudInView:self.view hint:@"正在修改..."];
    NSString * str = [NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:[self.pickViewList selectedRowInComponent:0]]];
    str = [str substringToIndex:[str length]-1];
    NSString * str2 = [NSString stringWithFormat:@"%@",[self.monthArray objectAtIndex:[self.pickViewList selectedRowInComponent:1]]];
    str2 = [str2 substringToIndex:[str2 length]-1];
    NSString * str3 = [NSString stringWithFormat:@"%@",[self.daysArray objectAtIndex:[self.pickViewList selectedRowInComponent:2]]];
    str3 = [str3 substringToIndex:[str3 length]-1];
    NSString * newStr = [NSString stringWithFormat:@"%@-%@-%@",str,str2,str3];
    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nickname:[AccountManager sharedAccountManager].loginModel.nickname address:[AccountManager sharedAccountManager].loginModel.address signature:[AccountManager sharedAccountManager].loginModel.signature pet_sex:[AccountManager sharedAccountManager].loginModel.pet_sex pet_birthday:newStr pet_race:[AccountManager sharedAccountManager].loginModel.pet_race complete:^(BaseModel *model) {
        if (model) {
             [[AppUtil appTopViewController] showHint:@"修改成功"];
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [self.tableView reloadData];
        }
              [self hideHud];
    }];
    
}


#pragma mark - UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0)
    {
        self.selectedYearRow = row;
    }
    else if (component == 1)
    {
        self.selectedMonthRow = row;
        [self.pickViewList reloadComponent:2];
    }
    else if (component == 2)
    {
        self.selectedDayRow = row;
    }

     [self.pickViewList reloadComponent:component];
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)reusingView {
    UILabel *pickerLabel = (UILabel *)reusingView;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
       // [pickerLabel setTextAlignment:UITextAlignmentCenter];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
      //  pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        pickerLabel.font = [UIFont systemFontOfSize:14];
        pickerLabel.textColor = [UIColor blackColor];
    }

    if (component == 0)
    {
        pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text = [self.monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [self.daysArray objectAtIndex:row]; // Date
        
    }
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
    {
        return [self.yearArray count];
    }
    else if (component == 1)
    {
        return [self.monthArray count];
    }
    else
    { // day
        if (self.selectedMonthRow == 0 || self.selectedMonthRow == 2 || self.selectedMonthRow == 4 || self.selectedMonthRow == 6 || self.selectedMonthRow == 7 || self.selectedMonthRow == 9 || self.selectedMonthRow == 11)
        {
            return 31;
        }
        else if (self.selectedMonthRow == 1)
        {
            int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
            
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                return 29;
            }
            else
            {
                return 28; // or return 29
            }
        }
        else
        {
            return 30;
        }
    }
}

#pragma mark - 改签名
-(void)exchangesignerView{
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"修改签名";
    nameLabel.textColor = [UIColor blackColor];
    // nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    nameLabel.font = [UIFont systemFontOfSize:17.5];
    [_centerwhteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLabel.superview.mas_centerX);
        make.top.equalTo(nameLabel.superview).offset(14);
        
    }];
    
    _exchangeTextfield = [[UITextField alloc]init];
    _exchangeTextfield.placeholder = @"请输入签名";
    _exchangeTextfield.text = [AccountManager sharedAccountManager].loginModel.signature;
    _exchangeTextfield.textAlignment = NSTextAlignmentCenter;
    _exchangeTextfield.textColor = [UIColor blackColor];
    _exchangeTextfield.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:_exchangeTextfield];
    [_exchangeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_exchangeTextfield.superview.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).offset(26);
        make.width.mas_equalTo(200);
        
    }];
    
    UILabel * henglineLabel = [[UILabel alloc]init];
    henglineLabel.backgroundColor =[UIColor grayColor];
    [_centerwhteView addSubview:henglineLabel];
    [henglineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(henglineLabel.superview);
        make.right.equalTo(henglineLabel.superview);
        make.top.equalTo(_exchangeTextfield.mas_bottom).offset(28);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel * shuLabel = [[UILabel alloc]init];
    shuLabel.backgroundColor = [UIColor grayColor];
    [_centerwhteView addSubview:shuLabel];
    [shuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(henglineLabel.mas_bottom);
        make.bottom.equalTo(shuLabel.superview);
        make.centerX.equalTo(shuLabel.superview.mas_centerX);
        make.width.mas_equalTo(0.5);
        
    }];
    
    UILabel * danceLabel = [[UILabel alloc]init];
    danceLabel.text = @"取消";
    danceLabel.textColor = [UIColor blackColor];
    danceLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:danceLabel];
    [danceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shuLabel.mas_left).offset(-48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UILabel * sureLabel = [[UILabel alloc]init];
    sureLabel.text = @"确定";
    sureLabel.textColor = [UIColor blackColor];
    sureLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right).offset(48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UIButton * danceBtn = [[UIButton alloc]init];
    danceBtn.backgroundColor = [UIColor clearColor];
    [danceBtn addTarget:self action:@selector(namedancebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:danceBtn];
    [danceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(danceBtn.superview);
        // make.top.equalTo(exchangeTextfield.mas_bottom).offset(28.5);
        make.right.equalTo(shuLabel.mas_left);
        make.bottom.equalTo(danceBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn addTarget:self action:@selector(exchangesinertouch) forControlEvents:UIControlEventTouchUpInside];
    [_centerwhteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuLabel.mas_right);
        make.right.equalTo(sureBtn.superview);
        make.bottom.equalTo(sureBtn.superview.mas_bottom);
        make.height.mas_equalTo(51);
    }];

}
-(void)exchangesinertouch{
    FuckLog(@"改个签名吧");
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
      [self showHudInView:self.view hint:@"正在修改..."];
    [[AFHttpClient sharedAFHttpClient]modifyMemberWithMid:[AccountManager sharedAccountManager].loginModel.mid nickname:[AccountManager sharedAccountManager].loginModel.nickname address:[AccountManager sharedAccountManager].loginModel.address signature:_exchangeTextfield.text pet_sex:[AccountManager sharedAccountManager].loginModel.pet_sex pet_birthday:[AccountManager sharedAccountManager].loginModel.pet_birthday pet_race:[AccountManager sharedAccountManager].loginModel.pet_race complete:^(BaseModel *model) {
        if (model) {
              [[AppUtil appTopViewController] showHint:@"修改成功"];
            LoginModel * loginModel = [[LoginModel alloc]initWithDictionary:model.retVal error:nil];
            [[AccountManager sharedAccountManager]login:loginModel];
            [self.tableView reloadData];
        }
        [self hideHud];
    }];


}








@end
