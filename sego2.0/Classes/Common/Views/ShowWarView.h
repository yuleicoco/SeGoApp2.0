//
//  ShowWarView.h
//  sego2.0
//
//  Created by yulei on 16/11/15.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowDelegate <NSObject>

- (void)CancelMethod;
- (void)TryAgainMethod;



@end

@interface ShowWarView : UIView

@property (strong)UIView *ParentView;
@property (nonatomic,strong)UIButton * CancelBtn;
@property (nonatomic,strong)UIButton * TryAgainBtn;

@property (nonatomic,assign)id<ShowDelegate>delegate;

@end
