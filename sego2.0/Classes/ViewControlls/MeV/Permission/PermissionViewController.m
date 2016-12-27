//
//  PermissionViewController.m
//  sego2.0
//
//  Created by czx on 16/12/11.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "PermissionViewController.h"
#import "AFHttpClient+Permission.h"
#import "PermissonTableViewCell.h"
#import "RuleModel.h"
#import "NewPermissionViewController.h"
#import "ExchangPermissionViewController.h"

static NSString * cellId = @"permissontableviewCellId";
@interface PermissionViewController ()

@end

@implementation PermissionViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ruleShuaxinxin) name:@"ruleShuaxin" object:nil];
}

-(void)ruleShuaxinxin{
    [self setupData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"访问规则"];
    self.view.backgroundColor = GRAY_COLOR;
}

-(void)setupView{
    [super setupView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height );
    //  [self.tableView registerClass:[PersonDataTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = GRAY_COLOR;
    [self.tableView registerClass:[PermissonTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIButton * creatBtn = [[UIButton alloc]init];
    creatBtn.backgroundColor = GREEN_COLOR;
    [creatBtn setTitle:@"新建访问规则" forState:UIControlStateNormal];
    [creatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    creatBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    creatBtn.layer.cornerRadius = 3;
    [creatBtn addTarget:self action:@selector(creatButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatBtn];
    [creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(creatBtn.superview.mas_centerX);
        make.bottom.equalTo(creatBtn.superview).offset(-87);
        
    }];
    
    
}

-(void)creatButtonTouch{
    if (self.dataSource.count >= 3) {
              [[AppUtil appTopViewController] showHint:@"最多只能创建2条规则哦!"];
    }else{
        NewPermissionViewController * perVc = [[NewPermissionViewController alloc]init];
        [self.navigationController pushViewController:perVc animated:NO];
        
    }

}

-(void)setupData{
    [super setupData];
    [[AFHttpClient sharedAFHttpClient]queryRuleWithMid:[AccountManager sharedAccountManager].loginModel.mid complete:^(BaseModel *model) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model.list];
        [self.tableView reloadData];
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
    return 70*W_Hight_Zoom;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PermissonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    RuleModel * model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    cell.guizeNameLabel.text = model.rulesname;
    if ([model.tsnum isEqualToString:@"0"]) {
        cell.rightLabel.text = @"不允许";
    }else{
        cell.rightLabel.text = @"允许";
    }
    
    if ([model.isuse isEqualToString:@"n"]) {
        cell.leftBtn.selected = NO;
    }else{
        cell.leftBtn.selected = YES;
    }
    if ([model.object isEqualToString:@"all"]) {
        cell.leftLabel.text = @"所有人";
    }else if ([model.object isEqualToString:@"friend"]){
        cell.leftLabel.text = @"好友";
    }else if ([model.object isEqualToString:@"self"]){
        cell.leftLabel.text = @"仅自己";
    }else if ([model.object isEqualToString:@"zd"]){
        cell.leftLabel.text = @"指定好友";
    }
    
    cell.leftBtn.tag = indexPath.row + 22222;
    [cell.leftBtn addTarget:self action:@selector(perleftButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)perleftButtonTouch:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSInteger i = sender.tag - 22222;
     RuleModel * model = self.dataSource[i];
    [[AFHttpClient sharedAFHttpClient]ruleModifyStatusWithMid:[AccountManager sharedAccountManager].loginModel.mid rid:model.rid complete:^(BaseModel *model) {
        [[AppUtil appTopViewController] showHint:model.retDesc];
        [self setupData];
        sender.userInteractionEnabled = YES;

    }];
    


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
         [[AppUtil appTopViewController] showHint:@"默认规则不可以修改"];
    }else{
        RuleModel * model = self.dataSource[indexPath.row];
        ExchangPermissionViewController * exchangVc = [[ExchangPermissionViewController alloc]init];
        exchangVc.ruleName = model.rulesname;
        exchangVc.istsNum = model.tsnum;
        exchangVc.objectStr = model.object;
        exchangVc.ridStr = model.rid;
        [self.navigationController pushViewController:exchangVc animated:NO];
        
    
    }
    



}



//左滑删除
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //昨滑的文字
    return@"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    //让它能够滑动
    if (indexPath.row >0) {
         return YES;
    }else{
        return NO;
    }
    
   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除的属性
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RuleModel * model = self.dataSource[indexPath.row];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除此规则吗？" preferredStyle:UIAlertControllerStyleAlert];
        //
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([model.isuse isEqualToString:@"y"]) {
                [[AppUtil appTopViewController] showHint:@"已启用的规则不能删除!"];
                [self.tableView reloadData];
            }else{
            
            [[AFHttpClient sharedAFHttpClient]ruleDelWithRid:model.rid complete:^(BaseModel *model) {
                if (model) {
                    [[AppUtil appTopViewController] showHint:model.retDesc];
                    [self setupData];
                }
                
            }];
        }
        
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView reloadData];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}




@end
