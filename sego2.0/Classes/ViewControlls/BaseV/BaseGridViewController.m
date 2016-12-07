//
//  BaseGridViewController.m
//  petegg
//
//  Created by ldp on 16/6/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseGridViewController.h"

@interface BaseGridViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BaseGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = REQUEST_PAGE_SIZE;
}

- (void)setupData{
    _dataSource = [NSMutableArray array];
    
}

- (void)setupView{
    UICollectionViewFlowLayout * fl=[[UICollectionViewFlowLayout alloc] init];
    fl.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self.view addSubview:_collectionView];
}

- (void)updateData
{
    [self.collectionView.mj_header beginRefreshing];
}

/**
 *  初始化上拉下拉刷新block
 */
- (void)initRefreshView
{
    __typeof (&*self) __weak weakSelf = self;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = START_PAGE_INDEX;
        [weakSelf loadDataSourceWithPage:weakSelf.pageIndex];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.pageSize > 0) {
            if ((weakSelf.pageIndex )* REQUEST_PAGE_SIZE == weakSelf.dataSource.count) {
                weakSelf.pageIndex++;
                [weakSelf loadDataSourceWithPage:weakSelf.pageIndex];
            }else{
                [weakSelf.collectionView.mj_footer endRefreshing];
                weakSelf.collectionView.mj_footer.hidden = YES;
            }     
        }else{
            weakSelf.pageIndex++;
            [weakSelf loadDataSourceWithPage:weakSelf.pageIndex];
        }
       
    }];
    
    self.collectionView.mj_footer.hidden = YES;
    [self.collectionView.mj_header beginRefreshing];
}

/**
 *  结束刷新
 */
-(void)handleEndRefresh{
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

/**
 *  加载分页方法，在子类重写
 */
- (void)loadDataSourceWithPage:(int)page {
    
    
}

#pragma UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
