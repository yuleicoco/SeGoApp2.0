//
//  FeedSetingTableViewCell.m
//  petegg
//
//  Created by czx on 16/4/29.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "FeedSetingTableViewCell.h"

@implementation FeedSetingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 * W_Wide_Zoom, 15 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
//        _timeLabel.textColor = [UIColor blackColor];
//        _timeLabel.text = @"08:30";
//        _timeLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:_timeLabel];
        
        _timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 * W_Wide_Zoom, 15 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        [_timeBtn setTitle:@"08:30" forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_timeBtn];
        
        
        
        
        
        
        
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 59 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        _lineLabel.alpha = 0.6;
        [self addSubview:_lineLabel];
        
        
        _delectBtn = [[UIButton alloc]initWithFrame:CGRectMake(200 * W_Wide_Zoom, 15 * W_Hight_Zoom,23 * W_Wide_Zoom , 23 * W_Hight_Zoom)];
        [_delectBtn setImage:[UIImage imageNamed:@"delect_guize.png"] forState:UIControlStateNormal];
        [self addSubview:_delectBtn];
        
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(250 * W_Wide_Zoom, 15 * W_Hight_Zoom, 50 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.text = @"t1";
        _rightLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_rightLabel];
        
        
        
        
        
        
        
    }
    
    return  self;
}

@end