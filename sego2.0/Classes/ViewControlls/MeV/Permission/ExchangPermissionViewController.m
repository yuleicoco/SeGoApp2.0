//
//  ExchangPermissionViewController.m
//  sego2.0
//
//  Created by czx on 16/12/12.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ExchangPermissionViewController.h"
#import "AFHttpClient+Permission.h"
#import "ZdExchangFriendViewController.h"

@interface ExchangPermissionViewController ()
@property (nonatomic,strong)UILabel * ruleNameLabel;
@property (nonatomic,strong)UIButton * ruleNameBtn;
@property (nonatomic,strong)UILabel * toushiLabel;
@property (nonatomic,strong)UIButton * toushiBtn;


@property (nonatomic,strong)UIButton * bigBtn;
@property (nonatomic,strong)UIView * centerwhteView;
@property (nonatomic,strong) UITextField * exchangeTextfield;

@property (nonatomic,strong)UIButton * allBtn;
@property (nonatomic,strong)UIButton * friendBtn;
@property (nonatomic,strong)UIButton * zdBtn;

@end

@implementation ExchangPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"as_exchangrule", nil)];
    self.view.backgroundColor = GRAY_COLOR;
  
}

-(void)setupData{
    [super setupData];
}

-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.superview);
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.height.mas_equalTo(120);
    }];
    
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [topView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel.superview).offset(12);
        make.right.equalTo(lineLabel.superview).offset(-12);
        make.centerY.equalTo(lineLabel.superview.mas_centerY);
        make.height.mas_equalTo(0.5);
        
        
    }];
    
    UILabel * leftLabel1 = [[UILabel alloc]init];
    leftLabel1.text = NSLocalizedString(@"as_rulename", nil);
    leftLabel1.textColor = [UIColor blackColor];
    leftLabel1.font = [UIFont systemFontOfSize:18];
    [topView addSubview:leftLabel1];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel1.superview).offset(12);
        make.top.equalTo(leftLabel1.superview).offset(20);
        
        
    }];
    
    
    UILabel * leftLabel2 = [[UILabel alloc]init];
    leftLabel2.text = NSLocalizedString(@"as_Accessfood", nil);
    leftLabel2.textColor = [UIColor blackColor];
    leftLabel2.font = [UIFont systemFontOfSize:18];
    [topView addSubview:leftLabel2];
    [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel2.superview).offset(12);
        make.top.equalTo(lineLabel.mas_bottom).offset(20);
    }];
    
    _ruleNameLabel = [[UILabel alloc]init];
    _ruleNameLabel.text = NSLocalizedString(@"as_shuruname", nil);
    _ruleNameLabel.textColor =[UIColor blackColor];
    _ruleNameLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:_ruleNameLabel];
    [_ruleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ruleNameLabel.superview).offset(-12);
        make.top.equalTo(_ruleNameLabel.superview).offset(20);
        
        
    }];
    
    _ruleNameBtn = [[UIButton alloc]init];
    _ruleNameBtn.backgroundColor = [UIColor clearColor];
    [_ruleNameBtn addTarget:self action:@selector(rulebuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_ruleNameBtn];
    [_ruleNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //  make.left.equalTo(_ruleNameBtn.mas_right).offset(20);
        make.right.equalTo(_ruleNameBtn.superview);
        make.top.equalTo(_ruleNameBtn.superview);
        make.bottom.equalTo(lineLabel.mas_bottom);
        make.width.mas_equalTo(300);
    }];
    
    _toushiLabel = [[UILabel alloc]init];
    _toushiLabel.text  = NSLocalizedString(@"as_allow", nil);
    _toushiLabel.textColor = [UIColor blackColor];
    _toushiLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:_toushiLabel];
    [_toushiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ruleNameLabel.mas_right);
        make.top.equalTo(lineLabel.mas_bottom).offset(20);
        
    }];
    
    _toushiBtn = [[UIButton alloc]init];
    _toushiBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:_toushiBtn];
    [_toushiBtn addTarget:self action:@selector(toushubuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_toushiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toushiBtn.superview);
        make.top.equalTo(lineLabel.mas_bottom);
        make.bottom.equalTo(_toushiBtn.superview);
        make.width.mas_equalTo(300);
        
    }];
    
    UIView * downView = [[UIView alloc]init];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView.superview);
        make.right.equalTo(downView.superview);
        make.top.equalTo(topView.mas_bottom).offset(8);
        make.height.mas_equalTo(121);
        
    }];
    
    UILabel * erbiLabel = [[UILabel alloc]init];
    erbiLabel.text = NSLocalizedString(@"as_setwhocan", nil);
    erbiLabel.textColor = [UIColor blackColor];
    erbiLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:erbiLabel];
    [erbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(erbiLabel.superview).offset(23);
        make.left.equalTo(erbiLabel.superview).offset(12);
    }];
    
    
    _allBtn = [[UIButton alloc]init];
    _allBtn.layer.borderColor = LIGHT_GRAYdcdc_COLOR.CGColor;
    _allBtn.layer.borderWidth = 1;
    _allBtn.layer.cornerRadius = 3;
    _allBtn.backgroundColor = [UIColor whiteColor];
    [_allBtn setTitle:NSLocalizedString(@"as_all", nil) forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _allBtn.selected = NO;
    [_allBtn addTarget:self action:@selector(allButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_allBtn];
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(33);
        make.top.equalTo(erbiLabel.mas_bottom).offset(24);
        make.left.equalTo(_allBtn.superview).offset(31);
    }];
    
    
    _friendBtn = [[UIButton alloc]init];
    _friendBtn.layer.borderColor = LIGHT_GRAYdcdc_COLOR.CGColor;
    _friendBtn.layer.borderWidth = 1;
    _friendBtn.layer.cornerRadius = 3;
    _friendBtn.backgroundColor = [UIColor whiteColor];
    [_friendBtn setTitle:NSLocalizedString(@"as_friend", nil) forState:UIControlStateNormal];
    [_friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_friendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _friendBtn.selected = NO;
    [_friendBtn addTarget:self action:@selector(friendButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_friendBtn];
    [_friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_allBtn.mas_right).offset(32);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(33);
        make.top.equalTo(erbiLabel.mas_bottom).offset(24);
        
    }];
    
     NSString * langev = langeC;
    _zdBtn = [[UIButton alloc]init];
    _zdBtn.layer.borderColor = LIGHT_GRAYdcdc_COLOR.CGColor;
    _zdBtn.layer.borderWidth = 1;
    _zdBtn.layer.cornerRadius = 3;
    _zdBtn.backgroundColor = [UIColor whiteColor];
    if ([langev isEqualToString:@"zh-Hans-CN"]) {
        [_zdBtn setTitle:@"指定好友" forState:UIControlStateNormal];
    }else{
        [_zdBtn setTitle:@"Choose" forState:UIControlStateNormal];
    }

    [_zdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _zdBtn.selected = NO;
    [_zdBtn addTarget:self action:@selector(zdbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_zdBtn];
    [_zdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_friendBtn.mas_right).offset(32);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(33);
        make.top.equalTo(erbiLabel.mas_bottom).offset(24);
        
    }];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = GREEN_COLOR;
    [sureBtn setTitle:NSLocalizedString(@"as_sureee", nil) forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    sureBtn.layer.cornerRadius = 3;
    [sureBtn addTarget:self action:@selector(sureButtonTouchh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(sureBtn.superview.mas_centerX);
        make.bottom.equalTo(sureBtn.superview).offset(-87);
    }];
    
    _ruleNameLabel.text = _ruleName;
    
    if ([_istsNum isEqualToString:@"0"]) {
        _toushiLabel.text = NSLocalizedString(@"me_noshare", nil);
    }else{
        _toushiLabel.text = NSLocalizedString(@"as_allow", nil);
    }
    if ([_objectStr isEqualToString:@"all"]) {
        [self allButtonTouch];
    }else if ([_objectStr isEqualToString:@"friend"]){
        [self friendButtonTouch];
    }else if ([_objectStr isEqualToString:@"zd"]){
        _allBtn.selected = NO;
        _allBtn.backgroundColor = [UIColor whiteColor];
        _zdBtn.selected = YES;
        _zdBtn.backgroundColor = GREEN_COLOR;
        _friendBtn.selected = NO;
        _friendBtn.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    
}

-(void)sureButtonTouchh{
//    if (_isXiugai == NO) {
//        [[AppUtil appTopViewController] showHint:@"请输入规则名称"];
//        return;
//    }
    if (_allBtn.selected == NO && _friendBtn.selected == NO && _zdBtn.selected == NO) {
        [[AppUtil appTopViewController] showHint:NSLocalizedString(@"as_pleaseselewho", nil)];
        return;
    }
    
    NSString * tsNum = @"";
    if ([_toushiLabel.text isEqualToString:NSLocalizedString(@"me_noshare",nil)]) {
        tsNum = @"0";
    }else{
        tsNum = @"1";
    }
    
    NSString * objectStr = @"";
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSString * friendstr = @"";

    if (_allBtn.selected == YES) {
        objectStr = @"all";
    }else if (_friendBtn.selected == YES){
        objectStr = @"friend";
    }else if (_zdBtn.selected == YES){
        objectStr = @"zd";
        NSUserDefaults * FriendUserDefaults = [NSUserDefaults standardUserDefaults];
        array  = [FriendUserDefaults objectForKey:@"friendesId"];
        friendstr =  [array componentsJoinedByString:@","];

    }
    //指定好友还没写
    
    [self showHudInView:self.view hint:NSLocalizedString(@"as_add", nil)];
    
    [[AFHttpClient sharedAFHttpClient]ruleModifyInfoWithMid:_ridStr rulesname:_ruleNameLabel.text  object:objectStr friends:friendstr tsnum:tsNum complete:^(BaseModel *model) {
       
        if (model) {
            NSString * langev = langeC;
            if ([langev isEqualToString:@"zh-Hans-CN"]) {
                [[AppUtil appTopViewController]showHint:model.retDesc];
            }else{
                [[AppUtil appTopViewController]showHint:@"Rule is changed"];
            }
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ruleShuaxin" object:nil];
        }
        
         [self hideHud];
        
    }];
    
}

-(void)allButtonTouch{
    _allBtn.selected = YES;
    _allBtn.backgroundColor = GREEN_COLOR;
    _zdBtn.selected = NO;
    _zdBtn.backgroundColor = [UIColor whiteColor];
    _friendBtn.selected = NO;
    _friendBtn.backgroundColor = [UIColor whiteColor];
    
    
}


-(void)friendButtonTouch{
    _allBtn.selected = NO;
    _allBtn.backgroundColor = [UIColor whiteColor];
    _zdBtn.selected = NO;
    _zdBtn.backgroundColor = [UIColor whiteColor];
    _friendBtn.selected = YES;
    _friendBtn.backgroundColor = GREEN_COLOR;
    
}

-(void)zdbuttonTouch{
    _allBtn.selected = NO;
    _allBtn.backgroundColor = [UIColor whiteColor];
    _zdBtn.selected = YES;
    _zdBtn.backgroundColor = GREEN_COLOR;
    _friendBtn.selected = NO;
    _friendBtn.backgroundColor = [UIColor whiteColor];
    
    ZdExchangFriendViewController   * zdFriendvc= [[ZdExchangFriendViewController alloc]init];
    zdFriendvc.ridd = _ridStr;
    [self.navigationController pushViewController:zdFriendvc animated:NO];

}




-(void)rulebuttonTouch{
    FuckLog(@"哈哈");
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
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = NSLocalizedString(@"as_rulename", nil);
    nameLabel.textColor = [UIColor blackColor];
    // nameLabel.text = [AccountManager sharedAccountManager].loginModel.nickname;
    nameLabel.font = [UIFont systemFontOfSize:17.5];
    [_centerwhteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLabel.superview.mas_centerX);
        make.top.equalTo(nameLabel.superview).offset(14);
        
    }];
    
    _exchangeTextfield = [[UITextField alloc]init];
    //if (_isXiugai == NO) {
       // _exchangeTextfield.text = @"";
   // }else{
        _exchangeTextfield.text = _ruleNameLabel.text;
   // }
    _exchangeTextfield.placeholder = NSLocalizedString(@"as_shuruname", nil);
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
    danceLabel.text = NSLocalizedString(@"Cancel_bind", nil);
    danceLabel.textColor = [UIColor blackColor];
    danceLabel.font = [UIFont systemFontOfSize:17];
    [_centerwhteView addSubview:danceLabel];
    [danceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shuLabel.mas_left).offset(-48);
        make.top.equalTo(henglineLabel.mas_bottom).offset(15);
    }];
    
    UILabel * sureLabel = [[UILabel alloc]init];
    sureLabel.text = NSLocalizedString(@"Sure_bind", nil);
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
      [_exchangeTextfield resignFirstResponder];
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
}
-(void)namesurebuttonTouch{
  
    if ([AppUtil isBlankString:_exchangeTextfield.text]) {
        [[AppUtil appTopViewController] showHint:NSLocalizedString(@"as_shuruname", nil)];
        return;
    }
    if (_exchangeTextfield.text.length > 11) {
        [[AppUtil appTopViewController] showHint:NSLocalizedString(@"as_zishu", nil)];
        return;
    }
      [_exchangeTextfield resignFirstResponder];
    _ruleNameLabel.text = _exchangeTextfield.text;
    _ruleNameLabel.textColor = [UIColor blackColor];
    _bigBtn.hidden = YES;
    _centerwhteView.hidden = YES;
  
}

-(void)bigbuttonTouch{
//    _bigBtn.hidden = YES;
//    _centerwhteView.hidden = YES;
}

-(void)toushubuttonTouch{
    if ([_toushiLabel.text isEqualToString:NSLocalizedString(@"as_allow", nil)]) {
        _toushiLabel.text = NSLocalizedString(@"me_noshare", nil);
    }else{
        _toushiLabel.text = NSLocalizedString(@"as_allow",nil);
    }
}










@end
