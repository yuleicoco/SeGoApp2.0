//
//  ZdFriendTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/12/13.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "ZdFriendTableViewCell.h"

@implementation ZdFriendTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = LIGHT_GRAYdcdc_COLOR;
        [self addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineLabel.superview).offset(12);
            make.right.equalTo(_lineLabel.superview).offset(-12);
            make.top.equalTo(_lineLabel.superview);
            make.height.mas_equalTo(0.5);
        }];
        
        _headImage = [[UIImageView alloc]init];
        [_headImage.layer setMasksToBounds:YES];
        _headImage.layer.cornerRadius = 23;
        _headImage.backgroundColor = [UIColor blackColor];
        [self addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.superview).offset(12);
            make.width.mas_equalTo(46);
            make.height.mas_equalTo(46);
            make.centerY.equalTo(_headImage.superview.mas_centerY);
            
            
        }];
        
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.text = @"冬冬";
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.mas_right).offset(8);
            make.centerY.equalTo(_nameLabel.superview.mas_centerY);
        }];
        
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setImage:[UIImage imageNamed:@"pickk.png"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"pickkhou.png"] forState:UIControlStateSelected];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightBtn.superview).offset(-12);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(_rightBtn.superview.mas_centerY);
            
        }];
        
        
        
        
        
        
        
    }



    return self;
}

@end
