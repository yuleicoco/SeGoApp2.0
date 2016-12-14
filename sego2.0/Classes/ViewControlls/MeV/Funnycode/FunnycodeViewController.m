//
//  FunnycodeViewController.m
//  sego2.0
//
//  Created by czx on 16/12/13.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "FunnycodeViewController.h"
#import "AFHttpClient+FunnyCode.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface FunnycodeViewController ()
@property (nonatomic,strong)UILabel * doumaLabel;
@property (nonatomic,strong)UILabel * toushiLabel;
@property (nonatomic,strong)UILabel * timeoverLabel;
@property (nonatomic,strong)UIButton * toushiBtn;
@property (nonatomic,strong)UIButton * doumaBtn;
@property (nonatomic,strong)UIButton * shixiaoBtn;
@property (nonatomic,strong)NSDictionary * sourceDic;
@property (nonatomic,assign)BOOL isShare;
@end

@implementation FunnycodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
    _isShare = NO;
    _sourceDic = [[NSDictionary alloc]init];
    [self setNavTitle:@"逗码"];
    [self showBarButton:NAV_RIGHT title:@"分享" fontColor:LIGHT_GRAYdcdc_COLOR hide:NO];
    
}
-(void)setupData{
    [super setupData];
    [self queryCode];
    
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
        make.height.mas_equalTo(181);
        
    }];
    
    UILabel * lineLabel1 = [[UILabel alloc]init];
    lineLabel1.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [topView addSubview:lineLabel1];
    [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel1.superview).offset(12);
        make.right.equalTo(lineLabel1.superview).offset(-12);
        make.top.equalTo(lineLabel1.superview).offset(60);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UILabel * lineLabel2 = [[UILabel alloc]init];
    lineLabel2.backgroundColor = LIGHT_GRAYdcdc_COLOR;
    [topView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel2.superview).offset(12);
        make.right.equalTo(lineLabel2.superview).offset(-12);
        make.top.equalTo(lineLabel1.mas_bottom).offset(60);
        make.height.mas_equalTo(0.5);
        
    }];
    
    NSArray * textArray = @[@"有效逗码",@"访问投食",@"有效时间"];
    for (int i = 0 ; i < 3 ; i++ ) {
        UILabel * testLabel = [[UILabel alloc]init];
        testLabel.textColor = [UIColor blackColor];
        testLabel.font = [UIFont systemFontOfSize:18];
        testLabel.text = textArray[i];
        [topView addSubview:testLabel];
        [testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo()
            make.top.equalTo(testLabel.superview).offset(20 +i * 60);
            make.left.equalTo(testLabel.superview).offset(12);
            
        }];
        
    }
    
    _doumaLabel = [[UILabel alloc]init];
    _doumaLabel.textColor = [UIColor blackColor];
    _doumaLabel.font = [UIFont systemFontOfSize:18];
    _doumaLabel.text = @"暂无";
    [topView addSubview:_doumaLabel];
    [_doumaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_doumaLabel.superview).offset(-12);
        make.top.equalTo(_doumaLabel.superview).offset(20);
        
        
    }];
    
    _toushiLabel = [[UILabel alloc]init];
    _toushiLabel.text = @"允许";
    _toushiLabel.textColor = [UIColor blackColor];
    _toushiLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:_toushiLabel];
    [_toushiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toushiLabel.superview).offset(-12);
        make.top.equalTo(lineLabel1.mas_bottom).offset(20);

    }];
    
    _toushiBtn = [[UIButton alloc]init];
    _toushiBtn.backgroundColor = [UIColor clearColor];
    [_toushiBtn addTarget:self action:@selector(toushiButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_toushiBtn];
    [_toushiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toushiBtn.superview);
        make.top.equalTo(lineLabel1.mas_bottom);
        make.bottom.equalTo(lineLabel2.mas_top);
        make.width.mas_equalTo(200);
    }];
    _timeoverLabel = [[UILabel alloc]init];
    _timeoverLabel.textColor = [UIColor blackColor];
    _timeoverLabel.text = @"暂无";
    _timeoverLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:_timeoverLabel];
    [_timeoverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeoverLabel.superview).offset(-12);
        make.top.equalTo(lineLabel2.mas_bottom).offset(20);
    }];

    _doumaBtn = [[UIButton alloc]init];
    _doumaBtn.backgroundColor = GREEN_COLOR;
    [_doumaBtn setTitle:@"生成我的逗码" forState:UIControlStateNormal];
    [_doumaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doumaBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _doumaBtn.layer.cornerRadius =3;
    [_doumaBtn addTarget:self action:@selector(doumaButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doumaBtn];
    [_doumaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(55);
        make.top.equalTo(topView.mas_bottom).offset(295);
        make.centerX.equalTo(_doumaBtn.superview.mas_centerX);
        
    }];
    
    
    _shixiaoBtn = [[UIButton alloc]init];
    _shixiaoBtn.backgroundColor = GREEN_COLOR;
    [_shixiaoBtn setTitle:@"立即失效" forState:UIControlStateNormal];
    [_shixiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shixiaoBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _shixiaoBtn.layer.cornerRadius =3;
    [_shixiaoBtn addTarget:self action:@selector(shixiaoBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shixiaoBtn];
    [_shixiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(55);
        make.top.equalTo(topView.mas_bottom).offset(295);
        make.centerX.equalTo(_shixiaoBtn.superview.mas_centerX);
        
    }];
    
    
    

}

-(void)toushiButtonTouch{
    if ([_toushiLabel.text isEqualToString:@"允许"]) {
        _toushiLabel.text = @"不允许";
    }else{
        _toushiLabel.text = @"允许";
    }

}


-(void)doumaButtonTouch{
    NSString * tsStr = @"";
    if ([_toushiLabel.text isEqualToString:@"允许"]) {
        tsStr = @"1";
    }else{
        tsStr = @"0";
    }
    
    [[AFHttpClient sharedAFHttpClient]generatePlayCodeWithMid:[AccountManager sharedAccountManager].loginModel.mid tsnum:tsStr complete:^(BaseModel *model) {
       // if (model) {
            [self queryCode];
       // }
        
    }];

}

-(void)shixiaoBtnTouch{
    [[AFHttpClient sharedAFHttpClient]dePlayCodeWithPlayCode:_sourceDic[@"playcode"] complete:^(BaseModel *model) {
        [self queryCode];
    }];

}




-(void)queryCode{
    [[AFHttpClient sharedAFHttpClient]queryPlayCodeWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        _sourceDic = model.retVal;
        if ([_sourceDic count] == 0 || [_sourceDic[@"status"] isEqualToString:@"0"] ) {
            _doumaLabel.text = @"暂无";
            _toushiLabel.text = @"允许";
            _timeoverLabel.text = @"暂无";
            _shixiaoBtn.hidden = YES;
            _doumaBtn.hidden = NO;
            _isShare = NO;
            _toushiBtn.userInteractionEnabled=YES;
            [self showBarButton:NAV_RIGHT title:@"分享" fontColor:LIGHT_GRAYdcdc_COLOR hide:NO];
        }else{
            _shixiaoBtn.hidden = NO;
            _doumaBtn.hidden = YES;
            _isShare = YES;
            _toushiLabel.textColor = LIGHT_GRAYdcdc_COLOR;
            _toushiBtn.userInteractionEnabled = NO;
            [self showBarButton:NAV_RIGHT title:@"分享" fontColor:GREEN_COLOR hide:NO];
            _doumaLabel.text = _sourceDic[@"playcode"];
            
            if ([_sourceDic[@"tsnum"] isEqualToString:@"0"]) {
                _toushiLabel.text = @"不允许";
            }else{
                _toushiLabel.text = @"允许";
            }
            _timeoverLabel.text = _sourceDic[@"endtime"];
            
        }
    
    }];

}



-(void)doRightButtonTouch{
    if (_isShare == NO) {
        //什么都不做
    }else{
        FuckLog(@"分享");
    
        // 1、创建分享参数
        NSArray *imageArray = @[ [UIImage imageNamed:@"sego.png"] ];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数
        
        
        // QQ空间分享失败的原因为 image url title 不能为nil 是一种图文链接的方式
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams
             SSDKSetupShareParamsByText:[NSString stringWithFormat:@"赛果分享[%@]此逗码%@之前有效，复制这条信息，打开赛果不倒蛋软件，即可控制分享者的设备开启远程互动(软件下载地址：http://www.segopet.com/site/download.jsp)", _doumaLabel.text,_timeoverLabel.text]
             images:nil
             url:nil
             title:@"赛果逗码分享"
             type:SSDKContentTypeAuto];
            
            
            // 2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet: nil items:nil shareParams:shareParams onShareStateChanged:^(
                                                                                                        SSDKResponseState state, SSDKPlatformType platformType,
                                                                                                        NSDictionary *userData, SSDKContentEntity *contentEntity,
                                                                                                        NSError *error, BOOL end) {
                
                switch (state) {
                    case SSDKResponseStateSuccess: {
                        UIAlertView *alertView =
                        [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                        [alertView show];
                            break;
                    }
                    case SSDKResponseStateFail: {
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"分享失败"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
                        
                        [alert show];
                        [[[UIApplication sharedApplication] keyWindow] resignFirstResponder];
                        
                        break;
                    }
                    default:
                        break;
                }
            }];
            
        }
        
    }

        
    }












@end
