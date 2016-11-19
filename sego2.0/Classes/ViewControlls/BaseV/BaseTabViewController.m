//
//  BaseTabViewController.m
//  sebot
//
//  Created by yulei on 16/6/16.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseTabViewController.h"

@interface BaseTabViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setupData{
    _dataSource = [NSMutableArray array];
    _dicSource =[[NSMutableArray alloc]init];
    
}

- (void)setupView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.bGroupView ? UITableViewStyleGrouped : UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
}
- (void)updateData
{
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  初始化上拉下拉刷新block
 */
- (void)initRefreshView
{
    __typeof (&*self) __weak weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = START_PAGE_INDEX;
        [weakSelf loadDataSourceWithPage:weakSelf.pageIndex];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ((weakSelf.pageIndex )* REQUEST_PAGE_SIZE == weakSelf.dataSource.count) {
            weakSelf.pageIndex++;
            [weakSelf loadDataSourceWithPage:weakSelf.pageIndex];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    }];
    
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  结束刷新
 */
-(void)handleEndRefresh{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

/**
 *  加载分页方法，在子类重写
 */
- (void)loadDataSourceWithPage:(int)page {
    
    
}


//- (UIImage *)cutImage:(UIImage*)image
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef = nil;
//    UIImageView *_headerView =[[UIImageView alloc]initWithFrame:CGRectMake(0*W_Wide_Zoom, 0*W_Hight_Zoom, 375*W_Wide_Zoom, 250*W_Hight_Zoom)];
//    
//    if ((image.size.width / image.size.height) < (_headerView.bounds.size.width / _headerView.bounds.size.height)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * _headerView.bounds.size.height / _headerView.bounds.size.width;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//        
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * _headerView.bounds.size.width / _headerView.bounds.size.height;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//    }
//    UIImage * newnewimage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return newnewimage;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}





@end
