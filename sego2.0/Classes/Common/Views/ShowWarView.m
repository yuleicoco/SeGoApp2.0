//
//  ShowWarView.m
//  sego2.0
//
//  Created by yulei on 16/11/15.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ShowWarView.h"

@implementation ShowWarView

@synthesize ParentView = _parentView;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius =4;
        self.layer.borderWidth =0.4;
        self.layer.borderColor =GRAY_COLOR.CGColor;
        // title
        UILabel *   _handLable = [UILabel new];
        _handLable.numberOfLines = 0;
        _handLable.textAlignment = NSTextAlignmentCenter;
        _handLable.font = [UIFont systemFontOfSize:18];
        _handLable.textColor = [UIColor blackColor];
        _handLable.backgroundColor = [UIColor clearColor];
        _handLable.text =@"提示";
        [self addSubview:_handLable];
        
        [_handLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(15);
            make.centerX.mas_equalTo(self.mas_centerX);
            
            
        }];
        
        //message
        
        UILabel * labeOne =[UILabel new];
        UILabel * labeTwo =[UILabel new];
        labeOne.font = [UIFont systemFontOfSize:15];
        labeTwo.font = [UIFont systemFontOfSize:15];
       labeOne.text = @"未找到设备";
       labeTwo.text = @"请将设备切换到配置模式";
        
        
        [self addSubview:labeOne];
        [self addSubview:labeTwo];
        
        [labeOne mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.centerX.mas_equalTo(self.mas_centerX);
             make.top.equalTo(_handLable.mas_bottom).offset(17);
        }];
        
        [labeTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(labeOne.mas_bottom).offset(9);
            
        }];
        
        
        // 线
        UILabel * linLb =[UILabel new];
        linLb.backgroundColor = GRAY_COLOR;
        [self addSubview:linLb];
        
        [linLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.mas_bottom).offset(-55);
            make.left.equalTo(self).offset(0);
            
            
        }];
        
        
        UILabel * Hline =[UILabel new];
        Hline.backgroundColor  = GRAY_COLOR;
        [self addSubview:Hline];
        
        
        [Hline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.height.equalTo(@55);
            make.bottom.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
            
            
        }];
        
        
        
        // 取消 重试
        
        UIButton * btnCancel =[[UIButton alloc]init];
        UIButton * btnTry =[[UIButton alloc]init];
        
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCancel.titleLabel.font =[UIFont systemFontOfSize:18];
        [btnTry setTitle:@"重试" forState:UIControlStateNormal];
        [btnTry addTarget:self action:@selector(TryAgain) forControlEvents:UIControlEventTouchUpInside];
        [btnTry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnTry.titleLabel.font =[UIFont systemFontOfSize:18];
        [self addSubview:btnCancel];
        [self addSubview:btnTry];
        
        
        [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(linLb.mas_bottom).offset(7);
            make.centerX.equalTo(Hline.mas_centerX).offset(-255/4);
        }];
        
        [btnTry mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(linLb.mas_bottom).offset(7);
            make.centerX.equalTo(Hline.mas_centerX).offset(255/4);
        }];
        

        

        
        
        
    }
    return self;
    
    
}

#pragma mark - Method

- (void)Cancel
{
    
    if (self.delegate) {
        
        [self.delegate CancelMethod];
        
    }
    
    
}
- (void)TryAgain
{
    
    if (self.delegate) {
        
        [self.delegate TryAgainMethod];
        
    }
    
    
}



@end
