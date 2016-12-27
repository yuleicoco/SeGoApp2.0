//
//  InformationTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/11/19.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.text = @"哈哈";
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.superview).offset(12);
            make.centerY.equalTo(_nameLabel.superview.mas_centerY);
        }];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = LIGHT_GRAYdcdc_COLOR;
        [self addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineLabel.superview).offset(12);
            make.right.equalTo(_lineLabel.superview).offset(-12);
            make.top.equalTo(_lineLabel.superview).offset(55);
            make.height.mas_equalTo(0.5);
        }];
        
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = @"dada";
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:18];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightLabel.superview).offset(-12);
            make.centerY.equalTo(_rightLabel.superview.mas_centerY);
            make.width.mas_equalTo(300);
        }];
        
        
        
        
        
        
        
        
        
    }



    return self;

}

@end
