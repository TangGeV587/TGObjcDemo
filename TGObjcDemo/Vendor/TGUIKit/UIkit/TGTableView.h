//
//  TGTableView.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MJFooterStyle) {
    ///加载结束可以看到MJFooter和对应的提示文字
    MJFooterStyleGroup = 0,
    ///加载结束看不到MJFooter
    MJFooterStylePlain,
};

typedef NS_OPTIONS(NSUInteger, PlaceImgState) {
    ///暂无数据
    PlaceImgStateNoMoreData = 0,
    ///网络错误普遍处理
    PlaceImgStateNetErr,
    ///网络错误特定处理
    PlaceImgStateNetErrpecific,
    ///不显示错误占位图，仅弹窗提示
    PlaceImgStateOnlyToast,
};

typedef void(^headerBlock) (void);
typedef void(^footerBlock) (void);

NS_ASSUME_NONNULL_BEGIN

@interface TGTableView : UITableView

#pragma mark required
///设置数据源
@property(nonatomic, strong) NSMutableArray *dataList;

@property(nonatomic, strong) NSArray *cellReuseIdentifyList;
///设置重用标识
@property (nonatomic, copy) NSString * (^reuseIdentifyBlock)(NSIndexPath *indexPath);
///设置对应cell的高度
@property (nonatomic, copy) CGFloat (^heightForRowBlock)(NSIndexPath *indexPath);
/// 是否多组
@property (nonatomic, assign) BOOL isMuiltySection;
///配置cell
@property (nonatomic, copy) void (^configCellBlock)(NSIndexPath *indexPath,UITableViewCell *cell,id model);


#pragma mark optional

@property(nonatomic, strong) NSArray *sectionHeaderReuseIdList;

///设置重用sectionHeaderView标识
@property (nonatomic, copy) NSString *(^sectionHeaderViewReuseIdBlock)(NSInteger section);
///设置sectionHeaderView
@property (nonatomic, copy) void(^configSectionHeaderViewBlock)(UIView *sectionHeaderView, NSInteger section, id cotent);
///设置sectionHeaderView高度
@property (nonatomic, copy) CGFloat (^sectionHeaderHeightBlock)(NSInteger section);


///设置重用sectionFooterView标识
@property (nonatomic, copy) NSString * (^sectionFooterViewReuseIdBlock)(NSInteger section);
///设置sectionFooterView
@property (nonatomic, copy) UIView *(^configSectionFooterViewBlock)(UIView *sectionFooterView, NSInteger section, id cotent);
///设置sectionFooterView高度
@property (nonatomic, copy) CGFloat (^heightForFooterInSection)(NSInteger section);


///禁止系统Cell自动高度 可以有效解决tableView跳动问题
@property(nonatomic, assign)BOOL disableAutomaticDimension;

///无数据是否显示header，默认为NO
@property(nonatomic, assign)BOOL showHeaderWhenNoMsg;

///无数据是否显示footer，默认为NO
@property(nonatomic, assign)BOOL showFooterWhenNoMsg;

#pragma mark - 数据获取
///获取选中某一行
@property (nonatomic, copy) void (^didSelectedBlock)(NSIndexPath *indexPath,id model,UITableViewCell *cell);

///获取取消选中某一行
@property (nonatomic, copy) void (^didDeselectedAtIndexPath)(NSIndexPath *indexPath,id model,UITableViewCell *cell);

///滑动删除
@property (nonatomic, copy) NSArray<UITableViewRowAction *>* (^sideDeleteBlock)(NSIndexPath *indexPath);


///cell将要展示
@property (nonatomic, copy) void (^willDisplayCell)(NSIndexPath *indexPath,UITableViewCell *cell);

#pragma mark - 代理事件相关
///scrollView滚动事件
@property (nonatomic, copy) void (^scrollViewDidScroll)(UIScrollView *scrollView);

///scrollView缩放事件
@property (nonatomic, copy) void (^scrollViewDidZoom)(UIScrollView *scrollView);

///scrollView滚动到顶部事件
@property (nonatomic, copy) void (^scrollViewDidScrollToTop)(UIScrollView *scrollView);

///scrollView开始拖拽事件
@property (nonatomic, copy) void (^scrollViewWillBeginDragging)(UIScrollView *scrollView);

///scrollView开始拖拽事件
@property (nonatomic, copy) void (^scrollViewDidEndDragging)(UIScrollView *scrollView, BOOL willDecelerate);


#pragma mark - UITableViewDataSource & UITableViewDelegate
///tableView的DataSource 设置为当前控制器即可重写对应数据源方法
@property (nonatomic, weak, nullable) id <UITableViewDataSource> zxDataSource;

///tableView的Delegate 设置为当前控制器即可重写对应代理方法
@property (nonatomic, weak, nullable) id <UITableViewDelegate> zxDelegate;

#pragma mark - MJRefresh相关
///分页NO
@property(nonatomic,assign)NSUInteger pageNo;

///分页Count
@property(nonatomic,assign)NSUInteger pageCount;

///隐藏重新加载按钮 默认显示
@property(nonatomic, assign)BOOL hideReloadBtn;

///隐藏错误提示Toast 默认显示
@property(nonatomic, assign)BOOL hideMsgToast;

///是否固定错误提示占位图 默认为可以上下拖动
@property(nonatomic, assign)BOOL fixWhenNetErr;

///设置MJFooter样式（非必需），请在addFooter或addPagingWithReqSel之前设置。MJFooterStylePlain加载结束看不到MJFooter，MJFooterStyleGroup加载结束可以看到MJFooter和对应的提示文字，noMoreStr即为对应提示文字，默认为“已经全部加载完毕”，MJFooterStyle默认属性为MJFooterStyleGroup。
-(void)setMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *_Nullable)noMoreStr;

///添加MJHeader
-(void)addMJHeader:(headerBlock _Nullable )block;

///添加MJFooter
-(void)addMJFooter:(footerBlock _Nullable )block;

///添加MJFooter 同时设置样式
-(void)addMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *_Nullable)noMoreStr block:(footerBlock _Nullable )block;

///添加分页操作 传入请求分页数据的方法和方法所属的控制器
-(void)addPagingWithReqSel:(SEL _Nullable )sel target:(id)target;

///停止MJHeader和MJFooter刷新状态
-(void)endMjRef;

///分页接口调取完毕更新tableView状态，status为分页接口调取结果，YES为请求成功，NO为失败
-(void)updateTabViewStatus:(BOOL)status;

///分页接口调取完毕更新tableView状态，status为分页接口调取结果，YES为请求成功，NO为失败。 errDic为错误状态字典 backSel为用户点击重新刷新调用的方法 status = YES二者无效
-(void)updateTabViewStatus:(BOOL)status errDic:(NSDictionary *_Nullable)errDic backSel:(SEL _Nullable )backSel;


@end

NS_ASSUME_NONNULL_END
