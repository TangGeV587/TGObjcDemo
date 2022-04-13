//
//  VideoListController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/12.
//

#import "VideoListController.h"
#import <MJRefresh.h>
#import "VideoViewModel.h"

#define  kDeviceWidth        [[UIScreen mainScreen] bounds].size.width
#define  kDeviceHeight       [[UIScreen mainScreen] bounds].size.height

@interface VideoListController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VideoViewModel *videoViewModel;

@end

@implementation VideoListController

#pragma mark - View Life Cycle

-(void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupBind];
}

- (void)setupUI{
    UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBar = [[UINavigationBarAppearance alloc] init];
        navBar.backgroundColor = bgColor;
        navBar.backgroundEffect = nil;
        self.navigationController.navigationBar.scrollEdgeAppearance = navBar;
        self.navigationController.navigationBar.standardAppearance = navBar;
    } else {
        // 常规配置方式
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:bgColor]®
//                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频列表";
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.videoViewModel.videoListCommand execute:@{@"headerRefresh":@"1"}];
    }];
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self.videoViewModel.videoListCommand execute:@{@"headerRefresh":@"0"}];
    }];
    
}

- (void)setupBind {
    self.videoViewModel.currentVC = self;
    self.tableView.dataSource = self.videoViewModel;
    self.tableView.delegate = self.videoViewModel;
    @weakify(self)
    [self.videoViewModel.resultSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self resetRefreshView];
        [self.tableView reloadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)resetRefreshView{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Getter && Setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 88);
        _tableView.estimatedRowHeight = 50.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (VideoViewModel *)videoViewModel{
    if (!_videoViewModel) {
        _videoViewModel = [[VideoViewModel alloc] init];
    }
    return _videoViewModel;
}


@end
