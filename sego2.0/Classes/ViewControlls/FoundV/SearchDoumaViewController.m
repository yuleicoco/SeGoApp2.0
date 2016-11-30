//
//  SearchDoumaViewController.m
//  sego2.0
//
//  Created by czx on 16/11/27.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "SearchDoumaViewController.h"
#import "SearchTableViewCell.h"
#import "AFHttpClient+Found.h"
#import "SearchModel.h"

static NSString * cellId = @"searchtabviewId";
@interface SearchDoumaViewController ()
@property (nonatomic,strong)UITextField * topTextfield;

@end

@implementation SearchDoumaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"搜索"];
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
        make.top.equalTo(topView.superview).offset(68);
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
    _topTextfield.placeholder = @"请输入逗码";
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
    
    [self.tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:cellId];
    
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.hidden = YES;
    
}

-(void)searchButtontouch{

    [_topTextfield resignFirstResponder];
  //  [self initRefreshView];
    [[AFHttpClient sharedAFHttpClient]searchPlaycodeWithPlaycode:_topTextfield.text complete:^(BaseModel *model) {
        if (model) {
            if ([model.retCode isEqualToString:@"1111"]) {
                self.tableView.hidden = YES;
                return;
            }
            
            SearchModel * Searchmodel = [[SearchModel alloc]initWithDictionary:model.retVal error:nil];
            if ([Searchmodel.status isEqualToString:@"1"]) {
                self.tableView.hidden = YES;
                 [[AppUtil appTopViewController] showHint:@"逗码已失效"];
            }else{
                NSMutableArray * array = [[NSMutableArray alloc]init];
                [array addObject:Searchmodel];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            
            }
            
        }
       
      //  [self handleEndRefresh];
    
    }];

}
-(void)loadDataSourceWithPage:(int)page{

    [self handleEndRefresh];
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
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    SearchModel * model = self.dataSource[indexPath.row];
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.headportrait] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLabel.text = model.nickname;

    [cell.rightBtn addTarget:self action:@selector(rightButtontouch) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)rightButtontouch{
     SearchModel * model = self.dataSource[0];
    NSString * resolution = model.resolution;
    NSString * mid = model.mid;
    
    
    
    
}



@end
