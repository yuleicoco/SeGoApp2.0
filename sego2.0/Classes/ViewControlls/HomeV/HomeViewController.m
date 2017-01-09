//
//  HomeViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "HomeViewController.h"
#import "CycleScrollView.h"
#import "AFHttpClient+Article.h"
#import "RecommendModel.h"
#import "HomeTableViewCell.h"
#import "UIImage-Extensions.h"
#import "RepositoryViewController.h"
#import "ArticlesModel.h"
#import "HomeDetailViewController.h"
#import "RecommendViewController.h"

static NSString * cellId = @"hometableviewcellId";
@interface HomeViewController ()
@property (nonatomic,strong)CycleScrollView * topScrollView;
@property (nonatomic,strong)NSMutableArray * Imagedatasouce;

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // _indexp = [[NSIndexPath alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada) name:@"shuaxin" object:nil];
    //dianzanbian
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada12:) name:@"deleshuaxin" object:nil];
    
    
}

-(void)dada{
    [self initRefreshView];
}

-(void)dada12:(NSNotification *)nsnotifiction{
    [self initRefreshView];
}




- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavTitle:NSLocalizedString(@"tab_collect", nil)];
    [self showBarButton:NAV_RIGHT title:NSLocalizedString(@"tabSquare", nil) fontColor:GREEN_COLOR hide:NO];
    

}

-(void)doRightButtonTouch{
   
    NSString * str  =  [Defaluts objectForKey:@"deviceNumber"];
    NSString * str1  = [AccountManager sharedAccountManager].loginModel.deviceno;
    if ([AppUtil isBlankString:str] && [AppUtil isBlankString:str1]) {
        [[AppUtil appTopViewController]showHint:@"您还未绑定设备"];
        
    }else{
        RepositoryViewController * repVc = [[RepositoryViewController alloc]init];
        [self.navigationController pushViewController:repVc animated:NO];
        
    }

    
    
    
}

-(void)setupView{
    [super setupView];
     self.Imagedatasouce = [[NSMutableArray alloc]init];
      _topScrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 170 * W_Hight_Zoom) animationDuration:3];
     self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - TAB_BAR_HEIGHT);
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableHeaderView = _topScrollView;
    [self initRefreshView];

    
    
    
}
-(void)setupData{
    [super setupData];
    [[AFHttpClient sharedAFHttpClient]querRecommedcomplete:^(BaseModel *model) {
        [self.Imagedatasouce addObjectsFromArray:model.list];
        [self initTopView];
    }];
    
    
    
}
-(void)initTopView{
    NSMutableArray * arrList =[[NSMutableArray alloc]init];
    NSMutableArray * textList =[[NSMutableArray alloc]init];
    NSMutableArray * aidList = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.Imagedatasouce.count; i++) {
        RecommendModel * model  = self.Imagedatasouce[i];
        UIImageView * pImageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 170 * W_Hight_Zoom)];
        pImageView1.contentMode = UIViewContentModeCenter;
        pImageView1.layer.masksToBounds = YES;
        
        [pImageView1 sd_setImageWithURL:[NSURL URLWithString:model.frontcover] placeholderImage:[UIImage imageNamed:@"loginback.png"]];
      //  [pImageView1 setImage:[UIImage imageNamed:@"loginback.png"]];
        pImageView1.image = [pImageView1.image imageByScalingProportionallyToSize:CGSizeMake(self.view.width, CGFLOAT_MAX)];

        //[textList addObject:_imageArr[i][@"title"]];
        [textList addObject:model.title];
        [arrList addObject:pImageView1];
        [aidList addObject:model.aid];
    }
    
    _topScrollView.textArr = textList;
    _topScrollView.fetchContentViewAtIndex=  ^UIView *(NSInteger pageIndex){
        return arrList[pageIndex];
    };
    
    _topScrollView.totalPagesCount = ^NSInteger(void){
        return arrList.count;
    };
    
    _topScrollView.TapActionBlock = ^(NSInteger pagIndex){
        
        //这里写点击事件
        // NSLog(@"%@",aidList[pagIndex]);
     //   FeaturedViewController * featureVc = [[FeaturedViewController alloc]init];
        //  NSInteger i  = (NSInteger)aidList[pagIndex];
        RecommendViewController * recommVc = [[RecommendViewController alloc]init];
        NSString * i = aidList[pagIndex];
        recommVc.aid = i;
        //featureVc.number = i;
        [self.navigationController pushViewController:recommVc animated:NO];
        
        
    };
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]queryArticlesWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        if (page == START_PAGE_INDEX) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.list];
        } else {
            [self.dataSource addObjectsFromArray:model.list];
        }
        
        if (model.list.count < REQUEST_PAGE_SIZE){
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView reloadData];
        [self handleEndRefresh];
    }];


}

#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 271;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     //_indexp = indexPath;
    ArticlesModel * model = self.dataSource[indexPath.row];
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.contentLabel.text = model.content;
   // [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    
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
    
    if ([model.type isEqualToString:@"v"]) {
        cell.videoImage.hidden = NO;
    }else{
        cell.videoImage.hidden = YES;
    }
    
    cell.timeLabel.text = model.publishtime;
    
    //tabview隐藏点击效果和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
     ArticlesModel * model = self.dataSource[indexPath.row];
     NSLog(@"%@",model.content);
    HomeDetailViewController * detailVc = [[HomeDetailViewController alloc]init];
    detailVc.aid = model.aid;
    //detailVc.index = indexPath;
    //NSInteger i = indexPath.row;
    //detailVc.index = i;
    [self.navigationController pushViewController:detailVc animated:NO];


}







@end
