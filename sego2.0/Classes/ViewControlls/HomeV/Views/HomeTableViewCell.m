//
//  HomeTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/12/1.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = GRAY_COLOR;
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView.superview);
            make.right.equalTo(_topView.superview);
            make.height.mas_equalTo(12);
        }];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.text = @"开心的小柯基";
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.superview).offset(12);
            make.top.equalTo(_topView.mas_bottom).offset(11.5);
            
        }];
        
        _centerImage = [[UIImageView alloc]init];
        _centerImage.backgroundColor = [UIColor redColor];
        [self addSubview:_centerImage];
        [_centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerImage.superview);
            make.right.equalTo(_centerImage.superview);
            make.top.equalTo(_contentLabel.mas_bottom).offset(11.5);
            make.bottom.equalTo(_contentLabel.superview.mas_bottom);
            
        }];
        
        
        
        
    
    }




    return self;
}

@end
