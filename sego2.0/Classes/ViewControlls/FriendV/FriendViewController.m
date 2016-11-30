//
//  FriendViewController.m
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "AFHttpClient+Friend.h"
static NSString * cellId = @"friendtableviewcellId";
@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"好友"];
    self.view.backgroundColor = GRAY_COLOR;
}
-(void)setupView{
    [super setupView];
    UIView * topView= [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview).offset(1);
        make.height.mas_equalTo(60);
    }];
    
    UIImageView * friendImage = [[UIImageView alloc]init];
    friendImage.image = [UIImage imageNamed:@"newfriend.png"];
    [topView addSubview:friendImage];
    [friendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendImage.superview).offset(22.5);
        make.top.equalTo(friendImage.superview).offset(17.5);
        make.bottom.equalTo(friendImage.superview).offset(-17);
        make.width.mas_equalTo(24);
    }];
    
    UILabel * newfriendLabel = [[UILabel alloc]init];
    newfriendLabel.text = @"新的朋友";
    newfriendLabel.textColor = [UIColor blackColor];
    newfriendLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:newfriendLabel];
    [newfriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newfriendLabel.superview.mas_centerY);
        make.left.equalTo(friendImage.mas_right).offset(18);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(3);
        make.bottom.equalTo(self.tableView.superview.mas_bottom);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);

    }];
    
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView registerClass:[FriendTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];
    

}

-(void)loadDataSourceWithPage:(int)page{

    [[AFHttpClient sharedAFHttpClient]queryFriendsWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        
        
    }];


}




#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.dataSource.count;
    return 3;
    
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

    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;

}









@end
