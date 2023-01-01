//
//  ViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/24.
//

#import "ViewController.h"
#import "TGDataItem.h"
#import <objc/runtime.h>
#import "UIView+TGCornerRadius.h"
#import "UIView+TGLine.h"
#import "UIView+TGHUD.h"
#import "TGButton.h"
#import "TGAlertUtils.h"
#import "TestViewController.h"
#import "SPActivityIndicatorTestViewController.h"
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic , strong) TGButton *customBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
//    swizzling_ExchangeMethod(nil, nil, nil);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, screenW, self.view.frame.size.height);
    self.coverView.frame = CGRectMake(100, 100, 200, 200);
    self.customBtn.frame = CGRectMake(100, 300, 40, 60);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s",__func__);
//    self.coverView.tg_lineColor = [UIColor redColor];
//    self.coverView.tg_lineWidth = 2;
//    self.coverView.tg_lineBottomEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
//    [self.coverView tg_showLintWithPosition:TGViewLinePositionBottom];
    //    self.coverView.tg_lineBottomEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
//    [self.coverView setCornerRadius:CGSizeMake(10, 10) corner:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft];
}

- (void)setupUI {
    self.navigationItem.title = @"Demo首页";
    [self.view addSubview:self.tableView];
//  [self.view addSubview:self.coverView];
    [self.view addSubview:self.customBtn];
}

#pragma mark Private


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TGObjcDemoCell"];
    TGDataItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TGDataItem *item = self.dataSource[indexPath.row];
    Class clazz = NSClassFromString(item.className);
    UIViewController *vc = [[clazz alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [self.view sw_makeToast:@"今天是个好日子" duration:2.0 position:SWHUDPositionBottom];
//    [self.view sw_makeToast:@"今天是个好日子" duration:2.0 position:SWHUDPositionCenter image:[UIImage imageNamed:@"lotus"]];
//    [self.view sw_makeInfoToast:@"今天是个好日子"];
//    [self.view sw_makeErrorToast:@"今天是个好日子"];
//    [self.view sw_makeSuccessToast:@"今天是个好日子"];
//    [self.view sw_makeLoading:@"加载中..."];
//    [TGAlertUtils handleAlertActionWithVC:self text:@"确定要删除吗?" okBlock:^{
//        NSLog(@"确定的");
//    }];
//    [TGAlertUtils handleAlertActionWithVC:self text:@"确定要删除吗?" okBlock:^{
//        NSLog(@"确定");
//    } cancleBlock:^{
//        NSLog(@"取消");
//    }];
    
//    [TGAlertUtils handleAlertActionWithVC:self title:@"tips" text:@"确定要删除吗?" ok:@"是的" cancel:@"取消" okBlock:^{
//        NSLog(@"确定");
//    } cancleBlock:^{
//        NSLog(@"取消");
//    }];
    
//    TestViewController *testVC = [[TestViewController alloc] init];
//    [self.navigationController pushViewController:testVC animated:YES];
    
//    SPActivityIndicatorTestViewController *vc = [[SPActivityIndicatorTestViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getter

- (TGButton *)customBtn {
    if (_customBtn == nil) {
        _customBtn = [[TGButton alloc] init];
        [_customBtn setTitle:@"选中" forState:UIControlStateNormal];
        [_customBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_customBtn setImage:[UIImage imageNamed:@"gl_nextTip_select"] forState:UIControlStateNormal];
        _customBtn.style = TGButtonStyleTitleBottom;
        _customBtn.space = 5;
        _customBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        _customBtn.imageSize = CGSizeMake(20, 20);
        _customBtn.backgroundColor = UIColor.lightGrayColor;
    }
    return _customBtn;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor lightGrayColor];
    }
    return _coverView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *footView =  [[UIView alloc] init];
        _tableView.tableFooterView = footView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TGObjcDemoCell"];
    }
    return _tableView;
}



- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
            [[TGDataItem alloc] init:@"Rac" withClassName:@"RacListTableViewController"],
            [[TGDataItem alloc] init:@"RunTime" withClassName:@"TGRuntimeListController"],
        ];
    }
    return _dataSource;
}


@end
