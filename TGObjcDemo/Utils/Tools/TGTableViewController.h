//
//  TGTableViewController.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

/** tableview属性,公开是为了方便以后继承的修改 */
@property(nonatomic,strong) UITableView *tableView;

/** 列表视图是否可以点击 */
@property (nonatomic, getter=isTableViewCanClick) BOOL tableViewCanClick;

- (instancetype)initWithStyle:(UITableViewStyle)style;


- (void)setRefreshEnable:(BOOL)enable;
//上拉加载更多
- (void)setPullUpRefreshEnable:(BOOL)enable;
//下拉刷新
- (void)setPullDownRefreshEnable:(BOOL)enable;
/** MJRefresh 上拉加载 */
- (void)loadMoreDataSource;
/** MJRefresh 下拉刷新 */
- (void)refreshDataSource;

/**
 显示视图数据为空的提醒视图
 */
- (void)showEmptyViewWithTitle:(NSString *)tipText;

/**
 隐藏为空提醒视图
 */
- (void)hiddenEmptyView;


@end

NS_ASSUME_NONNULL_END
