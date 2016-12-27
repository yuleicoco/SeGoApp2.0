//
//  DouyiDouTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/11/29.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "DouyiDouTableViewCell.h"

@implementation DouyiDouTableViewCell

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
        _headImage.layer.cornerRadius = 22.5;
        [self addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.superview).offset(12);
            make.centerY.equalTo(_headImage.superview.mas_centerY);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(45);
        }];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel.superview.mas_centerY);
            make.left.equalTo(_headImage.mas_right).offset(12);
            
        }];
        
        _rightBtn = [[UIButton alloc]init];
        _rightBtn.backgroundColor = GREEN_COLOR;
        _rightBtn.layer.cornerRadius = 5;
        [_rightBtn setTitle:@"互动" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightBtn.superview).offset(-12);
            make.centerY.equalTo(_rightBtn.superview.mas_centerY);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(27);
            
            
            
        }];
        
        
        
        
    }
    return self;
}

@end
