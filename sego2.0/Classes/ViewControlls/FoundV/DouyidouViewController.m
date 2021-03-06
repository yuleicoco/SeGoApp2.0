//
//  DouyidouViewController.m
//  sego2.0
//
//  Created by czx on 16/11/27.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "DouyidouViewController.h"
#import "DouyiDouTableViewCell.h"
#import "AFHttpClient+Found.h"
#import "SearchModel.h"
#import "EggViewController.h"


static NSString * cellId = @"douyidouCellid";
@interface DouyidouViewController ()

@end

@implementation DouyidouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"find_dou", nil)];
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
//        
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        
//    }
//    
    
}

-(void)setupView{
    [super setupView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.tableView.superview);
        
    }];
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView registerClass:[DouyiDouTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];
    
}
-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]douyidouWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    return 65;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DouyiDouTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:cellId];
    SearchModel * model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLabel.text = model.nickname;
    
    cell.rightBtn.tag = indexPath.row + 111;
    [cell.rightBtn addTarget:self action:@selector(rightButtontouch1:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)rightButtontouch1:(UIButton *)sender{
    NSInteger i = sender.tag - 111;
     SearchModel * model = self.dataSource[i];
    // 通过逗一逗
    
    [[AFHttpClient sharedAFHttpClient]CheckDouCode:model.mid complete:^(BaseModel * model) {
        
        if ([model.retCode isEqualToString:@"0000"]) {
            
            EggViewController * eggVC =[[EggViewController alloc]init];
             SearchModel * model1 = self.dataSource[i];
             eggVC.DouMid = model1.mid;
             eggVC.isOther = YES;
             eggVC.tsumNum = [model.retVal[@"tsnum"] integerValue];
             eggVC.deviceNum = model.retVal[@"deviceno"];
             eggVC.termidNum = model.retVal[@"termid"];
            [self.navigationController pushViewController:eggVC animated:NO];
        }
        
        
    }];

    
    
    
    
    
    
}






//if ([model.status isEqualToString:@"ds001"]) {
//    cell.rightBtn.backgroundColor = GREEN_COLOR;
//    [cell.rightBtn setTitle:@"开启" forState:UIControlStateNormal];
//    [cell.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cell.rightBtn.userInteractionEnabled = YES;
//    
//}else if([model.status isEqualToString:@"ds002"]){
//    //cell.rightBtn.hidden = YES;
//    cell.rightBtn.backgroundColor = [UIColor clearColor];
//    [cell.rightBtn setTitle:@"离线" forState:UIControlStateNormal];
//    [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    cell.rightBtn.userInteractionEnabled = NO;
//}else if ([model.status isEqualToString:@"ds003"]){
//    cell.rightBtn.backgroundColor = [UIColor clearColor];
//    [cell.rightBtn setTitle:@"通话中" forState:UIControlStateNormal];
//    [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    cell.rightBtn.userInteractionEnabled = NO;
//    
//}else if ([model.status isEqualToString:@"ds004"]){
//    cell.rightBtn.backgroundColor = [UIColor clearColor];
//    [cell.rightBtn setTitle:@"上传中" forState:UIControlStateNormal];
//    [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    cell.rightBtn.userInteractionEnabled = NO;
//    
//}





@end
