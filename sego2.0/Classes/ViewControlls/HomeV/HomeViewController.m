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


static NSString * cellId = @"hometableviewcellId";
@interface HomeViewController ()
@property (nonatomic,strong)CycleScrollView * topScrollView;
@property (nonatomic,strong)NSMutableArray * Imagedatasouce;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Imagedatasouce = [[NSMutableArray alloc]init];
    [self setNavTitle:@"我的收藏"];
    [self showBarButton:NAV_RIGHT title:@"收藏" fontColor:GREEN_COLOR hide:NO];
    

}

-(void)doRightButtonTouch{

    FuckLog(@"dada");
    




}





-(void)setupView{
    [super setupView];
      _topScrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 170 * W_Hight_Zoom) animationDuration:3];
     self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableHeaderView = _topScrollView;
    
   // [self initRefreshView];

    
    
    
}
-(void)setupData{
    [super setupData];
    //topview
//    [[AFHttpClient sharedAFHttpClient]queryRecommendWithcomplete:^(BaseModel *model) {
//        
//        [self.dataSourceImage addObjectsFromArray:model.list];
//        
//       // [self initTopView];
//    } failure:^{
//        
//    }];
//
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
       // NSString * i = aidList[pagIndex];
        //featureVc.number = i;
        //[self.navigationController pushViewController:featureVc animated:YES];
        
    };


}

#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.dataSource.count;
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    //tabview隐藏点击效果和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
