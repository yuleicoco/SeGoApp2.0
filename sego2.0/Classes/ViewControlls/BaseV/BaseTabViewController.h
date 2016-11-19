//
//  BaseTabViewController.h
//  sebot
//
//  Created by yulei on 16/6/16.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
@interface BaseTabViewController : BaseViewController

@property (nonatomic, strong) UITableView* tableView;
//资源数组
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic,strong)NSMutableArray * dicSource;
@property (nonatomic, assign) BOOL bGroupView;
@property (nonatomic, assign) int pageIndex;


//加载分页数据
- (void)loadDataSourceWithPage:(int)page;

- (void)handleEndRefresh;

- (void)initRefreshView;

//更新数据从开始
- (void)updateData;
//裁剪图片
//- (UIImage *)cutImage:(UIImage*)image;
@end
