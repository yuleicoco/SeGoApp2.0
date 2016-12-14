//
//  SearchFriendViewController.m
//  sego2.0
//
//  Created by czx on 16/11/30.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "AFHttpClient+Friend.h"
#import "FriendTableViewCell.h"
#import "FriendModel.h"

static NSString * cellId = @"friendSearchCellid";
@interface SearchFriendViewController ()
@property (nonatomic,strong)UITextField * topTextfield;
@end

@implementation SearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"添加好友"];
    self.view.backgroundColor = GRAY_COLOR;
}

-(void)setupView{
    [super setupView];
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview).offset(5);
        make.right.equalTo(topView.superview).offset(-5);
        make.top.equalTo(topView.superview).offset(4);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView * foundImage = [[UIImageView alloc]init];
    foundImage.image = [UIImage imageNamed:@"find.png"];
    [topView addSubview:foundImage];
    [foundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.superview).offset(7);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(17);
        make.top.equalTo(foundImage.superview).offset(8);
        
    }];
    
    _topTextfield = [[UITextField alloc]init];
    _topTextfield.placeholder = @"手机/昵称/设备号";
    _topTextfield.font = [UIFont systemFontOfSize:18];
    _topTextfield.textColor = [UIColor blackColor];
    [topView addSubview:_topTextfield];
    [_topTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(foundImage.mas_right).offset(9);
        make.centerY.equalTo(_topTextfield.superview.mas_centerY);
        make.width.mas_equalTo(300);
    }];
    
    UILabel * searechLabel = [[UILabel alloc]init];
    searechLabel.text = @"搜索";
    searechLabel.textColor = GREEN_COLOR;
    searechLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:searechLabel];
    [searechLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searechLabel.superview).offset(-7);
        make.centerY.equalTo(searechLabel.superview.mas_centerY);
        
    }];
    
    UIButton * searchBtn = [[UIButton alloc]init];
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchButtontouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searechLabel.superview).offset(-7);
        make.centerY.equalTo(searechLabel.superview.mas_centerY);
        make.width.mas_equalTo(100);
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
    
    self.tableView.hidden = YES;

    
    
    
}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]searchPeopleWithMid:[AccountManager sharedAccountManager].loginModel.mid condition:_topTextfield.text page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
        if (model.list.count == 0) {
            [[AppUtil appTopViewController] showHint:@"未找到相关用户"];
             [self.dataSource removeAllObjects];
            [self.tableView reloadData];
               [self handleEndRefresh];
            return;
        }
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




-(void)searchButtontouch{
    FuckLog(@"dadadaad");
    [_topTextfield resignFirstResponder];
     self.tableView.hidden = NO;
    [self initRefreshView];

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
    FriendModel * model = self.dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    cell.nameLabel.text = model.nickname;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    
    
    if ([model.isfriend isEqualToString:@""]) {
        cell.rightBtn.hidden = NO;
        cell.rightLabe.hidden = YES;
    }else{
        cell.rightBtn.hidden = YES;
        cell.rightLabe.hidden = NO;
        cell.rightLabe.text = @"已添加";
    }
    
    cell.rightBtn.tag = indexPath.row + 2221;
    [cell.rightBtn addTarget:self action:@selector(rightButtonTouch22:) forControlEvents:UIControlEventTouchUpInside];
    
    //这里不需要拒绝按钮
    
    cell.leftBtn.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)rightButtonTouch22:(UIButton *)sender{
    NSInteger i = sender.tag - 2221;
    FriendModel * model = self.dataSource[i];
    [[AFHttpClient sharedAFHttpClient]addFriendRequsetWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid complete:^(BaseModel *model) {
        if (model) {
            sender.backgroundColor = [UIColor clearColor];
            sender.titleLabel.font = [UIFont systemFontOfSize:1];
            [sender setTitle:@"等待验证" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

    }];


}






@end
