//
//  FriendTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/11/29.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _lineLabel = [[UILabel alloc]init];
//        _lineLabel.backgroundColor = [UIColor grayColor];
//        [self addSubview:_lineLabel];
//        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_lineLabel.superview).offset(12);
//            make.right.equalTo(_lineLabel.superview).offset(-12);
//            make.top.equalTo(_lineLabel.superview).offset(61);
//            make.height.mas_equalTo(0.5);
//        }];
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 * W_Wide_Zoom, 0 * W_Hight_Zoom, 351 * W_Wide_Zoom, 0.5 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineLabel];
        

        
        _headImage = [[UIImageView alloc]init];
        [_headImage.layer setMasksToBounds:YES];
        _headImage.backgroundColor = [UIColor redColor];
        _headImage.layer.cornerRadius = 22.5;
        [self addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.superview).offset(12);
            make.centerY.equalTo(_headImage.superview.mas_centerY);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(45);
            
        }];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"陈大侠最帅";
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.mas_right).offset(8);
            make.centerY.equalTo(_nameLabel.superview.mas_centerY);
        
        }];
        
        
        
        
        
        
        
    }
    


    return self;
}
@end
