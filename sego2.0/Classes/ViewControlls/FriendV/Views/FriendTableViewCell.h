//
//  FriendTableViewCell.h
//  sego2.0
//
//  Created by czx on 16/11/29.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel * lineLabel;
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong)UILabel * nameLabel;

//添加
@property (nonatomic,strong)UIButton * rightBtn;
//右边的label
@property (nonatomic,strong)UILabel * rightLabe;
//拒绝按钮
@property (nonatomic,strong)UIButton * leftBtn;


@end
