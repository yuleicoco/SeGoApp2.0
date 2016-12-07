//
//  BaseGridViewController.h
//  petegg
//
//  Created by ldp on 16/6/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseViewController.h"

#import "MJRefresh.h"

@interface BaseGridViewController : BaseViewController

@property (nonatomic,strong)UICollectionView * collectionView;

//资源数组
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) int pageIndex;

@property (nonatomic, assign) int pageSize;

//加载分页数据
- (void)loadDataSourceWithPage:(int)page;

- (void)handleEndRefresh;

- (void)initRefreshView;

//更新数据从开始
- (void)updateData;


@end
