//
//  TGTableViewController.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "TGTableViewController.h"
#import <Masonry/Masonry.h>

@interface TGTableViewController ()<UIGestureRecognizerDelegate>{
    UITableViewStyle _style;
}

@property (nonatomic, strong) UIView *emptyView;
/** 数据为空的提醒label */
@property (nonatomic, strong)UILabel *emptyTipLabel;

@end

@implementation TGTableViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _style = UITableViewStyleGrouped;
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

#pragma maek - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_style];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}


- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIView new];
        _emptyView.userInteractionEnabled = YES;
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        
        UIImageView *emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_icon"]];
        emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_emptyView addSubview:emptyImageView];
        [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];

        self.emptyTipLabel = [[UILabel alloc]init];;
        self.emptyTipLabel.text = @"暂无数据...";
        self.emptyTipLabel.textColor = [UIColor whiteColor];
        self.emptyTipLabel.font = [UIFont systemFontOfSize:14];
        [_emptyView addSubview:self.emptyTipLabel];
        
        [self.emptyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(emptyImageView.mas_bottom).mas_offset(20);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadView)];
        [_emptyView addGestureRecognizer:tap];
    }
    return _emptyView;
}

#pragma mark - ======== life cycle ========
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化tableView
    [self tableView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}




- (void)setTableViewCanClick:(BOOL)tableViewCanClick {
    _tableViewCanClick = tableViewCanClick;
    
    self.tableView.userInteractionEnabled = tableViewCanClick;
}


#pragma mark - Refresh enable
- (void)setRefreshEnable:(BOOL)enable {
    [self setPullUpRefreshEnable:enable];
    [self setPullDownRefreshEnable:enable];
}

//上拉加载更多
- (void)setPullUpRefreshEnable:(BOOL)enable
{
//    if (enable) {
//        __weak typeof(self)weakSelf = self;
//        if (self.tableView.mj_footer == nil) {
//
//            MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                [weakSelf loadMoreDataSource];
//            }];
//            footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//            self.tableView.mj_footer = footer;
//        }
//    }else {
//        self.tableView.mj_footer = nil;
//    }
}

//下拉刷新
- (void)setPullDownRefreshEnable:(BOOL)enable
{
//    if (enable) {
//        __weak typeof(self)weakSelf = self;
//        if (self.tableView.mj_header == nil) {
//            MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                [weakSelf refreshDataSource];
//            }];
//            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//            self.tableView.mj_header = header;
//        }
//    }else {
//        self.tableView.mj_header = nil;
//    }
}

#pragma mark -
- (void)loadMoreDataSource {
    
}

- (void)refreshDataSource {
    
}


- (void)activateGotVertifyCodeBtn {}
/** 刷新界面 */
- (void)reloadView {}

- (void)showEmptyViewWithTitle:(NSString *)tipText {
    [self emptyView];
    self.emptyView.hidden = NO;
    self.emptyTipLabel.text = tipText;
    //    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
}

- (void)hiddenEmptyView {
    self.emptyView.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:%@", [self class]);
}

@end
