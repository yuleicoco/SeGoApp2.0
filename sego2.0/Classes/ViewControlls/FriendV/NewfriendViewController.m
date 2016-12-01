//
//  NewfriendViewController.m
//  sego2.0
//
//  Created by czx on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "NewfriendViewController.h"
#import "SearchFriendViewController.h"
#import "FriendTableViewCell.h"
#import "AFHttpClient+Friend.h"
#import "NewFriendModel.h"

static NSString * cellId = @"newfriendCellid";
@interface NewfriendViewController ()

@end

@implementation NewfriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"新的朋友"];
    self.view.backgroundColor = GRAY_COLOR;
    
}

-(void)setupView{
    [super setupView];
    UIButton * topBtn = [[UIButton alloc]init];
    topBtn.backgroundColor = [UIColor whiteColor];
    topBtn.layer.cornerRadius = 5;
    [topBtn addTarget:self action:@selector(topbuttontouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBtn.superview).offset(4);
        make.left.equalTo(topBtn.superview).offset(5);
        make.right.equalTo(topBtn.superview).offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView * foundImage = [[UIImageView alloc]init];
    foundImage.image = [UIImage imageNamed:@"find.png"];
    [topBtn addSubview:foundImage];
    [foundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.superview).offset(7);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(17);
        make.top.equalTo(foundImage.superview).offset(8);
        
        
    }];
    
    UILabel * placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.text = @"手机号/昵称/设备号";
    placeholderLabel.textColor = RGB(153, 153, 153);
    placeholderLabel.font = [UIFont systemFontOfSize:18];
    [topBtn addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.mas_right).offset(8);
        make.centerY.equalTo(placeholderLabel.superview.mas_centerY);
        
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview).offset(43);
        make.bottom.equalTo(self.tableView.superview);
    }];
    
    [self.tableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:cellId];
    
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];
 //  self.tableView.hidden = YES;
}
-(void)topbuttontouch{
    
    SearchFriendViewController * search = [[SearchFriendViewController alloc]init];
   // [self presentViewController:search animated:YES completion:nil];
    [self.navigationController pushViewController:search animated:NO];


}
-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]newFriendsMsgWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    //return 3;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }

    NewFriendModel * model = self.dataSource[indexPath.row];

    
    cell.nameLabel.text = model.nickname;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    if ([model.stype isEqualToString:@"01"]) {
        cell.rightLabe.hidden = YES;
        cell.rightBtn.hidden = NO;
        cell.leftBtn.hidden = NO;
    }else{
         cell.rightLabe.hidden = NO;
        cell.rightBtn.hidden = YES;
        cell.leftBtn.hidden = YES;
        if ([model.stype isEqualToString:@"00"]) {
            cell.rightLabe.text = @"等待验证";
        }
        if ([model.stype isEqualToString:@"1"]) {
             cell.rightLabe.text = @"已添加";
        }
        if ([model.stype isEqualToString:@"2"]) {
            cell.rightLabe.text = @"已拒绝";
        }
    }
    cell.rightBtn.tag = indexPath.row + 110;
    cell.leftBtn.tag = indexPath.row + 120;
    
    [cell.rightBtn addTarget:self action:@selector(cellrightButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cell.leftBtn addTarget:self action:@selector(cellleftButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)cellrightButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 110;
        NewFriendModel * model = self.dataSource[i];
    
    [[AFHttpClient sharedAFHttpClient]addFriendResponseWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid opttype:@"1" complete:^(BaseModel *model) {
        
        [self initRefreshView];
    }];
    
    
}

-(void)cellleftButtonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 120;
    NewFriendModel * model = self.dataSource[i];
    
    [[AFHttpClient sharedAFHttpClient]addFriendResponseWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid opttype:@"1" complete:^(BaseModel *model) {
        
    }];


}

@end
