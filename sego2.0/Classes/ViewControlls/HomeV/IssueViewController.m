//
//  IssueViewController.m
//  sego2.0
//
//  Created by czx on 16/12/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "IssueViewController.h"
#import "AFHttpClient+Article.h"


@interface IssueViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView * topTextView;
@property (nonatomic,strong)UILabel * placeholderLabel;
@property (nonatomic,strong)UIButton *releaseButton;
@property (nonatomic,assign)BOOL isfabu;
@end

@implementation IssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isfabu = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GRAY_COLOR;
    [self setNavTitle:@"收藏"];
    _releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_releaseButton setTitle:@"保存" forState:normal];
    [_releaseButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    _releaseButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    _releaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}

-(void)doLeftButtonTouch{
    if (_isfabu == NO) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有发布内容，是否要退出？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            // 点击按钮后的方法直接在这里面写
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
    
    }
}


-(void)releaseInfo:(UIButton *)sender{
    _isfabu = YES;
    sender.userInteractionEnabled = NO;
    [self showHudInView:self.view hint:@"正在保存..."];
    if ([_porv isEqualToString:@"v"]) {
        NSString * soureceString = [_soureArray componentsJoinedByString:@","];
        [[AFHttpClient sharedAFHttpClient]addArticleWithMid:[AccountManager sharedAccountManager].loginModel.mid content:_topTextView.text type:@"v" resources:soureceString complete:^(BaseModel *model) {
            if ([model.retCode isEqualToString:@"0000"]) {
               // [[AppUtil appTopViewController]showHint:model.retDesc];
                 [self.navigationController popToRootViewControllerAnimated:NO];
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
               
            }
            [self hideHud];
            [[AppUtil appTopViewController]showHint:model.retDesc];
            _isfabu = NO;
            sender.userInteractionEnabled = YES;
            
        }];
       // _isfabu = NO;
    }else{
        NSString * soureceString = [_ImageArray componentsJoinedByString:@","];
        [[AFHttpClient sharedAFHttpClient]addArticleWithMid:[AccountManager sharedAccountManager].loginModel.mid content:_topTextView.text type:@"p" resources:soureceString complete:^(BaseModel *model) {
            if ([model.retCode isEqualToString:@"0000"]) {
               // [[AppUtil appTopViewController]showHint:model.retDesc];
                [self.navigationController popToRootViewControllerAnimated:NO];
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
        }
              [[AppUtil appTopViewController]showHint:model.retDesc];
            _isfabu = NO;
            [self hideHud];
            sender.userInteractionEnabled = YES;
        }];
    

       // _isfabu = NO;
    
    }

    
    
    

}






-(void)setupView{
    [super setupView];
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.superview);
        make.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview);
        make.height.mas_equalTo(100);
        
        
    }];
    
    _topTextView = [[UITextView alloc]init];
    _topTextView.textAlignment = NSTextAlignmentLeft;
    _topTextView.backgroundColor = [UIColor whiteColor];
    _topTextView.tintColor = GREEN_COLOR;
    _topTextView.font = [UIFont systemFontOfSize:18];
    _topTextView.delegate = self;
    [self.view addSubview:_topTextView];
    [_topTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topTextView.superview).offset(12);
        make.top.equalTo(_topTextView.superview);
        make.right.equalTo(_topTextView.superview.mas_right).offset(-12);
        make.height.mas_equalTo(100);
     //   make.width.mas_equalTo(375);
        
    }];
    _placeholderLabel = [[UILabel alloc]init];
    _placeholderLabel.textColor = [UIColor grayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = @"请输入内容";
    _placeholderLabel.font = _topTextView.font;
    [_topTextView addSubview:_placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_placeholderLabel.superview);
        make.top.equalTo(_placeholderLabel.superview).offset(10);
    }];
    
    UIView * downView = [[UIView alloc]init];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTextView.mas_bottom).offset(8);
        make.left.equalTo(downView.superview);
        make.right.equalTo(downView.superview);
        make.height.mas_equalTo(100);
    
    }];
    
    //_ImageArray = @[@"sego1.png",@"sego1.png",@"sego1.png",@"sego1.png"];
    for (int i = 0 ; i < _ImageArray.count ; i++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom + 90 * i * W_Wide_Zoom , 7 * W_Hight_Zoom, 85 * W_Wide_Zoom, 85 * W_Hight_Zoom)];
        [image sd_setImageWithURL:[NSURL URLWithString:_ImageArray[i]] placeholderImage:[UIImage imageNamed:@"sego1.png"]];
        //  image.image = [UIImage imageNamed:_ImageArray[i]];
        [downView addSubview:image];
        UIImageView * videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(7 * W_Wide_Zoom,70 * W_Hight_Zoom, 12 * W_Wide_Zoom, 7 * W_Hight_Zoom)];
        videoImage.image = [UIImage imageNamed:@"video.png"];
        if ([_porv isEqualToString:@"v"]) {
            [image addSubview:videoImage];
        }
        
        
    }
    

}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_topTextView.text.length == 0) {
        _placeholderLabel.text = @"请输入内容";
    }else{
        _placeholderLabel.text = @"";
    }
    
    
}





@end
