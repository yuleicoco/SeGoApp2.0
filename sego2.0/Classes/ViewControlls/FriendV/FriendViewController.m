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
#import "NewfriendViewController.h"
#import "FriendModel.h"
static NSString * cellId = @"friendtableviewcellId";
@interface FriendViewController ()
@property (nonatomic,strong)UIButton * messageBtn;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"tabRank", nil)];
    self.view.backgroundColor = GRAY_COLOR;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults * tipUser = [NSUserDefaults standardUserDefaults];
    NSString * tipstr = [tipUser objectForKey:@"countfoucetip"];
    if ([tipstr isEqualToString:@"0"]) {
        _messageBtn.hidden = YES;
    }else{
        _messageBtn.hidden = NO;
        [_messageBtn setTitle:tipstr forState:UIControlStateNormal];
    }
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanTip) name:@"isreaddd" object:nil];
    

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
    newfriendLabel.text = NSLocalizedString(@"friends_new", nil);
    newfriendLabel.textColor = [UIColor blackColor];
    newfriendLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:newfriendLabel];
    [newfriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newfriendLabel.superview.mas_centerY);
        make.left.equalTo(friendImage.mas_right).offset(18);
    }];
    
    _messageBtn = [[UIButton alloc]init];
    _messageBtn.backgroundColor = [UIColor redColor];
    [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _messageBtn.layer.cornerRadius = 10;
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:_messageBtn];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageBtn.superview).offset(-12);
        make.centerY.equalTo(_messageBtn.superview.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
 
    
    UIButton *topBtn = [[UIButton alloc]init];
    topBtn.backgroundColor = [UIColor clearColor];
    [topBtn addTarget:self action:@selector(topbuttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBtn.mas_top);
        make.right.equalTo(topBtn.superview);
        make.left.equalTo(topBtn.superview);
        make.height.mas_equalTo(60);
        
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
-(void)topbuttonTouch{
    NewfriendViewController * newfriendVc = [[NewfriendViewController alloc]init];
    [self.navigationController pushViewController:newfriendVc animated:NO];



}




-(void)loadDataSourceWithPage:(int)page{

    [[AFHttpClient sharedAFHttpClient]queryFriendsWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
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
    //还没写model
    FriendModel * model = self.dataSource[indexPath.row];
    
    
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    cell.leftBtn.hidden = YES;
    cell.rightBtn.hidden = YES;
    cell.rightLabe.hidden = YES;

    
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    
    
    cell.nameLabel.text = model.nickname;
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

//左滑删除
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //昨滑的文字
    return NSLocalizedString(@"friends_dele", nil);
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    //让它能够滑动
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除的属性
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // NSUInteger row = [indexPath row];
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
        //                withRowAnimation:UITableViewRowAnimationAutomatic];
        // [tableView reloadData];
        // 数据源也要相应删除一项
        FriendModel * model = self.dataSource[indexPath.row];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"friends_suredel", nil) preferredStyle:UIAlertControllerStyleAlert];
//
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sure_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[AFHttpClient sharedAFHttpClient]delFriendWithMid:[AccountManager sharedAccountManager].loginModel.mid friend:model.mid complete:^(BaseModel *model) {
                if (model) {
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [tableView reloadData];
                }
            }];

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView reloadData];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





@end
