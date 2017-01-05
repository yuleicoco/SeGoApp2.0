//
//  ZdFriendViewController.m
//  sego2.0
//
//  Created by czx on 16/12/13.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ZdFriendViewController.h"
#import "ZdFriendTableViewCell.h"
#import "AFHttpClient+Permission.h"
#import "ZdFriendModel.h"

static NSString * cellId = @"zdFriendTableviewcellId";
@interface ZdFriendViewController ()
@property (nonatomic,strong)NSMutableArray * sourceArray;
@property (nonatomic,strong)UIButton * sureBtn;

@end

@implementation ZdFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sourceArray = [[NSMutableArray alloc]init];
    [self setNavTitle:NSLocalizedString(@"as_make", nil)];
}
-(void)doLeftButtonTouch{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"as_tipps", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sure_bind", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)setupView{
    [super setupView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview).offset(-45);
    }];
    
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView registerClass:[ZdFriendTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];

    _sureBtn = [[UIButton alloc]init];
    _sureBtn.backgroundColor = [UIColor whiteColor];
    [_sureBtn setTitle:NSLocalizedString(@"Sure_bind", nil)forState:UIControlStateNormal];
    [_sureBtn setTitleColor:LIGHT_GRAYdcdc_COLOR forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureButtonTouchhh) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.userInteractionEnabled = NO;
    [self.view addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sureBtn.superview);
        make.right.equalTo(_sureBtn.superview);
        make.bottom.equalTo(_sureBtn.superview);
        make.height.mas_equalTo(45);
        
    }];

}



-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]ruleSetQueryFriendWithMid:[AccountManager sharedAccountManager].loginModel.mid page:page size:REQUEST_PAGE_SIZE complete:^(BaseModel *model) {
    
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
    return 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZdFriendTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    ZdFriendModel * model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
    cell.nameLabel.text = model.nickname;
    
    if ([AppUtil isBlankString:model.isset]) {
          cell.rightBtn.selected = NO;
    }else{
    
        cell.rightBtn.selected = YES;
        [_sourceArray addObject:model.mid];

    }
    
    cell.rightBtn.tag = indexPath.row + 2135;
    [cell.rightBtn addTarget:self action:@selector(rightButtontouchh:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)rightButtontouchh:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSInteger i = sender.tag - 2135;
      ZdFriendModel * model = self.dataSource[i];
    if (sender.selected == YES) {
        [_sourceArray addObject:model.mid];
    }else{
        [_sourceArray removeObject:model.mid];
    }
    
    if (_sourceArray.count>0) {
        [_sureBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = YES;
    }else{
        [_sureBtn setTitleColor:LIGHT_GRAYdcdc_COLOR forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = NO;
    }

}


-(void)sureButtonTouchhh{
    NSUserDefaults * FriendUserDefaults = [NSUserDefaults standardUserDefaults];
    [FriendUserDefaults setObject:_sourceArray forKey:@"friendesId"];
    [self.navigationController popViewControllerAnimated:NO];


}






@end
