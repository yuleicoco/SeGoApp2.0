//
//  QFTableView.h
//  QFTableView
//
//

#import <UIKit/UIKit.h>

@protocol QFTableViewDataSource;
@protocol QFTableViewDelegate;

@interface QFTableView : UIView

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) id<QFTableViewDataSource>         dataSource;
@property (nonatomic, assign) id<QFTableViewDelegate>           delegate;
@property (nonatomic, assign) NSInteger                         currentIndex;
@property (nonatomic, assign) BOOL                              pagingEnabled;
//刷新视图
- (void)reloadData;
//滚动到指定的内容视图
- (void)QFTableViewScrollToIndex:(NSInteger)index animation:(BOOL)animation;
//获取当前视图所处的位置
- (UIView *)getViewInQFTableViewWithIndex:(NSInteger)index;
- (void)setTheBounces:(BOOL)bounces;
@end

@protocol QFTableViewDelegate <NSObject>

@optional

//选中某一个视图时，触发此方法
- (void)QFTableView:(QFTableView *)fanView selectIndex:(NSInteger)index;
//滚动到某一个视图时，触发此方法
- (void)QFTableView:(QFTableView *)fanView scrollToIndex:(NSInteger)index;

//停止拖拽时，触发此方法
- (void)QFTableViewDidEndDragging:(UITableView *)tableView;

//刷新当前视图，滚动时触发
- (void)scrollToRefreshView;

- (void)llcTableViewLoadMoreData;

@end

@protocol QFTableViewDataSource <NSObject>

@required
//每个子视图的宽度
- (CGFloat)QFTableView:(QFTableView *)fanView widthForIndex:(NSInteger)index;
//视图的总数
- (NSInteger)numberOfIndexForQFTableView:(QFTableView *)fanView;
//为CotentView中的子视图控件重新赋值
- (void)QFTableView:(QFTableView *)fanView setContentView:(UIView *)contentView ForIndex:(NSInteger)index;
//根据指定的frame返回UIView实例做为子视图
- (UIView *)QFTableView:(QFTableView *)fanView targetRect:(CGRect)targetRect ForIndex:(NSInteger)index;

@end