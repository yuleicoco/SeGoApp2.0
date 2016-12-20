//
//  PopStartView.m
//  NewsTwoApp
//
//  Created by apple on 20/4/15.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PopStartView.h"

@implementation PopStartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_scrollView];
//        
//        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, [UIScreen mainScreen].bounds.size.height-90, 100, 60)];
//        [self addSubview:_pageControl];
        
        _PicArray = @[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg"];
//        _pageControl.numberOfPages = _PicArray.count;
//        _pageControl.currentPage = 0;
//        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.3f];
//        _pageControl.currentPageIndicatorTintColor = GREEN_COLOR;
//        _pageControl.userInteractionEnabled = YES;

        
        for(int i=0;i<_PicArray.count;i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
            
            imageView.image = [UIImage imageNamed:_PicArray[i]];
            imageView.tag = i+10;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(ontapScrollV:)];
            [imageView addGestureRecognizer:tap];
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize = CGSizeMake(_PicArray.count*[UIScreen mainScreen].bounds.size.width, _scrollView.frame.size.height);
        
    }
    return self;
}

//UIScrollViewDelegate代理中的函数 滑动完了以后被调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //用来计算pageView该显示第几个 scrollView.contentOffset.x
   // _pageControl.currentPage = scrollView.contentOffset.x/_scrollView.frame.size.width;
    self.page++;
    if (self.page >2) {
        if (self.delegate) {
            [self.delegate getScrollV:@""];
        }
         [self removeFromSuperview];
    }
    
}

- (void)ontapScrollV:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag == (_PicArray.count-1)+10) {//点击最后一张启动图片
        
        if (self.delegate) {
            [self.delegate getScrollV:@""];
        }
        
        [self removeFromSuperview];
    }
}

@end
