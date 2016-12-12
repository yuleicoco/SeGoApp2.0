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
    [self setNavTitle:@"详情"];
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
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 39)];
    downView.backgroundColor = [UIColor whiteColor];
    
    _downLabel = [[UILabel alloc]init];
    _downLabel.textColor = [UIColor blackColor];
    _downLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:_downLabel];
    [_downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downLabel.superview).offset(12);
        make.centerY.equalTo(_downLabel.superview.mas_centerY);

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
    [dancelBtn setTitle:@"删除" forState:UIControlStateNormal];
    [dancelBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    dancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [dancelBtn addTarget:self action:@selector(dancelButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_bottomview addSubview:dancelBtn];
    [dancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dancelBtn.superview).offset(79);
        make.centerY.equalTo(dancelBtn.superview.mas_centerY);
        
    }];
    
    
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
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
    
    
     
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"top1.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
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

    if ([model.type isEqualToString:@"p"]) {
        cell.videoImage.hidden = YES;
        [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:_resoucesArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
        [cell.centerImage .image imageByScalingProportionallyToSize:CGSizeMake(375, CGFLOAT_MAX)];
    }else{
     //  [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
        cell.videoImage.hidden = NO;
        if (model.cutImage) {
            cell.centerImage.image = model.cutImage;
        }else{
            [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"sego1.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    //NSInteger i = sender.tag - 6777;
//    NSLog(@"%ld",i);
    //感觉多此一举，这里只需要点击时间就行了，反正传值
    HomeDetailModel * model = self.dataSource[0];

    if ([model.type isEqualToString:@"p"]) {
        LargeViewController * largeVC =[[LargeViewController alloc]initWithNibName:@"LargeViewController" bundle:nil];
        largeVC.dataArray = _resoucesArray;
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
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除此收藏？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
          [self showHudInView:self.view hint:@"正在删除..."];
        [[AFHttpClient sharedAFHttpClient]delArticleWithMid:[AccountManager sharedAccountManager].loginModel.mid aid:_aid complete:^(BaseModel *model) {
            if (model) {
                [[AppUtil appTopViewController]showHint:model.retDesc];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            [self hideHud];
            
            
        }];
        
        
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];



}



@end
