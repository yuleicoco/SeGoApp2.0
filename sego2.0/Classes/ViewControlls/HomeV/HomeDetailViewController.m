//
//  HomeDetailViewController.m
//  sego2.0
//
//  Created by czx on 16/12/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "AFHttpClient+Article.h"
#import "HomeDetailTableViewCell.h"
#import "HomeDetailModel.h"
#import "UIImage-Extensions.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LargeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

static NSString * cellId = @"homedetailviewellId";
@interface HomeDetailViewController ()
@property (nonatomic,strong)UIView * bottomview;
@property (nonatomic,strong)NSArray * resoucesArray;
@property (nonatomic,strong)UILabel * topLabel;
@property (nonatomic,strong)UILabel * downLabel;

@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"details_d", nil)];
    self.view.backgroundColor = GRAY_COLOR;
    _resoucesArray = [[NSArray alloc]init];
}


-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 21)];
    topView.backgroundColor = [UIColor whiteColor];
    _topLabel = [[UILabel alloc]init];
    _topLabel.textColor = [UIColor blackColor];
    _topLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topLabel.superview).offset(12);
        make.centerY.equalTo(_topLabel.superview.mas_centerY).offset(6);
        
    }];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375 * W_Wide_Zoom, 50 * W_Hight_Zoom)];
    downView.backgroundColor = [UIColor whiteColor];
    
    _downLabel = [[UILabel alloc]init];
    _downLabel.textColor = [UIColor blackColor];
    _downLabel.font = [UIFont systemFontOfSize:18];
    _downLabel.numberOfLines = 2;
    [downView addSubview:_downLabel];
    [_downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downLabel.superview).offset(12);
        make.centerY.equalTo(_downLabel.superview.mas_centerY);
        make.width.mas_equalTo(360 * W_Wide_Zoom);
    }];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-60);
    [self.tableView registerClass:[HomeDetailTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   // [self initRefreshView];
    self.tableView.backgroundColor = GRAY_COLOR;
    self.tableView.tableHeaderView = topView;
    self.tableView.tableFooterView = downView;

    _bottomview = [[UIView alloc]init];
    _bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomview];
    [_bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomview.superview);
        make.right.equalTo(_bottomview.superview);
        make.bottom.equalTo(_bottomview.superview);
        make.height.mas_equalTo(50);
        
    }];
    
    
    UIButton * dancelBtn = [[UIButton alloc]init];
    [dancelBtn setTitle:NSLocalizedString(@"friends_dele", nil) forState:UIControlStateNormal];
    [dancelBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    dancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [dancelBtn addTarget:self action:@selector(dancelButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_bottomview addSubview:dancelBtn];
    [dancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dancelBtn.superview).offset(79);
        make.centerY.equalTo(dancelBtn.superview.mas_centerY);
        
    }];
    
    
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setTitle:NSLocalizedString(@"details_share", nil) forState:UIControlStateNormal];
    [shareBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [shareBtn addTarget:self action:@selector(ShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomview addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareBtn.superview).offset(-79);
        make.centerY.equalTo(shareBtn.superview.mas_centerY);
    }];
    
    
    
    
    
    
    
    
}



// 分享

- (void)ShareBtn:(UIButton *)sender
{
    
    
     
    NSString * strUrl =[NSString stringWithFormat:@"http://180.97.81.213:15102/clientAction.do?method=client&nextPage=/s/article/article.jsp&aid=%@&mid=%@&access=outside",_aid,[AccountManager sharedAccountManager].loginModel.mid];
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"sego.png"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"赛果不倒蛋"
                                         images:@[@"https://thumbnail0.baidupcs.com/thumbnail/59010f7a5017de8ab3e17c2dd443962e?fid=512075035-250528-354982388780578&time=1482897600&rt=sh&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-fnKKMcZ1wUNAeqNIp9wk7KIME%2Fk%3D&expires=8h&chkv=0&chkbd=0&chkpc=&dp-logid=8407531671032735195&dp-callid=0&size=c710_u400&quality=100"]
                                            url:[NSURL URLWithString:strUrl]
                                          title:@"赛果分享"
                                           type:SSDKContentTypeAuto];
        [ShareSDK showShareActionSheet:nil  items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    
}



-(void)setupData{
    [super setupData];
    [[AFHttpClient sharedAFHttpClient]queryByAid:_aid complete:^(BaseModel *model) {
        [self.dataSource addObjectsFromArray:model.list];
             for (HomeDetailModel* homeDetailModel in model.list) {
                 _topLabel.text = homeDetailModel.publishtime;
                 _downLabel.text = homeDetailModel.content;
                _resoucesArray =  [homeDetailModel.resources componentsSeparatedByString:@","];
             }
        [self.tableView reloadData];
    }];
    
}


#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resoucesArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 232*W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    HomeDetailModel * model = self.dataSource[0];
    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
    }

    NSMutableArray * wocaca = [[NSMutableArray alloc]init];
    if ([model.type isEqualToString:@"p"]) {
        cell.videoImage.hidden = YES;
        if (wocaca.count>0) {
            cell.centerImage.image = wocaca[indexPath.row];
        }else{
        [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:_resoucesArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"bigsego.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.centerImage.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                [wocaca addObject:cell.centerImage.image];
            }
        }];
        
}
    }else{
        cell.videoImage.hidden = NO;
        if (model.cutImage) {
            cell.centerImage.image = model.cutImage;
        }else{
            [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"bigsego.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.centerImage.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                    model.cutImage = cell.centerImage.image;
                }
            }];
        }
    }
    //cell.centerImage.tag = indexPath.row + 603;
    cell.touchBtn.tag = indexPath.row + 6777;
    [cell.touchBtn addTarget:self action:@selector(celltouchubuttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)celltouchubuttonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 6777;
//    NSLog(@"%ld",i);
    //感觉多此一举，这里只需要点击时间就行了，反正传值
    HomeDetailModel * model = self.dataSource[0];

    if ([model.type isEqualToString:@"p"]) {
        LargeViewController * largeVC =[[LargeViewController alloc]initWithNibName:@"LargeViewController" bundle:nil];
        largeVC.dataArray = _resoucesArray;
        largeVC.indexxx = i;
        [self.navigationController pushViewController:largeVC animated:NO];
        
        
    }else{
        MPMoviePlayerViewController * vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:model.resources]];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
        [self presentMoviePlayerViewControllerAnimated:vc];
    
    }
    

}

-(void)dancelButtonTouch{
     NSString * langvage = langeC;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"details_tipps", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure_bind", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
          [self showHudInView:self.view hint:NSLocalizedString(@"details_dele", nil)];
        [[AFHttpClient sharedAFHttpClient]delArticleWithMid:[AccountManager sharedAccountManager].loginModel.mid aid:_aid complete:^(BaseModel *model) {
            if ([model.retCode isEqualToString:@"0000"]) {
                if ([langvage isEqualToString:@"zh-Hans-CN"]) {
                     [[AppUtil appTopViewController]showHint:model.retDesc];
                }else{
                     [[AppUtil appTopViewController]showHint:@"Delete the success"];
                }
               
              //  [self.navigationController popToRootViewControllerAnimated:NO];
                [self.navigationController popViewControllerAnimated:NO];
//                NSUserDefaults * userdafaults = [NSUserDefaults standardUserDefaults];
//                NSString * str = [NSString stringWithFormat:@"%ld",(long)_index];
//                [userdafaults setObject:str forKey:@"wocaonimama"];
                
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"deleshuaxin" object:nil];
                
            }
            [self hideHud];
            
            
        }];
        
        
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel_bind", nil)style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];



}



@end
