//
//  HomeDetailTableViewCell.m
//  sego2.0
//
//  Created by czx on 16/12/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "HomeDetailTableViewCell.h"

@implementation HomeDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.contentMode = UIViewContentModeCenter;
        _centerImage.layer.masksToBounds = YES;
        [self addSubview:_centerImage];
        [_centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerImage.superview);
            make.right.equalTo(_centerImage.superview);
            make.top.equalTo(_centerImage.superview).offset(12);
            //   make.bottom.equalTo(_centerImage.superview.mas_bottom);
            make.height.mas_equalTo(220);
        //     make.width.mas_offset(375 * W_Wide_Zoom);
            
        }];
        
        _touchBtn = [[UIButton alloc]init];
        _touchBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_touchBtn];
        [_touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerImage.superview);
            make.right.equalTo(_centerImage.superview);
            make.top.equalTo(_centerImage.superview).offset(12);
            //   make.bottom.equalTo(_centerImage.superview.mas_bottom);
            make.height.mas_equalTo(220);
            make.width.mas_offset(375 * W_Wide_Zoom);
            
        }];
        
        
        
        
        
        
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = GRAY_COLOR;
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.superview);
            make.left.equalTo(_topView.superview);
            make.right.equalTo(_topView.superview);
            make.height.mas_equalTo(12);
        }];
        
        _videoImage = [[UIImageView alloc]init];
        _videoImage.image = [UIImage imageNamed:@"videobo.png"];
        [_centerImage addSubview:_videoImage];
        [_videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(_videoImage.superview.mas_centerX);
            make.centerY.equalTo(_videoImage.superview.mas_centerY);
            
        }];
        
        
    }




    return self;
}

@end
