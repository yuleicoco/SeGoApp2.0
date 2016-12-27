//
//  LargeViewController.h
//  petegg
//
//  Created by yulei on 16/4/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QFTableView.h"


@interface LargeViewController : BaseViewController<QFTableViewDataSource,QFTableViewDelegate>
@property (nonatomic,strong)NSArray * dataArray;
//@property (nonatomic,strong)ImageModel * model;
@property (nonatomic,assign)NSInteger indexxx;
@end
