//
//  PopStartView.h
//  NewsTwoApp
//
//  Created by apple on 20/4/15.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetScrollVDelegate <NSObject>

- (void)getScrollV:(NSString *)popScroll;

@end

@interface PopStartView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign)  id<GetScrollVDelegate>delegate;

@property (strong,nonatomic) UIView*  ParentView;
@property (strong,nonatomic) NSArray* PicArray;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)NSInteger page;

@end
